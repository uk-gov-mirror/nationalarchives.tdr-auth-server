pipeline {
  agent {
    label "master"
  }
  parameters {
    choice(name: "STAGE", choices: ["intg", "staging", "prod"], description: "The stage you are building the auth server for")
  }
  environment {
    mgmtAccount = sh(returnStdout: true, script: 'echo $MANAGEMENT_ACCOUNT').trim()
  }
  stages {
    stage('Build artifacts') {
        parallel {
            stage('Build Theme') {
                agent {
                    ecs {
                        inheritFrom 'npm'
                    }
                }
                steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/UKHomeOffice/keycloak-theme-govuk.git']]])
                    sh 'npm install'
                    sh 'npm run build'
                    stash includes: "govuk/**", name: "govuk"
                }
            }
            stage('Build SMS 2FA') {
                agent {
                    ecs {
                        inheritFrom 'maven'
                    }
                }
                steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/develop']], userRemoteConfigs: [[url: 'https://github.com/nationalarchives/keycloak-sms-authenticator-sns.git']]])
                    sh '/apache-maven-3.6.3/bin/mvn package'
                    stash includes: "target/keycloak-sms-authenticator-sns-*.jar", name: "sms-authenticator"
                    stash includes: "templates/sms-*", name: "sms-templates"
                    stash includes: "templates/messages/messages_en.properties", name: "messages"
                }
            }
        }
    }

    stage('Build keycloak') {
        agent {
            label 'master'
        }
        steps {
            sh "rm -rf target"
            unstash 'govuk'
            unstash 'sms-authenticator'
            unstash 'sms-templates'
            unstash 'messages'
            sh "docker build -t nationalarchives/tdr-auth-server:${params.STAGE} ."
            withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
                sh "echo $PASSWORD | docker login --username $USERNAME --password-stdin"
                sh "docker push nationalarchives/tdr-auth-server:${params.STAGE}"
                slackSend color: "good", message: "The keycloak auth app has been pushed to docker hub", channel: "#tdr"
            }
        }
    }
    stage("Update ECS container") {
        agent {
            ecs {
                inheritFrom "aws"
                taskrole "arn:aws:iam::${env.mgmtAccount}:role/TDRJenkinsNodeRole${params.STAGE.capitalize()}"
            }
        }
        steps {
            script {
                def accountNumber = getAccountNumberFromStage()
                sh "python3 /update_service.py ${accountNumber} ${STAGE} keycloak"
                slackSend color: "good", message: "The keycloak app has been updated in ECS", channel: "#tdr"
            }
        }
    }
  }
}

def getAccountNumberFromStage() {
    def stageToAccountMap = [
            "intg": env.INTG_ACCOUNT,
            "staging": env.STAGING_ACCOUNT,
            "prod": env.PROD_ACCOUNT
    ]

    return stageToAccountMap.get(params.STAGE)
}
