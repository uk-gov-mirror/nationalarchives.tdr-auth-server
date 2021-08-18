package uk.gov.nationalarchives.eventpublisherspi.helpers

import io.circe.generic.semiauto.{deriveDecoder, deriveEncoder}
import io.circe.{Decoder, Encoder, parser}
import org.keycloak.events.admin.{AdminEvent, OperationType, ResourceType}
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.{EventDetails, RoleMappingRepresentation}

object EventUtils {
  implicit val roleMappingRepresentationDecoder: Decoder[RoleMappingRepresentation] = deriveDecoder[RoleMappingRepresentation]
  implicit val eventDetailsEncoder: Encoder[EventDetails] = deriveEncoder

  implicit class AdminEventUtils(event: AdminEvent) {
    def roleMappingRepresentation(): RoleMappingRepresentation = parser.decode[List[RoleMappingRepresentation]](event.getRepresentation)
      match {
        case Right(r) => r.head
        case Left(e) => throw e
      }

    def isAdminRoleAssignment(): Boolean = event.getResourceType == ResourceType.REALM_ROLE_MAPPING &&
      event.getOperationType == OperationType.CREATE && roleMappingRepresentation().name.getOrElse("") == "admin"
  }
}
