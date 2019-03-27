#!/usr/bin/env groovy

pipeline {

    agent {
        kubernetes {
            label "storm-puppet-module-tests-${env.BUILD_NUMBER}"
            cloud 'Kube mwdevel'
            defaultContainer 'jnlp'
            yamlFile 'jenkins/pod.yaml'
        }
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
    }

    triggers { cron('@daily') }

    environment {
        SONAR_TOKEN = credentials('sonarcloud-storm-puppet-module')
        SONAR_HOST_URL = 'https://sonarcloud.io'
        SONAR_PROJECT_KEY = 'enricovianello_storm-pm'
        SONAR_ORGANIZATION = 'enricovianello-github'
        SONAR_OPTS = "-Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN -Dsonar.projectKey=$SONAR_PROJECT_KEY -Dsonar.organization=$SONAR_ORGANIZATION"
    }

    stages {
        stage('Run') {
            steps {
                container('docker-rspec-puppet') {
                    script {
                        checkout scm
                        dir('storm') {
                            sh 'bundle exec rake test | tee rake.log'
                            sh 'rspec spec/classes/*.rb --format html --out rspec_report.html'
                            sh 'rspec spec/classes/*.rb --format RspecJunitFormatter --out rspec_report.xml'
                            sh "sonar-runner $SONAR_OPTS"
                            archiveArtifacts 'rspec_report.html,rspec_report.xml,rake.log'
                            junit 'rspec_report.xml'
                        }
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
            script{
                if('SUCCESS'.equals(currentBuild.result)) {
                    slackSend color: 'good', message: "${env.JOB_NAME} - #${env.BUILD_NUMBER} Back to normal (<${env.BUILD_URL}|Open>)"
                }
            }
        }
    }
}
