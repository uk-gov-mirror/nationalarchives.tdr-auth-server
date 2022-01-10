import sbt._

object Dependencies {
  private val keycloakVersion = "16.1.0"

  lazy val keycloakCore      = "org.keycloak" % "keycloak-core" % keycloakVersion % "provided"
  lazy val keycloakServerSpi = "org.keycloak" % "keycloak-server-spi" % keycloakVersion % "provided"
  lazy val keycloakModelJpa  = "org.keycloak" % "keycloak-model-jpa" % keycloakVersion % "provided"
  lazy val mockito           = "org.mockito" %% "mockito-scala" % "1.14.1"
  lazy val scalaTest         = "org.scalatest" %% "scalatest" % "3.2.2"
  lazy val awsUtils          = "uk.gov.nationalarchives.aws.utils" %% "tdr-aws-utils" % "0.1.17"
}
