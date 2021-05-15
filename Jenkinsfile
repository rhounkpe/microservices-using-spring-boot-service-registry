pipeline {
    agent any

    tools {
        maven '3.8.1'
    }

    options {
        // On failure, retry the entire Pipeline the specified number of times.
        retry(2)
        // Persist artifacts and console output for the specific number of recent Pipeline runs
        buildDiscarder(
            logRotator(numToKeepStr: '1')
        )
        // Skip stages once the build status has gone to UNSTABLE
        skipStagesAfterUnstable()
        // 	Specify a global execution timeout of one hour, after which Jenkins will abort the Pipeline run.
        timeout(time: 1, unit: 'HOURS')
    }

    stages {
        stage ('Initialize') {
            options {
                timeout(time: 2, unit: 'MINUTES')
                retry(2)
            }
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

        stage('Test') {
            steps {
                sh 'mvn clean test'
            }
        }

        stage('Build') {
            options {
                timeout(time: 30, unit: 'MINUTES')
                retry(3)
            }
            steps {
                withMaven() {
                    sh 'mvn clean package -DskipTests=true'
                } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
            }
        }

        stage('Publish on Docker Hub') {
            options {
                timeout(time: 30, unit: 'MINUTES')
                retry(3)
            }
            steps {
                withMaven(mavenSettingsConfig: 'b4653e81-a4c6-4026-a901-c4f745b823cf') {
                    sh 'mvn dockerfile:push'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'develop'
                environment name: 'DEPLOY_TO', value: 'develop'
            }
            steps {
                sh 'Deploying to dev environment'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
