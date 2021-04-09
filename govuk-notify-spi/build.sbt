import Dependencies._

scalaVersion := "2.13.4"

lazy val commonSettings = Seq(
  resolvers ++= Seq[Resolver](
    "notify-java-client" at "https://dl.bintray.com/gov-uk-notify/maven/"
  )
)

lazy val root = (project in file("."))
  .settings(
    name := "govuk-notify-spi",
    commonSettings,
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
