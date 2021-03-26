package uk.gov.nationalarchives.notifyspi

import java.util

import org.keycloak.models.UserModel
import org.mockito.ArgumentCaptor
import org.mockito.MockitoSugar.{mock, when}
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.service.notify.{NotificationClient, SendEmailResponse}

import scala.jdk.CollectionConverters._

class NotifyEmailSenderProviderSpec extends AnyFlatSpec with Matchers {

  "the send function" should "call the client sendEmail function with the correct arguments" in {

    val templateIdCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val emailAddressCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])
    val personalizationCaptor: ArgumentCaptor[util.Map[String, String]] = ArgumentCaptor.forClass(classOf[util.Map[String, String]])
    val referenceCaptor: ArgumentCaptor[String] = ArgumentCaptor.forClass(classOf[String])

    val notificationClient = mock[NotificationClient]
    val user = mock[UserModel]
    val subject = "Some subject"
    val textBody = "Some text body"
    val htmlBody = "html body"
    val response = mock[SendEmailResponse]

    when(user.getEmail).thenReturn("user@something.com")
    when(user.getId).thenReturn("userId")

    when(notificationClient.sendEmail(
      templateIdCaptor.capture(),
      emailAddressCaptor.capture(),
      personalizationCaptor.capture(),
      referenceCaptor.capture()
    )).thenReturn(response)

    val emailSenderProvider = new NotifyEmailSenderProvider(notificationClient)
    emailSenderProvider.send(Map[String, String]().asJava, user, subject, textBody, htmlBody)

    templateIdCaptor.getValue should equal("testTemplateId")
    emailAddressCaptor.getValue should equal("user@something.com")
    referenceCaptor.getValue should equal("userId")

    val personalizationArgument = personalizationCaptor.getValue.asScala
    personalizationArgument.get("keycloakSubject") should equal(Some("Some subject"))
    personalizationArgument.get("keycloakMessage") should equal(Some("Some text body"))
  }
}
