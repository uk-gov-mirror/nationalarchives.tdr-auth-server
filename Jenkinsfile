pipeline {
  agent none

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
            stash includes: "govuk/*", name: "govuk"
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
        unstash 'govuk'
        unstash 'sms-authenticator'
        unstash 'sms-templates'
        unstash 'messages'
        sh 'docker build -t nationalarchives/auth .'
    }
  }
}
