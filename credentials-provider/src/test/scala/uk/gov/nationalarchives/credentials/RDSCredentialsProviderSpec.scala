package uk.gov.nationalarchives.credentials

import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.any
import org.mockito.MockitoSugar.{mock, times, verify, when}
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import software.amazon.awssdk.services.rds.RdsUtilities
import software.amazon.awssdk.services.rds.model.GenerateAuthenticationTokenRequest
import uk.gov.nationalarchives.credential.RDSCredentialsProvider

class RDSCredentialsProviderSpec extends AnyFlatSpec with Matchers {
  "generatePassword" should "return the password from environment variables if the host is localhost" in {
    val provider = new RDSCredentialsProvider()
    val expectedPassword = "password"
    val envVars = Map("KEYCLOAK_HOST" -> "localhost:8081", "KC_DB_PASSWORD" -> expectedPassword)

    val generatedPassword = provider.generatePassword(envVars, mock[RdsUtilities])
    generatedPassword should equal(expectedPassword)
  }

  "generatePassword" should "return the password from AWS if the host is not localhost" in {
    val envVars = Map("KEYCLOAK_HOST" -> "test", "KC_DB_URL_HOST" -> "host")
    val  rdsUtilities = mock[RdsUtilities]
    val expectedPassword = "awsPassword"
    when(rdsUtilities.generateAuthenticationToken(any[GenerateAuthenticationTokenRequest])).thenReturn(expectedPassword)
    val provider = new RDSCredentialsProvider()
    val generatedPassword = provider.generatePassword(envVars, rdsUtilities)

    generatedPassword should equal(expectedPassword)

    verify(rdsUtilities, times(1)).generateAuthenticationToken(any[GenerateAuthenticationTokenRequest])
  }

  "generatePassword" should "pass the correct host to AWS" in {
    val hostName = "hostName"
    val envVars = Map("KEYCLOAK_HOST" -> "test", "KC_DB_URL_HOST" -> hostName)
    val  rdsUtilities = mock[RdsUtilities]
    val expectedPassword = "awsPassword"
    val tokenRequest: ArgumentCaptor[GenerateAuthenticationTokenRequest] = ArgumentCaptor.forClass(classOf[GenerateAuthenticationTokenRequest])

    when(rdsUtilities.generateAuthenticationToken(tokenRequest.capture())).thenReturn(expectedPassword)

    val provider = new RDSCredentialsProvider()
    provider.generatePassword(envVars, rdsUtilities)
    tokenRequest.getValue.hostname should equal(hostName)
  }
}
