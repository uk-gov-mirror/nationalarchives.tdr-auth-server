import sbt._

object Dependencies {
  private val keycloakVersion = "11.0.3"

  lazy val typeSafeConfig    = "com.typesafe" % "config" % "1.4.1"
  lazy val notifyJavaClient  = "uk.gov.service.notify" % "notifications-java-client" % "3.17.0-RELEASE"
  lazy val keycloakCore      = "org.keycloak" % "keycloak-core" % keycloakVersion % "provided"
  lazy val keycloakServerSpi = "org.keycloak" % "keycloak-server-spi" % keycloakVersion % "provided"
  lazy val keycloakModelJpa  = "org.keycloak" % "keycloak-model-jpa" % keycloakVersion % "provided"
}
