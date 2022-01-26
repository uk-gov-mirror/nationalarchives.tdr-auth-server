package uk.gov.nationalarchives.eventpublisherspi

import org.keycloak.models._
import org.mockito.MockitoSugar
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import uk.gov.nationalarchives.aws.utils.SNSUtils
import uk.gov.nationalarchives.eventpublisherspi.EventPublisherProvider.EventPublisherConfig

class UserMonitoringTaskSpec extends AnyFlatSpec with Matchers with MockitoSugar {

  val validConfiguredCredentialTypes = List("otp", "webauthn")
  val otpCredentialType: String = validConfiguredCredentialTypes.head
  val webauthnCredentialType: String = validConfiguredCredentialTypes.last
  val userId = "dfd7356c-e6e0-40dd-affd-de04e29ad359"
  val userId2 = "4b3c3e89-775a-4c69-974e-bdc194a04d2d"
  val topicArn = "snsTopicArn"

  "The run method" should "not send a message if there are no users missing MFA" in {
    val mockSession = mock[KeycloakSession]
    val mockRealmProvider = mock[RealmProvider]
    val mockRealmModel = mock[RealmModel]
    val mockUserCredentialManager = mock[UserCredentialManager]
    val mockUserModel = mock[UserModel]
    val mockUserProvider = mock[UserProvider]
    val mockSnsUtils = mock[SNSUtils]

    when(mockRealmModel.getName).thenReturn("testRealm")
    when(mockUserProvider.getUsersStream(mockRealmModel)).thenReturn(java.util.stream.Stream.of(mockUserModel))
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModel, otpCredentialType)).thenReturn(true)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModel, webauthnCredentialType)).thenReturn(true)
    when(mockRealmProvider.getRealmsStream).thenReturn(java.util.stream.Stream.of(mockRealmModel))
    when(mockSession.users()).thenReturn(mockUserProvider)
    when(mockSession.realms()).thenReturn(mockRealmProvider)
    when(mockSession.userCredentialManager()).thenReturn(mockUserCredentialManager)
    new UserMonitoringTask(mockSnsUtils, EventPublisherConfig("https://example.com", "", "test"), validConfiguredCredentialTypes).run(mockSession)

    verifyZeroInteractions(mockSnsUtils)
  }

  "The run method" should "send a message if there is one user with MFA and one without" in {
    val mockSession = mock[KeycloakSession]
    val mockRealmProvider = mock[RealmProvider]
    val mockRealmModel = mock[RealmModel]
    val mockUserCredentialManager = mock[UserCredentialManager]
    val mockUserModelWithMFA = mock[UserModel]
    val mockUserModelWithoutMFA = mock[UserModel]
    val mockUserProvider = mock[UserProvider]
    val mockSnsUtils = mock[SNSUtils]

    when(mockRealmModel.getName).thenReturn("testRealm")
    when(mockUserModelWithoutMFA.getId).thenReturn(userId)
    when(mockUserProvider.getUsersStream(mockRealmModel)).thenReturn(java.util.stream.Stream.of(mockUserModelWithMFA, mockUserModelWithoutMFA))
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithMFA, otpCredentialType)).thenReturn(true)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithMFA, webauthnCredentialType)).thenReturn(true)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA, webauthnCredentialType)).thenReturn(false)
    when(mockRealmProvider.getRealmsStream).thenReturn(java.util.stream.Stream.of(mockRealmModel))
    when(mockSession.users()).thenReturn(mockUserProvider)
    when(mockSession.realms()).thenReturn(mockRealmProvider)
    when(mockSession.userCredentialManager()).thenReturn(mockUserCredentialManager)
    new UserMonitoringTask(mockSnsUtils, EventPublisherConfig("https://example.com", topicArn, "test"), validConfiguredCredentialTypes).run(mockSession)

    val expectedMessage = """{
                             |  "tdrEnv" : "test",
                             |  "message" : "\ntestRealm realm has 1 user without MFA\ndfd7356c-e6e0-40dd-affd-de04e29ad359\n"
                             |}""".stripMargin

    verify(mockSnsUtils, times(1)).publish(expectedMessage, topicArn)
  }

  "The run method" should "send a message if there are two users with MFA missing" in {
    val mockSession = mock[KeycloakSession]
    val mockRealmProvider = mock[RealmProvider]
    val mockRealmModel = mock[RealmModel]
    val mockUserCredentialManager = mock[UserCredentialManager]
    val mockUserModelWithoutMFA1 = mock[UserModel]
    val mockUserModelWithoutMFA2 = mock[UserModel]
    val mockUserProvider = mock[UserProvider]
    val mockSnsUtils = mock[SNSUtils]

    when(mockRealmModel.getName).thenReturn("testRealm")
    when(mockUserModelWithoutMFA1.getId).thenReturn(userId)
    when(mockUserModelWithoutMFA2.getId).thenReturn(userId2)
    when(mockUserProvider.getUsersStream(mockRealmModel)).thenReturn(java.util.stream.Stream.of(mockUserModelWithoutMFA1, mockUserModelWithoutMFA2))
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA1, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA1, webauthnCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA2, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModelWithoutMFA2, webauthnCredentialType)).thenReturn(false)
    when(mockRealmProvider.getRealmsStream).thenReturn(java.util.stream.Stream.of(mockRealmModel))
    when(mockSession.users()).thenReturn(mockUserProvider)
    when(mockSession.realms()).thenReturn(mockRealmProvider)
    when(mockSession.userCredentialManager()).thenReturn(mockUserCredentialManager)
    new UserMonitoringTask(mockSnsUtils, EventPublisherConfig("https://example.com", topicArn, "test"), validConfiguredCredentialTypes).run(mockSession)

    val expectedMessage = """{
                            |  "tdrEnv" : "test",
                            |  "message" : "\ntestRealm realm has 2 users without MFA\ndfd7356c-e6e0-40dd-affd-de04e29ad359\n4b3c3e89-775a-4c69-974e-bdc194a04d2d\n"
                            |}""".stripMargin

    verify(mockSnsUtils, times(1)).publish(expectedMessage, topicArn)
  }

  "The run method" should "send a message if there are two users in two different realms with MFA missing" in {
    val mockSession = mock[KeycloakSession]
    val mockRealmProvider = mock[RealmProvider]
    val mockRealmModel1 = mock[RealmModel]
    val mockRealmModel2 = mock[RealmModel]
    val mockUserCredentialManager = mock[UserCredentialManager]
    val mockUserModelWithoutMFA1 = mock[UserModel]
    val mockUserModelWithoutMFA2 = mock[UserModel]
    val mockUserProvider = mock[UserProvider]
    val mockSnsUtils = mock[SNSUtils]

    when(mockRealmModel1.getName).thenReturn("testRealm1")
    when(mockRealmModel2.getName).thenReturn("testRealm2")
    when(mockUserModelWithoutMFA1.getId).thenReturn(userId)
    when(mockUserModelWithoutMFA2.getId).thenReturn(userId2)
    when(mockUserProvider.getUsersStream(mockRealmModel1)).thenReturn(java.util.stream.Stream.of(mockUserModelWithoutMFA1))
    when(mockUserProvider.getUsersStream(mockRealmModel2)).thenReturn(java.util.stream.Stream.of(mockUserModelWithoutMFA2))
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel1, mockUserModelWithoutMFA1, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel1, mockUserModelWithoutMFA1, webauthnCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel2, mockUserModelWithoutMFA2, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel2, mockUserModelWithoutMFA2, webauthnCredentialType)).thenReturn(false)
    when(mockRealmProvider.getRealmsStream).thenReturn(java.util.stream.Stream.of(mockRealmModel1, mockRealmModel2))
    when(mockSession.users()).thenReturn(mockUserProvider)
    when(mockSession.realms()).thenReturn(mockRealmProvider)
    when(mockSession.userCredentialManager()).thenReturn(mockUserCredentialManager)
    new UserMonitoringTask(mockSnsUtils, EventPublisherConfig("https://example.com", topicArn, "test"), validConfiguredCredentialTypes).run(mockSession)

    val expectedMessage1 = """{
                            |  "tdrEnv" : "test",
                            |  "message" : "\ntestRealm1 realm has 1 user without MFA\ndfd7356c-e6e0-40dd-affd-de04e29ad359\n"
                            |}""".stripMargin

    val expectedMessage2 = """{
                            |  "tdrEnv" : "test",
                            |  "message" : "\ntestRealm2 realm has 1 user without MFA\n4b3c3e89-775a-4c69-974e-bdc194a04d2d\n"
                            |}""".stripMargin

    verify(mockSnsUtils, times(1)).publish(expectedMessage1, topicArn)
    verify(mockSnsUtils, times(1)).publish(expectedMessage2, topicArn)
  }

  "The run method" should "not send a message if there is a user without otp but with webauthn" in {
    val mockSession = mock[KeycloakSession]
    val mockRealmProvider = mock[RealmProvider]
    val mockRealmModel = mock[RealmModel]
    val mockUserCredentialManager = mock[UserCredentialManager]
    val mockUserModel = mock[UserModel]
    val mockUserProvider = mock[UserProvider]
    val mockSnsUtils = mock[SNSUtils]

    when(mockRealmModel.getName).thenReturn("testRealm")
    when(mockUserProvider.getUsersStream(mockRealmModel)).thenReturn(java.util.stream.Stream.of(mockUserModel))
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModel, otpCredentialType)).thenReturn(false)
    when(mockUserCredentialManager.isConfiguredFor(mockRealmModel, mockUserModel, webauthnCredentialType)).thenReturn(true)
    when(mockRealmProvider.getRealmsStream).thenReturn(java.util.stream.Stream.of(mockRealmModel))
    when(mockSession.users()).thenReturn(mockUserProvider)
    when(mockSession.realms()).thenReturn(mockRealmProvider)
    when(mockSession.userCredentialManager()).thenReturn(mockUserCredentialManager)
    new UserMonitoringTask(mockSnsUtils, EventPublisherConfig("https://example.com", "", "test"), validConfiguredCredentialTypes).run(mockSession)

    verifyZeroInteractions(mockSnsUtils)
  }
}
