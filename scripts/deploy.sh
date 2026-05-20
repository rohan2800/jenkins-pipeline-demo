#!/bin/bash
# Deployment Script

DEPLOY_DIR="/tmp/deployments"
APP_VERSION=$(grep APP_VERSION config/app.conf | cut -d= -f2)
BUILD_DIR="${DEPLOY_DIR}/build-${BUILD_NUMBER:-local}"

echo "================================"
echo "  Deployment Started"
echo "================================"
echo "  Version    : ${APP_VERSION}"
echo "  Build      : #${BUILD_NUMBER:-local}"
echo "  Target Dir : ${BUILD_DIR}"
echo "  Time       : $(date)"
echo "================================"

# Create deployment directory
mkdir -p "${BUILD_DIR}"

# Copy application files
cp -r src/   "${BUILD_DIR}/"
cp -r config/ "${BUILD_DIR}/"

# Write deployment manifest
cat > "${BUILD_DIR}/manifest.txt" << MANIFEST
Deployment Manifest
===================
App Version : ${APP_VERSION}
Build Number: ${BUILD_NUMBER:-local}
Deploy Time : $(date)
Git Commit  : ${GIT_COMMIT:-local}
Git Branch  : ${GIT_BRANCH:-local}
Deployed By : Jenkins
MANIFEST

echo "✅ Files deployed to: ${BUILD_DIR}"
echo "📋 Manifest:"
cat "${BUILD_DIR}/manifest.txt"

# Symlink "current" to latest build
ln -sfn "${BUILD_DIR}" "${DEPLOY_DIR}/current"
echo "🔗 Current → ${BUILD_DIR}"
echo "✅ Deployment complete"
