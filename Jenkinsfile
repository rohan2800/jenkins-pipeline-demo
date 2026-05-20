pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        APP_NAME    = "DevOps-Demo-App"
        APP_VERSION = "2.0.0"
        APP_ENV     = "staging"
        DEPLOY_DIR  = "/tmp/deployments"
        REPORT_DIR  = "reports"
    }

    options {
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Checkout') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "📥 STAGE: Checkout"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "App     : ${APP_NAME} v${APP_VERSION}"
                echo "Branch  : ${env.GIT_BRANCH}"
                echo "Commit  : ${env.GIT_COMMIT}"
                echo "Build   : #${BUILD_NUMBER}"
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🔨 STAGE: Build"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                sh '''
                    chmod +x src/app.sh
                    chmod +x scripts/*.sh
                    bash src/app.sh
                    mkdir -p ${REPORT_DIR}
                    echo "Build #${BUILD_NUMBER} - $(date)" > ${REPORT_DIR}/build.log
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
                    bash tests/unit_tests.sh | tee ${REPORT_DIR}/test.log
                '''
            }
        }

        stage('Code Quality') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🔍 STAGE: Code Quality"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                sh '''
                    bash scripts/quality_check.sh | tee ${REPORT_DIR}/quality.log
                '''
            }
        }

        stage('Package') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "📦 STAGE: Package"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                sh '''
                    PKG_NAME="${APP_NAME}-${APP_VERSION}-build${BUILD_NUMBER}.tar.gz"
                    tar -czf ${PKG_NAME} src/ config/ scripts/
                    echo "✅ Package created: ${PKG_NAME}"
                    ls -lh ${PKG_NAME}
                    echo ${PKG_NAME} > ${REPORT_DIR}/package.log
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "🚀 STAGE: Deploy"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                sh '''
                    bash scripts/deploy.sh | tee ${REPORT_DIR}/deploy.log
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
                    if [ -L ${DEPLOY_DIR}/current ]; then
                        echo "✅ Deployment symlink exists"
                        echo "✅ Pointing to: $(readlink ${DEPLOY_DIR}/current)"
                        bash ${DEPLOY_DIR}/current/src/app.sh
                    else
                        echo "❌ Deployment verification failed"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "✅ PIPELINE SUCCEEDED"
            echo "App     : ${APP_NAME} v${APP_VERSION}"
            echo "Build   : #${BUILD_NUMBER}"
            echo "Branch  : ${env.GIT_BRANCH}"
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
            sh '''
                echo "=== Pipeline Summary ==="
                echo "Build    : #${BUILD_NUMBER}"
                echo "Job      : ${JOB_NAME}"
                echo "Duration : ${currentBuild.durationString}"
            '''
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
