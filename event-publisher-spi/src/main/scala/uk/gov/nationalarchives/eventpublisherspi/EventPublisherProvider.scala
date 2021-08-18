package uk.gov.nationalarchives.eventpublisherspi

import java.net.URI

import io.circe.syntax.EncoderOps
import org.keycloak.events.admin.AdminEvent
import org.keycloak.events.{Event, EventListenerProvider}
import org.keycloak.models.KeycloakSession
import software.amazon.awssdk.http.apache.ApacheHttpClient
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.sns.SnsClient
import uk.gov.nationalarchives.aws.utils.SNSUtils
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.{EventDetails, EventPublisherConfig}
import uk.gov.nationalarchives.eventpublisherspi.helpers.EventUtils.{AdminEventUtils, eventDetailsEncoder}

class EventPublisherProvider(config: EventPublisherConfig, session: KeycloakSession, snsUtils: SNSUtils) extends EventListenerProvider {

  override def onEvent(event: Event): Unit = {
    //Currently no events published
  }

  override def onEvent(event: AdminEvent, includeRepresentation: Boolean = true): Unit = {
    if (event.isAdminRoleAssignment()) { publishAdminEvent(adminRoleAssignmentMessage, event) }
  }

  override def close(): Unit = { }

  def publishAdminEvent(f: AdminEvent => String, event: AdminEvent): Unit = {
    snsUtils.publish(f(event), config.snsTopicArn)
  }

  private def adminRoleAssignmentMessage(event: AdminEvent): String = {
    val userId = event.getAuthDetails.getUserId()
    val realm = session.realms().getRealm(event.getRealmId())
    val affectedUserId = event.getResourcePath.split("/").tail.head
    val callingUser = session.users().getUserById(userId, realm)
    val affectedUser = session.users().getUserById(affectedUserId, realm)
    val message = s"User ${callingUser.getUsername}" +
      s" has assigned role 'admin' to user ${affectedUser.getUsername}" +
      s" from ip ${event.getAuthDetails.getIpAddress}" +
      s" in the ${event.roleMappingRepresentation().containerId.getOrElse("")} realm"
    EventDetails(config.tdrEnvironment, message).asJson.toString()
  }
}

object EventPublisherProvider {
  private val httpClient = ApacheHttpClient.builder.build

  def apply(config: EventPublisherConfig, session: KeycloakSession): EventPublisherProvider = {
    val snsUtils: SNSUtils = SNSUtils(SnsClient.builder()
      .region(Region.EU_WEST_2)
      .endpointOverride(URI.create(config.sqsUrl))
      .httpClient(httpClient)
      .build())

    new EventPublisherProvider(config, session, snsUtils)
  }

  case class EventPublisherConfig(sqsUrl: String, snsTopicArn: String, tdrEnvironment: String)
  case class EventDetails(tdrEnv: String, message: String)
  case class RoleMappingRepresentation(id: Option[String] = None,
                                       name: Option[String] = None,
                                       description: Option[String] = None,
                                       composite: Option[Boolean] = None,
                                       clientRole: Option[Boolean] = None,
                                       containerId: Option[String] = None)
}
