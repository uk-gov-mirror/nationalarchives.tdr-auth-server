package uk.gov.nationalarchives.credential

import io.quarkus.arc.Unremovable
import io.quarkus.credentials.CredentialsProvider
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.rds.RdsUtilities
import software.amazon.awssdk.services.rds.model.GenerateAuthenticationTokenRequest

import java.util
import javax.enterprise.context.ApplicationScoped
import javax.inject.Named
import scala.jdk.CollectionConverters._
import scala.util.{Failure, Success, Try}
import scalacache.CacheConfig
import scalacache.caffeine.CaffeineCache
import scalacache.memoization._
import scalacache.modes.try_._

import scala.concurrent.duration._

@ApplicationScoped
@Unremovable
@Named("rds-credentials-provider")
class RDSCredentialsProvider extends CredentialsProvider {

  implicit val passwordCache: CaffeineCache[String] = CaffeineCache[String](CacheConfig())

  val port: Int = 5432
  val userName: String = "keycloak_user"

  def generatePassword(envVars: Map[String, String], rdsClient: RdsUtilities): String = {
    val keycloakHost: String = envVars("KEYCLOAK_HOST")
    if (keycloakHost.contains("localhost")) {
      envVars("KC_DB_PASSWORD")
    } else {
      val request = GenerateAuthenticationTokenRequest.builder()
        .credentialsProvider(DefaultCredentialsProvider.builder().build())
        .hostname(envVars("KC_DB_URL_HOST"))
        .port(port)
        .username(userName)
        .region(Region.EU_WEST_2)
        .build()
      rdsClient.generateAuthenticationToken(request)
    }
  }

  override def getCredentials(credentialsProviderName: String): util.Map[String, String] = {
    memoize[Try, String](Some(5.minutes)) {
      val rdsClient: RdsUtilities = RdsUtilities.builder().region(Region.EU_WEST_2).build()
      generatePassword(sys.env, rdsClient)
    } match {
      case Failure(exception) => throw exception
      case Success(password) => Map("user" -> userName, "password" -> password).asJava
    }
  }
}
