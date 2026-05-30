pipeline {
    agent any

    environment {
        APP_NAME    = "DevOps-Demo-App"
        APP_VERSION = "2.0.0"
        ENVIRONMENT = "staging"
    }

    options {
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
    }

    stages {

        stage('Checkout') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "📥 STAGE: Checkout"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                echo "App     : ${APP_NAME} v${APP_VERSION}"
                echo "Branch  : ${env.BRANCH_NAME ?: env.GIT_BRANCH}"
                echo "Commit  : ${env.GIT_COMMIT}"
                echo "Build   : #${BUILD_NUMBER}"

                sh '''
                    ls -la
                '''
            }
        }

        stage('Build') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🔨 STAGE: Build"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    chmod +x src/app.sh
                    chmod +x scripts/deploy.sh scripts/quality_check.sh

                    bash src/app.sh

                    mkdir -p reports

                    echo "Build #${BUILD_NUMBER} - $(date)" > reports/build.log

                    echo "✅ Build stage complete"
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🧪 STAGE: Unit Tests"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    chmod +x tests/unit_tests.sh

                    bash tests/unit_tests.sh | tee reports/test.log
                '''
            }
        }

        stage('Code Quality') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🔍 STAGE: Code Quality"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    bash scripts/quality_check.sh | tee reports/quality.log
                '''
            }
        }

        stage('Package') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "📦 STAGE: Package"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    PKG_NAME=${APP_NAME}-${APP_VERSION}-build${BUILD_NUMBER}.tar.gz

                    tar -czf ${PKG_NAME} src/ config/ scripts/

                    echo "✅ Package created: ${PKG_NAME}"

                    ls -lh ${PKG_NAME}

                    echo "${PKG_NAME}" > reports/package.log
                '''
            }
        }

        stage('Approval') {
	    steps {
                input message: 'Deploy to staging?', ok: 'Yes, Deploy!'
            }
        }

        stage('Deploy') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🚀 STAGE: Deploy"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    bash scripts/deploy.sh | tee reports/deploy.log
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "💨 STAGE: Smoke Test"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

                sh '''
                    echo "Verifying deployment..."

                    if [ -L /tmp/deployments/current ]; then
                        echo "✅ Deployment symlink exists"

                        TARGET=$(readlink /tmp/deployments/current)

                        echo "✅ Pointing to: ${TARGET}"

                        bash /tmp/deployments/current/src/app.sh
                    else
                        echo "❌ Deployment symlink missing"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {

        success {
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "✅ PIPELINE COMPLETED"
            echo "Build   : #${BUILD_NUMBER}"
            echo "Branch  : ${env.BRANCH_NAME ?: env.GIT_BRANCH}"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

            sh '''
                echo "=== Final Reports ==="

                echo "--- Build Log ---"
                cat reports/build.log

                echo "--- Deploy Log ---"
                cat reports/deploy.log
            '''
        }

        failure {
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "❌ PIPELINE FAILED"
            echo "Build   : #${BUILD_NUMBER}"
            echo "Check console output above"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        }

        always {
<<<<<<< HEAD
            script {
                echo "=== Pipeline Summary ==="
                echo "Build    : #${env.BUILD_NUMBER}"
                echo "Job      : ${env.JOB_NAME}"
                echo "Branch   : ${env.BRANCH_NAME ?: env.GIT_BRANCH}"
                echo "Duration : ${currentBuild.durationString}"
            }
=======
	    echo "=== Pipeline Summary ==="
	    echo "Build    : #${BUILD_NUMBER}"
	    echo "Job      : ${JOB_NAME}"
	    echo "Duration : ${currentBuild.durationString}"
>>>>>>> 5189741 (hotfix: bump version to 2.0.1)
        }

        cleanup {
            sh '''
                echo "🧹 Cleaning workspace..."

                rm -f *.tar.gz

                echo "✅ Cleanup done"
            '''
        }
    }
}
