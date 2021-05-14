pipeline {
    agent any

    environment {
        dockerImage = ''
        registry = 'rhounkpe/microservices-using-spring-boot-service-registry'
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
    }
    post {
        always {
            echo 'All done!'
        }
    }
}
