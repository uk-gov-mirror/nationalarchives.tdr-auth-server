package uk.gov.nationalarchives.notifyspi

import org.keycloak.email.EmailException
import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.any
import org.mockito.MockitoSugar.{mock, when}
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.service.notify.{NotificationClient, NotificationClientException, SendEmailResponse}

import java.util
import scala.jdk.CollectionConverters._

class NotifyEmailSenderProviderSpec extends AnyFlatSpec with Matchers {

  private val userEmail = "user@something.com"
  private val userId = "userId"

  "the sendNotifyEmail function" should "call the notification client sendEmail function with the correct arguments" in {
    val templateIdCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val emailAddressCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val personalizationCaptor: ArgumentCaptor[util.Map[String, String]] = ArgumentCaptor.forClass(classOf[util.Map[String, String]])
    val referenceCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])

    val notificationClient = mock[NotificationClient]
    val response = mock[SendEmailResponse]

    when(notificationClient.sendEmail(
      templateIdCaptor.capture(),
      emailAddressCaptor.capture(),
      personalizationCaptor.capture(),
      referenceCaptor.capture()
    )).thenReturn(response)

    val emailInfo = NotifyEmailInfo("templateId", userEmail, Map("keycloakSubject" -> "Some subject", "keycloakMessage" -> "Some text body"), userId)
    val emailSenderProvider = new NotifyEmailSenderProvider()
    emailSenderProvider.sendNotifyEmail(notificationClient, emailInfo)

    templateIdCaptor.getValue should equal("templateId")
    emailAddressCaptor.getValue should equal(userEmail)
    referenceCaptor.getValue should equal(userId)

    val personalizationArgument = personalizationCaptor.getValue.asScala
    personalizationArgument.get("keycloakSubject") should equal(Some("Some subject"))
    personalizationArgument.get("keycloakMessage") should equal(Some("Some text body"))
  }

  "the sendNotifyEmail function" should "throw an EmailException error if the notification client sendEmail function fails" in {
    val notificationClient = mock[NotificationClient]

    when(notificationClient.sendEmail(
      any[String],
      any[String],
      any[util.Map[String, String]],
      any[String]
    )).thenThrow(new NotificationClientException("Notification client error"))

    val emailSenderProvider = new NotifyEmailSenderProvider()

    val ex = intercept[Exception] {
      emailSenderProvider.sendNotifyEmail(notificationClient, NotifyEmailInfo("", "", Map(), ""))
    }

    ex.isInstanceOf[EmailException] should be(true)
    ex.getMessage should be("uk.gov.service.notify.NotificationClientException: Notification client error")
  }
}
