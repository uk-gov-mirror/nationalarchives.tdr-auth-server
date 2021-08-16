package uk.gov.nationalarchives.eventpublisherspi

import java.net.URI

import io.circe.Encoder
import io.circe.generic.semiauto.deriveEncoder
import io.circe.syntax.EncoderOps
import org.jboss.logging.Logger
import org.keycloak.events.admin.{AdminEvent, OperationType, ResourceType}
import org.keycloak.events.{Event, EventListenerProvider}
import org.keycloak.models.KeycloakSession
import software.amazon.awssdk.http.apache.ApacheHttpClient
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.sns.SnsClient
import uk.gov.nationalarchives.aws.utils.SNSUtils
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.{EventDetails, EventPublisherConfig}

class EventPublisherProvider(config: EventPublisherConfig, session: KeycloakSession, snsUtils: SNSUtils) extends EventListenerProvider {
  val logger = Logger.getLogger(classOf[EventPublisherProvider])

  implicit class AdminEventUtils(event: AdminEvent) {

    def isAdminRoleAssignment(): Boolean = event.getResourceType == ResourceType.REALM_ROLE_MAPPING &&
      event.getOperationType == OperationType.CREATE && event.getRepresentation.contains("admin")
  }

  implicit val eventDetailsEncoder: Encoder[EventDetails] = deriveEncoder

  override def onEvent(event: Event): Unit = { }

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
      s" has assigned role 'admin' to user ${affectedUser.getUsername} from ip ${event.getAuthDetails.getIpAddress}"
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
}
