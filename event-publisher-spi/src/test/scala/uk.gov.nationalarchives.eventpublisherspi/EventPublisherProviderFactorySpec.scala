package uk.gov.nationalarchives.eventpublisherspi

import org.keycloak.models.KeycloakSession
import org.mockito.MockitoSugar.mock
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.EventPublisherConfig

class EventPublisherProviderFactorySpec extends AnyFlatSpec with Matchers {

  "the create function" should "return a event Publisher provider" in {
    val factory = new EventPublisherProviderFactory
    val mockKeycloakSession = mock[KeycloakSession]
    factory.eventPublisherConfig = Some(EventPublisherConfig("snsTopicArn", "tdrEnv"))

    val eventPublisherProvider = factory.create(mockKeycloakSession)
    eventPublisherProvider.isInstanceOf[EventPublisherProvider] should be(true)
  }

  "the getId function" should "return the correct id value for the event publisher provider" in {
    val factory = new EventPublisherProviderFactory

    factory.getId should equal("event-publisher")
  }
}
