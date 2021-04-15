import Dependencies._

scalaVersion := "2.13.4"

lazy val root = (project in file("."))
  .settings(
    name := "govuk-notify-spi",
    scalaVersion := "2.13.4",
    libraryDependencies ++= Seq(
      keycloakCore,
      keycloakModelJpa,
      keycloakServerSpi,
      mockito % Test,
      notifyJavaClient,
      scalaTest % Test
    ),
    assemblyJarName in assembly := "govuk-notify-spi.jar",
    fork in Test := true
  )
