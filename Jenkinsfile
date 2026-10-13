pipeline {
    agent any

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                script {
                    devflowTest()
                }
            }
        }
    }

    post {
        always {
            echo 'DevFlow pipeline finished.'
        }
        success {
            echo 'All pipeline stages passed.'
        }
        failure {
            echo 'Pipeline failed. Review the stage logs.'
        }
    }
}
