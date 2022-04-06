import Dependencies._

lazy val commonSettings = Seq(
  scalaVersion := "2.13.8",
  Test / fork := true,
  assemblyJarName in assembly := s"${(This / name).value}.jar",
  libraryDependencies ++= Seq(
    keycloakCore,
    keycloakModelJpa,
    keycloakServerSpi,
    mockito % Test,
    scalaTest % Test
  ),
  assemblyMergeStrategy in assembly := {
    case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
    case _ => MergeStrategy.first
  }
)

lazy val root = (project in file("."))
  .aggregate(eventPublisherSpi, govUkNotifySpi)

lazy val eventPublisherSpi = (project in file("./event-publisher-spi"))
  .settings(
    name := "event-publisher-spi",
    libraryDependencies += awsUtils,
  ).settings(commonSettings)

lazy val govUkNotifySpi = (project in file("./govuk-notify-spi"))
  .settings(
    name := "govuk-notify-spi",
    libraryDependencies += notifyJavaClient,
  ).settings(commonSettings)
