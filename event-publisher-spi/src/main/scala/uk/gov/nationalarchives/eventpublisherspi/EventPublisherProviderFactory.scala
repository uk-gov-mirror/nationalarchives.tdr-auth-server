package uk.gov.nationalarchives.eventpublisherspi

import org.keycloak.Config
import org.keycloak.events.{EventListenerProvider, EventListenerProviderFactory}
import org.keycloak.models.utils.PostMigrationEvent
import org.keycloak.models.{KeycloakSession, KeycloakSessionFactory}
import org.keycloak.timer.TimerProvider
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.EventPublisherConfig

class EventPublisherProviderFactory extends EventListenerProviderFactory {
  private val eventPublisherId = "event-publisher"

  var eventPublisherConfig: Option[EventPublisherConfig] = None

  var oneDayIntervalMillis: Long = 24 * 60 * 60 * 1000

  override def create(session: KeycloakSession): EventListenerProvider = {
    EventPublisherProvider(eventPublisherConfig.get, session)
  }

  override def init(config: Config.Scope): Unit = {
    val tdrEnvironment = sys.env("TDR_ENV")
    val snsUrl = sys.env("SNS_TOPIC_ARN")
    eventPublisherConfig = Option(EventPublisherConfig(snsUrl, tdrEnvironment))
  }

  override def postInit(factory: KeycloakSessionFactory): Unit = {
    factory.register(event => {
      if(event.isInstanceOf[PostMigrationEvent]) {
        val session = factory.create()
        val provider: TimerProvider = session.getProvider(classOf[TimerProvider])
        val userMonitoringTask = UserMonitoringTask(eventPublisherConfig.get)
        val inactiveUserMonitoringTask = InactiveUserMonitoringTask()
        provider.scheduleTask(userMonitoringTask, oneDayIntervalMillis, "userMonitoringTask")
        provider.scheduleTask(inactiveUserMonitoringTask, oneDayIntervalMillis, "inactiveUserMonitoringTask")
      }
    })
  }

  override def close(): Unit = { }

  override def getId: String = {
    eventPublisherId
  }
}
