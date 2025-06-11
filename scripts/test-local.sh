#!/bin/bash

# Local testing script for Devzery GitHub Action
# This script sets up environment variables and runs the action locally

set -e

echo "🚀 Testing Devzery GitHub Action Locally"
echo "========================================"

# Set default values
API_URL="${API_URL:-https://your-backend-domain.com/github/run}"
API_KEY="${API_KEY:-test-api-key}"
METHOD="${METHOD:-POST}"
TIMEOUT="${TIMEOUT:-30000}"

# Set payload with sample data
PAYLOAD='{
  "test": "local-execution",
  "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
  "environment": "local"
}'

WORKFLOW_CONFIG='{
  "environment": "test",
  "test_suite": "smoke",
  "parallel_execution": false
}'

TEST_CONFIG='{
  "browser": "chrome",
  "headless": true,
  "timeout": 30000
}'

# Export environment variables (GitHub Actions format)
export INPUT_API_URL="$API_URL"
export INPUT_API_KEY="$API_KEY" 
export INPUT_METHOD="$METHOD"
export INPUT_PAYLOAD="$PAYLOAD"
export INPUT_HEADERS='{}'
export INPUT_TIMEOUT="$TIMEOUT"
export INPUT_WORKFLOW_CONFIG="$WORKFLOW_CONFIG"
export INPUT_TEST_CONFIG="$TEST_CONFIG"

# Mock GitHub context
export GITHUB_REPOSITORY="test-user/test-repo"
export GITHUB_REF="refs/heads/main"
export GITHUB_SHA="abc123456789"
export GITHUB_ACTOR="test-user"
export GITHUB_WORKFLOW="Local Test"
export GITHUB_JOB="test"
export GITHUB_RUN_ID="123456"
export GITHUB_RUN_NUMBER="1"
export GITHUB_EVENT_NAME="push"

echo "Environment Variables Set:"
echo "  API_URL: $API_URL"
echo "  API_KEY: ${API_KEY:0:8}..."
echo "  METHOD: $METHOD"
echo "  TIMEOUT: $TIMEOUT"
echo ""

# Check if dist/index.js exists
if [ ! -f "dist/index.js" ]; then
    echo "❌ dist/index.js not found. Building the action first..."
    npm run build
    echo "✅ Build completed"
fi

echo "🔄 Running the action..."
echo "========================"

# Run the action
node dist/index.js

echo ""
echo "✅ Local test completed!"
echo ""
echo "💡 To test with your own values:"
echo "   API_URL=https://your-api.com/github/run API_KEY=your-key ./scripts/test-local.sh"
