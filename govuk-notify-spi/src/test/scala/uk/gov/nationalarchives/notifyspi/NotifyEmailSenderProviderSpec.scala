package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.email.EmailException
import org.keycloak.models.UserModel
import org.mockito.ArgumentCaptor
import org.mockito.ArgumentMatchers.any
import org.mockito.MockitoSugar.{mock, when}
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.service.notify.{NotificationClient, NotificationClientException, SendEmailResponse}

import scala.jdk.CollectionConverters._

class NotifyEmailSenderProviderSpec extends AnyFlatSpec with Matchers {

  private val subject = "Some subject"
  private val textBody = "Some text body"
  private val htmlBody = "html body"

  private val mockUser = mock[UserModel]

  "the send function" should "call the client sendEmail function with the correct arguments" in {

    val templateIdCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val emailAddressCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val personalizationCaptor: ArgumentCaptor[util.Map[String, String]] = ArgumentCaptor.forClass(classOf[util.Map[String, String]])
    val referenceCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])

    val notificationClient = mock[NotificationClient]
    val user = mock[UserModel]
    val response = mock[SendEmailResponse]

    when(mockUser.getEmail).thenReturn("user@something.com")
    when(mockUser.getId).thenReturn("userId")

    when(notificationClient.sendEmail(
      templateIdCaptor.capture(),
      emailAddressCaptor.capture(),
      personalizationCaptor.capture(),
      referenceCaptor.capture()
    )).thenReturn(response)

    val emailSenderProvider = new NotifyEmailSenderProvider(notificationClient)
    emailSenderProvider.send(Map[String, String]().asJava, mockUser, subject, textBody, htmlBody)

    templateIdCaptor.getValue should equal("testTemplateId")
    emailAddressCaptor.getValue should equal("user@something.com")
    referenceCaptor.getValue should equal("userId")

    val personalizationArgument = personalizationCaptor.getValue.asScala
    personalizationArgument.get("keycloakSubject") should equal(Some("Some subject"))
    personalizationArgument.get("keycloakMessage") should equal(Some("Some text body"))
  }

  "the send function" should "throw an EmailException error if the notification client sendEmail function fails" in {
    val notificationClient = mock[NotificationClient]
    when(mockUser.getEmail).thenReturn("user@something.com")
    when(mockUser.getId).thenReturn("userId")

    when(notificationClient.sendEmail(
      any[String],
      any[String],
      any[util.Map[String, String]],
      any[String]
    )).thenThrow(new NotificationClientException("Notification client error"))

    val emailSenderProvider = new NotifyEmailSenderProvider(notificationClient)

    val ex = intercept[Exception] {
      emailSenderProvider.send(Map[String, String]().asJava, mockUser, subject, textBody, htmlBody)
    }

    ex.isInstanceOf[EmailException] should be(true)
    ex.getMessage should be("uk.gov.service.notify.NotificationClientException: Notification client error")
  }
}
