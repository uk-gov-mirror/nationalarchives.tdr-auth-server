package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.email.EmailSenderProvider
import org.keycloak.models.UserModel
import uk.gov.service.notify.{NotificationClient, NotificationClientException}

import scala.jdk.CollectionConverters._

class NotifyEmailSenderProvider(notifyClient: NotificationClient) extends EmailSenderProvider {

  private val templateIdKey = "GOVUK_NOTIFY_TEMPLATE_ID"

  override def send(config: util.Map[String, String],
                     user: UserModel,
                     subject: String,
                     textBody: String,
                     htmlBody: String): Unit = {

    val templateId: String = sys.env.get(templateIdKey) match {
      case Some(id) => id
      case _ => throw new NotificationClientException("Missing GovUk Notify templated id")
    }

    val personalisation: Map[String, String] = Map(
      "keycloakMessage" -> textBody,
      "keycloakSubject" -> subject)

    try {
      notifyClient.sendEmail(
        templateId,
        user.getEmail,
        personalisation.asJava,
        user.getId)
    } catch {
      case e: NotificationClientException => e.printStackTrace()
    }
  }

  override def close(): Unit = { }
}
