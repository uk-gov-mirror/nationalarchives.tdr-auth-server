package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.email.{EmailException, EmailSenderProvider}
import org.keycloak.models.UserModel
import uk.gov.service.notify.NotificationClient

import scala.jdk.CollectionConverters._
import scala.util.{Failure, Success, Try}

class NotifyEmailSenderProvider(environmentVariables: Map[String, String]) extends EmailSenderProvider {

  private implicit class EnvironmentalVariablesUtils(map: Map[String, String]) {
    def getApiKey: String = {
      retrieveValue("GOVUK_NOTIFY_API_KEY")
    }

    def getTemplateId: String = {
      retrieveValue("GOVUK_NOTIFY_TEMPLATE_ID")
    }

    private def retrieveValue(key: String): String = {
      map.get(key) match {
        case Some(value) => value
        case _ => throw new EmailException(s"Missing '$key' value")
      }
    }
  }

  override def send(config: util.Map[String, String],
                     user: UserModel,
                     subject: String,
                     textBody: String,
                     htmlBody: String): Unit = {

    val notifyClient = new NotificationClient(environmentVariables.getApiKey)

    val personalisation: Map[String, String] = Map(
      "keycloakMessage" -> textBody,
      "keycloakSubject" -> subject)

    sendNotifyEmail(notifyClient, NotifyEmailInfo(environmentVariables.getTemplateId, user.getEmail, personalisation, user.getId))
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

  override def send(config: util.Map[String, String], address: String, subject: String, textBody: String, htmlBody: String): Unit = ()
}

case class NotifyEmailInfo(templateId: String, userEmail: String, personalisation: Map[String, String], reference: String)
