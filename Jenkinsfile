#!/usr/bin/env groovy

@Library('sd')_
def kubeLabel = getKubeLabel()

pipeline {

  agent {
    kubernetes {
      label "${kubeLabel}"
      cloud 'Kube mwdevel'
      defaultContainer 'runner'
      inheritFrom 'ci-template'
      containerTemplate {
        name 'runner'
        image "italiangrid/docker-rspec-puppet:ci"
        ttyEnabled true
        alwaysPullImage true
        command 'cat'
      }
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 1, unit: 'HOURS')
  }

  parameters {
    string(name: 'SONAR_PROJECT_VERSION', defaultValue: '0.1.0', description: 'Module version')
  }

  triggers { cron('@daily') }

  environment {
    SONAR_PROJECT_KEY = 'storm-puppet-module-key'
    SONAR_PROJECT_NAME = 'storm-puppet-module'
  }

  stages {
    stage('rspec-tests') {
      steps {
        script {
          checkout scm
          sh """
            rake test
          """
          archiveArtifacts 'rspec_report.html'
        }
      }
    }
    stage('sonar-analysis') {
      steps {
        script {
          sh 'rm -rf spec/fixtures'
          withSonarQubeEnv{
            def sonar_opts="-Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=${SONAR_AUTH_TOKEN}"
            def project_opts="-Dsonar.projectKey=${env.SONAR_PROJECT_KEY} -Dsonar.projectName='${env.SONAR_PROJECT_NAME}' -Dsonar.projectVersion=${params.SONAR_PROJECT_VERSION} -Dsonar.exclusions=spec/fixtures -Dsonar.sources=."
            sh "sonar-runner ${sonar_opts} ${project_opts}"
          }
        }
      }
    }
    stage('result') {
      steps {
        script {
          currentBuild.result = 'SUCCESS'
        }
      }
    }
  }

  post {
    failure {
      slackSend color: 'danger', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Failure (<${env.BUILD_URL}|Open>)"
    }
    unstable {
      slackSend color: 'warning', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Unstable (<${env.BUILD_URL}|Open>)"
    }
    changed {
      script {
        if ('SUCCESS'.equals(currentBuild.result)) {
          slackSend color: 'good', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)"
        }
      }
    }
  }
}
