import Dependencies._

lazy val commonSettings = Seq(
  scalaVersion := "2.13.8",
  Test / fork := true,
  assembly / assemblyJarName := s"${(This / name).value}.jar",
  assemblyPackageScala / assembleArtifact := false,
  assemblyPackageDependency / assembleArtifact := false,
  assemblyPackageDependency / test := {},
  libraryDependencies ++= Seq(
    circeCore,
    circeParser,
    circeGeneric,
    notifyJavaClient,
    keycloakCore,
    keycloakModelJpa,
    keycloakServerSpi,
    snsSdk,
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
    name := "event-publisher-spi"
  ).settings(commonSettings)

lazy val govUkNotifySpi = (project in file("./govuk-notify-spi"))
  .settings(
    name := "govuk-notify-spi" ,
  ).settings(commonSettings)
