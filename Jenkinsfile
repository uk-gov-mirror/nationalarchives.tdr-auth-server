pipeline {
  agent none
  parameters {
    choice(name: "STAGE", choices: ["intg", "staging", "prod"], description: "The stage you are building the auth server for")
  }
  stages {
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
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/UKGovernmentBEIS/keycloak-sms-authenticator-sns.git']]])
                sh 'mvn package'
                stash includes: "target/keycloak-sms-authenticator-sns-*.jar", name: "sms-authenticator"
                stash includes: "templates/sms-*", name: "sms-templates"
                stash includes: "templates/messages/messages_en.properties", name: "messages"
            }
    }
    stage('Build keycloak') {
        agent {
            label 'master'
        }
        steps {
            unstash 'govuk'
            unstash 'sms-authenticator'
            unstash 'sms-templates'
            unstash 'messages'
            sh 'docker build -t nationalarchives/tdr-auth-server .'
            withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
                sh "echo $PASSWORD | docker login --username $USERNAME --password-stdin"
                sh "docker push nationalarchives/tdr-auth-server:${params.STAGE}"
                slackSend color: "good", message: "The keycloak auth app has been pushed to docker hub", channel: "#tdr"
            }
        }
    }
  }
}
