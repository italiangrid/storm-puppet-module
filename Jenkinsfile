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

  triggers { cron('@daily') }

  stages {
    stage('validate') {
      steps {
        script {
          checkout scm
          try {
            sh "pdk validate"
          } catch (err) {
          }
        }
      }
    }
    stage('tests') {
      steps {
        script {
          sh "pdk test unit"
        }
      }
    }
    stage('build') {
      steps {
        script {
          sh "pdk build"
          archiveArtifacts 'pkg/cnafsd-storm-*.tar.gz'
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
