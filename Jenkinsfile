pipeline {
    agent any

    environment {
        APP_ENV  = "staging"
        REPO_URL = "https://github.com/rohan2800/jenkins-pipeline-demo.git"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out from: ${REPO_URL}"
                echo "Branch: ${env.GIT_BRANCH}"
                echo "Commit: ${env.GIT_COMMIT}"
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "=== Build Stage ==="
                    chmod +x app/app.sh
                    bash app/app.sh
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo "=== Test Stage ==="
                    chmod +x tests/test.sh
                    bash tests/test.sh
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    echo "=== Deploy Stage ==="
                    echo "Deploying to: ${APP_ENV}"
                    echo "Build #${BUILD_NUMBER} deployed at $(date)" > deployment.log
                    cat deployment.log
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build #${BUILD_NUMBER} succeeded"
        }
        failure {
            echo "❌ Build #${BUILD_NUMBER} failed — check logs"
        }
        always {
            echo "📋 Pipeline finished with status: ${currentBuild.result}"
        }
    }
}

