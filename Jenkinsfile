pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout'
            }
        }
        stage('Example') {
            steps {
                echo 'Hello World'
            }
        }
    }
    post {
        always {
            echo 'I will always say Hello again!'
        }
    }
}
