package uk.gov.nationalarchives.notifyspi

import org.keycloak.Config
import org.keycloak.email.{EmailSenderProvider, EmailSenderProviderFactory}
import org.keycloak.models.{KeycloakSession, KeycloakSessionFactory}
import uk.gov.service.notify.NotificationClient

class NotifyEmailSenderProviderFactory extends EmailSenderProviderFactory {

  private val emailSenderId = "govuknotify"
  private val apiKey = "GOVUK_NOTIFY_API_KEY"

  override def create(session: KeycloakSession): EmailSenderProvider = {
    val clientApiKey: String = sys.env.get(apiKey) match {
      case Some(key) => key
      case _ => throw new RuntimeException("Missing GovUk Notify Api Key")
    }

    val notificationClient = new NotificationClient(clientApiKey)
    new NotifyEmailSenderProvider(notificationClient)
  }

  override def init(config: Config.Scope): Unit = { }

  override def postInit(factory: KeycloakSessionFactory): Unit = { }

  override def close(): Unit = { }

  override def getId: String = {
    emailSenderId
  }
}
