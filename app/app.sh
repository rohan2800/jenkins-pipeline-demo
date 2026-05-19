#!/bin/bash
echo "=== My jenkins App ==="
echo "Version: 1.0.0"
echo "Environment: $APP_ENV"
echo 'echo "Build triggered by: $GIT_COMMIT"' >> app/app.sh
