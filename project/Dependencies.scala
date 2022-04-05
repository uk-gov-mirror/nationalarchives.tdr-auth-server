import sbt._

object Dependencies {
  private val keycloakVersion = "16.1.0"

  lazy val keycloakCore: ModuleID = "org.keycloak" % "keycloak-core" % keycloakVersion % "provided"
  lazy val keycloakServerSpi: ModuleID = "org.keycloak" % "keycloak-server-spi" % keycloakVersion % "provided"
  lazy val keycloakModelJpa: ModuleID = "org.keycloak" % "keycloak-model-jpa" % keycloakVersion % "provided"
  lazy val mockito: ModuleID = "org.mockito" %% "mockito-scala" % "1.14.1"
  lazy val notifyJavaClient: ModuleID = "uk.gov.service.notify" % "notifications-java-client" % "3.17.0-RELEASE"
  lazy val scalaTest: ModuleID = "org.scalatest" %% "scalatest" % "3.2.2"
  lazy val awsUtils: ModuleID = "uk.gov.nationalarchives" %% "tdr-aws-utils" % "0.1.27"
}
