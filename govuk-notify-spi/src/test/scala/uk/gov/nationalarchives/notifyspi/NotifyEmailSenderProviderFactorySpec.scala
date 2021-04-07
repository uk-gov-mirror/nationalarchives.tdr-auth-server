package uk.gov.nationalarchives.notifyspi

import org.keycloak.models.KeycloakSession
import org.mockito.MockitoSugar.mock
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class NotifyEmailSenderProviderFactorySpec extends AnyFlatSpec with Matchers {

  "the create function" should "return a Notify email provider" in {
    val factory = new NotifyEmailSenderProviderFactory
    val keycloakSession = mock[KeycloakSession]

    val emailSenderProvider = factory.create(keycloakSession)
    emailSenderProvider.isInstanceOf[NotifyEmailSenderProvider] should be(true)
  }

  "the getId function" should "return the correct id value for the email provider" in {
    val factory = new NotifyEmailSenderProviderFactory

    factory.getId should equal("govuknotify")
  }
}
