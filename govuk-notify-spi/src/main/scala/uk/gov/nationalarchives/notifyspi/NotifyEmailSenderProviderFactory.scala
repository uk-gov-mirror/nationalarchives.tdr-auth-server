package uk.gov.nationalarchives.notifyspi

import org.keycloak.Config
import org.keycloak.email.{EmailSenderProvider, EmailSenderProviderFactory}
import org.keycloak.models.{KeycloakSession, KeycloakSessionFactory}

class NotifyEmailSenderProviderFactory extends EmailSenderProviderFactory {

  private val emailSenderId = "govuknotify"

  override def create(session: KeycloakSession): EmailSenderProvider = {
    new NotifyEmailSenderProvider(sys.env)
  }

  override def init(config: Config.Scope): Unit = { }

  override def postInit(factory: KeycloakSessionFactory): Unit = { }

  override def close(): Unit = { }

  override def getId: String = {
    emailSenderId
  }
}
