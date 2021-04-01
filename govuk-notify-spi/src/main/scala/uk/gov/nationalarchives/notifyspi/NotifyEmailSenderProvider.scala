package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.email.EmailSenderProvider
import org.keycloak.models.UserModel
import org.keycloak.email.EmailException
import uk.gov.service.notify.NotificationClient

import scala.jdk.CollectionConverters._
import scala.util.{Failure, Success, Try}

class NotifyEmailSenderProvider(notifyClient: NotificationClient) extends EmailSenderProvider {

  private val templateIdKey = "GOVUK_NOTIFY_TEMPLATE_ID"

  override def send(config: util.Map[String, String],
                     user: UserModel,
                     subject: String,
                     textBody: String,
                     htmlBody: String): Unit = {

    val templateId: String = sys.env.get(templateIdKey) match {
      case Some(id) => id
      case _ => throw new EmailException("Missing GovUk Notify templated id")
    }

    val personalisation: Map[String, String] = Map(
      "keycloakMessage" -> textBody,
      "keycloakSubject" -> subject)

    Try {
      notifyClient.sendEmail(
        templateId,
        user.getEmail,
        personalisation.asJava,
        user.getId)
    } match {
      case Failure(exception) => new EmailException(exception)
      case Success(_) => ()
    }
  }

  override def close(): Unit = { }
}
