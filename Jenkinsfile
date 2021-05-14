pipeline {
    agent any

    tools {
        maven '3.8.1'
    }

    options {
        buildDiscarder logRotator(
            daysToKeepStr: '16',
            numToKeepStr: '10'
        )
    }

    environment {
        dockerImage = ''
        registry = 'rhounkpe/microservices-using-spring-boot-service-registry'
        registryCredential = 'dockerHub'
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
                sh '''
                    echo "Running Unit Tests"
                '''
            }
        }

        stage('Build') {
            steps {
                withMaven() {
                    sh "mvn clean package"
                } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
            }
        }

        stage('Deploy on Docker') {
            steps {
                withMaven(mavenSettingsConfig: 'd2ad62a2-cd78-4c74-a89e-1ee0c9aa5eb7') {
                    sh "mvn dockerfile:push"
                } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
            }
        }
        /*
        stage('Stop Docker Container') {
            steps {
                sh 'docker ps -f name=microservices-using-spring-boot-service-registry -q | xargs --no-run-if-empty docker container stop'
                sh 'docker container ls -a -fname=microservices-using-spring-boot-service-registry -q | xargs -r docker container rm'
            }
        }

        stage('Docker Run') {
            steps {
                script {
                    dockerImage.run("-p 8761:8761 --rm --name microservices-using-spring-boot-service-registry")
                }
            }
        }
        */
    }
    post {
        always {
            cleanWs()
        }
    }
}
