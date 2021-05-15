pipeline {
    agent any

    tools {
        maven '3.8.1'
    }

    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
                sh 'mvn -version'
            }
        }

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/rhounkpe/microservices-using-spring-boot-service-registry']]])
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'maven clean test'
            }
        }

        stage('Build') {
            steps {
                withMaven() {
                    sh 'mvn clean package -DskipTests=true'
                } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
            }
        }

        stage('Deploy on Docker') {
            steps {
                withMaven(mavenSettingsConfig: 'b4653e81-a4c6-4026-a901-c4f745b823cf') {
                    sh 'mvn dockerfile:push'
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
