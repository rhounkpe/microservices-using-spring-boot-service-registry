pipeline {
    /*
    https://www.youtube.com/watch?v=HaGeSq-SB9E&ab_channel=SzymonStepniak
    environment {
        JAVA_TOOL_OPTIONS = '-Duser.home=/var/maven'
    }
    agent {
        docker {
            image 'maven:3.8.1-jdk-11'
            label 'docker'
            args '-v /tmp/maven:/var/maven/.m2 -e MAVEN_CONFIG=/var/maven/.m2'
        }
    }
    */

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

        stage('Build and Deploy on Docker') {
            environment {
            }
            steps {
                sh 'mvn clean package dockerfile:push'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install'
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml'
                }
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build registry
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
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
