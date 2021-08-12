import Dependencies._

scalaVersion := "2.13.4"

lazy val root = (project in file("."))
  .settings(
    name := "event-publisher-spi",
    scalaVersion := "2.13.4",
    libraryDependencies ++= Seq(
      awsUtils,
      keycloakCore,
      keycloakModelJpa,
      keycloakServerSpi,
      mockito % Test,
      scalaTest % Test
    ),
    assemblyJarName in assembly := "event-publisher-spi.jar",
    fork in Test := true
  )

resolvers ++= Seq[Resolver](
  "TDR Releases" at "s3://tdr-releases-mgmt"
)

assemblyMergeStrategy in assembly := {
  case "application.conf" => MergeStrategy.discard
  case PathList("META-INF", "MANIFEST.MF") => MergeStrategy.discard
  case _ => MergeStrategy.first
}
