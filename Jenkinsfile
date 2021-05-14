pipeline {
    agent any

    environment {
        dockerImage = ''
        registry = 'rhounkpe/microservices-using-spring-boot-service-registry'
        registryCredential = 'dockerHub'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/rhounkpe/microservices-using-spring-boot-service-registry']]])
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
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
    }
    post {
        always {
            echo 'All done!'
        }
    }
}
