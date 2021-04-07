package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.email.{EmailException, EmailSenderProvider}
import org.keycloak.models.UserModel
import uk.gov.service.notify.NotificationClient

import scala.jdk.CollectionConverters._
import scala.util.{Failure, Success, Try}

class NotifyEmailSenderProvider(environmentVariables: Map[String, String]) extends EmailSenderProvider {

  private val apiKey = "GOVUK_NOTIFY_API_KEY"
  private val templateIdKey = "GOVUK_NOTIFY_TEMPLATE_ID"

  override def send(config: util.Map[String, String],
                     user: UserModel,
                     subject: String,
                     textBody: String,
                     htmlBody: String): Unit = {

    val clientApiKey: String = environmentVariables.get(apiKey) match {
      case Some(key) => key
      case _ => throw new EmailException("Missing GovUk Notify api key")
    }

    val templateId: String = environmentVariables.get(templateIdKey) match {
      case Some(templateId) => templateId
      case _ => throw new EmailException("Missing GovUk Notify template id")
    }

    val notifyClient = new NotificationClient(clientApiKey)

    val personalisation: Map[String, String] = Map(
      "keycloakMessage" -> textBody,
      "keycloakSubject" -> subject)

    sendNotifyEmail(notifyClient, NotifyEmailInfo(templateId, user.getEmail, personalisation, user.getId))
  }

  override def close(): Unit = { }

  def sendNotifyEmail(notifyClient: NotificationClient, emailInfo: NotifyEmailInfo): Unit = {
    Try {
      notifyClient.sendEmail(
        emailInfo.templateId,
        emailInfo.userEmail,
        emailInfo.personalisation.asJava,
        emailInfo.reference)
    } match {
      case Failure(exception) => throw new EmailException(exception)
      case Success(_) => ()
    }
  }
}

case class NotifyEmailInfo(templateId: String, userEmail: String, personalisation: Map[String, String], reference: String)
