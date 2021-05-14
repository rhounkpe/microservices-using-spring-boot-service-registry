pipeline {
    agent any

    environment {
    }

    stages {
        stage('Checkout from SCM') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/rhounkpe/microservices-using-spring-boot-service-registry']]])
            }
        }
        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker image and Deploy on Docker Hub') {
            steps {
                sh 'mvn dockerfile:push'
            }
        }
    }
    post {
        always {
            echo 'All jobs done!'
        }
    }
}
