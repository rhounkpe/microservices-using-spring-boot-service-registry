pipeline {
    agent any

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

        stage('Publish on Docker Hub') {
            steps {
                withMaven() {
                    sh "mvn dockerfile:push"
                } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
