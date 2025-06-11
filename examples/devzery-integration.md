# Example Workflow for Devzery Backend Integration

This example shows how to integrate the Devzery Action with your backend API for automated testing and workflow execution.

```yaml
name: Devzery API Integration
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  trigger-devzery-api:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      
      - name: Trigger Devzery Backend API
        id: devzery-trigger
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
          workflow-config: |
            {
              "environment": "production",
              "test_suite": "regression",
              "parallel_execution": true,
              "max_retries": 3
            }
          test-config: |
            {
              "browser": "chrome",
              "viewport": "1920x1080",
              "timeout": 30000,
              "headless": true,
              "tags": ["smoke", "critical"]
            }
          payload: |
            {
              "trigger_source": "github_action",
              "repository_url": "${{ github.repository }}",
              "branch": "${{ github.ref_name }}",
              "commit_sha": "${{ github.sha }}",
              "pr_number": "${{ github.event.number }}"
            }
          timeout: 60000
      
      - name: Output Flow Information
        run: |
          echo "API call successful: ${{ steps.devzery-trigger.outputs.success }}"
          echo "Status code: ${{ steps.devzery-trigger.outputs.status-code }}"
          echo "Flow ID: ${{ steps.devzery-trigger.outputs.flow-id }}"
          echo "Response: ${{ steps.devzery-trigger.outputs.response }}"
      
      - name: Handle Success
        if: steps.devzery-trigger.outputs.success == 'true'
        run: |
          echo "✅ Devzery API triggered successfully!"
          echo "Flow ID: ${{ steps.devzery-trigger.outputs.flow-id }}"
          echo "You can track the progress using this Flow ID"
      
      - name: Handle Failure
        if: steps.devzery-trigger.outputs.success != 'true'
        run: |
          echo "❌ Failed to trigger Devzery API"
          echo "Status: ${{ steps.devzery-trigger.outputs.status-code }}"
          echo "Response: ${{ steps.devzery-trigger.outputs.response }}"
          exit 1
```

## Alternative: Trigger on Specific Events

```yaml
name: Devzery Deployment Testing
on:
  deployment_status:
    types: [success]

jobs:
  post-deployment-tests:
    runs-on: ubuntu-latest
    if: github.event.deployment_status.state == 'success'
    steps:
      - name: Trigger Post-Deployment Tests
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
          workflow-config: |
            {
              "environment": "${{ github.event.deployment.environment }}",
              "test_suite": "post_deployment",
              "priority": "high"
            }
          test-config: |
            {
              "base_url": "${{ github.event.deployment.payload.web_url }}",
              "verify_ssl": true,
              "follow_redirects": true
            }
```

## Conditional Execution

```yaml
name: Conditional Devzery Testing
on:
  push:
    paths:
      - 'src/**'
      - 'tests/**'
      - 'package.json'

jobs:
  conditional-testing:
    runs-on: ubuntu-latest
    steps:
      - name: Check if API tests should run
        id: should-run
        run: |
          if [[ "${{ github.event.head_commit.message }}" == *"[skip-tests]"* ]]; then
            echo "skip=true" >> $GITHUB_OUTPUT
          else
            echo "skip=false" >> $GITHUB_OUTPUT
          fi
      
      - name: Trigger Devzery API Tests
        if: steps.should-run.outputs.skip != 'true'
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
          workflow-config: |
            {
              "triggered_by": "conditional_push",
              "commit_message": "${{ github.event.head_commit.message }}"
            }
```
