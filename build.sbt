import Dependencies._

lazy val projectScalaVersion = "2.13.8"

lazy val commonDependencies: List[ModuleID] = List(
  keycloakCore,
  keycloakModelJpa,
  keycloakServerSpi,
  mockito % Test,
  scalaTest % Test
)

fork in Test := true

lazy val eventPublisherSpi = (project in file("./event-publisher-spi"))
  .settings(
    name := "event-publisher-spi",
    scalaVersion := projectScalaVersion,
    Test / fork := true,
    libraryDependencies ++= awsUtils :: commonDependencies,
    assemblyJarName in assembly := "event-publisher-spi.jar"
  )

lazy val govUKNotifySPI = (project in file("./govuk-notify-spi"))
  .settings(
    name := "govuk-notify-spi",
    scalaVersion := projectScalaVersion,
    Test / fork := true,
    libraryDependencies ++= notifyJavaClient :: commonDependencies,
    assemblyJarName in assembly := "govuk-notify-spi.jar"
  )
