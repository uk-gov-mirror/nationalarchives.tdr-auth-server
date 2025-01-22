package uk.gov.nationalarchives.eventpublisherspi

import org.keycloak.admin.client.resource.{RealmResource, UserResource, UsersResource}
import org.keycloak.admin.client.{Keycloak, KeycloakBuilder}
import org.keycloak.models.{KeycloakSession, UserModel, UserProvider}
import org.keycloak.representations.idm.UserRepresentation
import org.keycloak.timer.ScheduledTask

import scala.jdk.CollectionConverters._

class InactiveUserMonitoringTask(keycloakAdminClient: Keycloak) extends ScheduledTask {

  private val inactivePeriodMillis = 60 * 60 * 24 * 30 // 30 days
  private val disablePeriodMillis = 60 * 60 * 24 * 365 // 365 days

  override def run(session: KeycloakSession): Unit = {
    val realms = session.realms()
      .getRealmsStream.iterator().asScala.toList
    val userProvider: UserProvider = session.users()

    realms.foreach(realm => {
      session.getContext.setRealm(realm)
      val realmResource: RealmResource = keycloakAdminClient.realm(realm.getName)
      val users: List[UserModel] = userProvider.searchForUserStream(
        realm, Map[String, String]().asJava).iterator().asScala.toList
      users.map(user => inactiveUser(user, realmResource))
    })
  }

  private def inactiveUser(user: UserModel, realmResource: RealmResource): Unit = {
    // Note: reliant on user events being recorded and retained
    // Scenarios:
    // 1. User already disabled: no action
    // 2. User has no recorded login event:
    // * compare user created date (+ grace period) against current timestamp??? Would that work
    // 3. User has recorded login event
    // * compare most recent event (+ grace period) against current timestamp
    // *** avoid spamming if sent an email recently???? Check email events????

    val lastLoginEventTimestamp: Option[Long] = user match {
      case u if !u.isEnabled => None
      case _ =>
        Some(userLastLoginEventTime(realmResource, user.getId).getOrElse(user.getCreatedTimestamp))
    }

    lastLoginEventTimestamp match {
      case Some(ev) => userAction(ev, realmResource, user)
      case _ => ()
    }
  }

  private def userAction(timeStamp: Long, realmResource: RealmResource, user: UserModel): Unit = {
    val currentTimestamp = System.currentTimeMillis()
    if ((timeStamp + disablePeriodMillis) > currentTimestamp) {
      disableUser(realmResource, user)
    } else if ((timeStamp + inactivePeriodMillis) > currentTimestamp) {
      sendUserEmail(realmResource, user)
    }
  }

  private def userLastLoginEventTime(realmResource: RealmResource, userId: String): Option[Long] = {
    val events = realmResource.getEvents.asScala.toList
    events.filter(e => e.getUserId == userId && e.getType == "LOGIN").map(_.getTime).sorted match {
      case evs if evs.nonEmpty => Some(evs.last)
      case _ => None
    }
  }

  private def sendUserEmail(realmResource: RealmResource, user: UserModel): Unit = {
    val userResources: UsersResource = realmResource.users()
    val userResource: UserResource = userResources.get(user.getId)
    userResource.sendVerifyEmail()
  }

  private def disableUser(realmResource: RealmResource, user: UserModel): Unit = {
    val userResources: UsersResource = realmResource.users()
    val userRepresentation: UserRepresentation = userResources.get(user.getId).toRepresentation
    userRepresentation.setEnabled(false)
    userResources.get(user.getId).update(userRepresentation)
  }
}

object InactiveUserMonitoringTask {
  private val keycloakAdminClient = KeycloakBuilder.builder()
    .build()

  def apply(): InactiveUserMonitoringTask = new InactiveUserMonitoringTask(keycloakAdminClient)
}
