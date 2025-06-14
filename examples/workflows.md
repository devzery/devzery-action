# Example Workflows

This directory contains example workflows demonstrating how to use the API Trigger Action in various scenarios.

## Basic Examples

### Simple POST Request
```yaml
# .github/workflows/api-trigger.yml
name: Trigger API
on:
  push:
    branches: [ main ]

jobs:
  trigger:
    runs-on: ubuntu-latest
    steps:
      - uses: devzery/devzery-action@v0.1.0
        with:
          api-key: ${{ secrets.API_KEY }}
```

### Deployment Notification
```yaml
# .github/workflows/deploy-notify.yml
name: Deploy and Notify
on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy Application
        run: echo "Deploying application..."
      
      - name: Notify Deployment Service
        uses: devzery/devzery-action@v0.1.0
        with:
          api-key: ${{ secrets.DEPLOYMENT_API_KEY }}
```

### Multiple API Calls
```yaml
# .github/workflows/multi-api.yml
name: Multiple API Integration
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Start Deployment
        id: start
        uses: devzery/devzery-action@v0.1.0
        with:
          api-url: 'https://api.deploy.com/start'
          api-key: ${{ secrets.DEPLOY_API_KEY }}
          payload: |
            {
              "environment": "${{ github.event.inputs.environment }}",
              "repository": "${{ github.repository }}"
            }
      
      - name: Update Status
        if: steps.start.outputs.success == 'true'
        uses: devzery/devzery-action@v0.1.0
        with:
          api-url: 'https://api.status.com/update'
          api-key: ${{ secrets.STATUS_API_KEY }}
          payload: |
            {
              "deployment_id": "${{ fromJSON(steps.start.outputs.response).deployment_id }}",
              "status": "in_progress"
            }
```

### Error Handling
```yaml
# .github/workflows/robust-api.yml
name: Robust API Integration
on:
  push:
    branches: [ main ]

jobs:
  api-call:
    runs-on: ubuntu-latest
    steps:
      - name: Call API with Retry
        id: api
        uses: devzery/devzery-action@v0.1.0
        continue-on-error: true
        with:
          api-url: 'https://api.example.com/webhook'
          api-key: ${{ secrets.API_KEY }}
          timeout: 60000
      
      - name: Handle Success
        if: steps.api.outputs.success == 'true'
        run: |
          echo "API call successful!"
          echo "Response: ${{ steps.api.outputs.response }}"
      
      - name: Handle Failure and Retry
        if: steps.api.outputs.success != 'true'
        run: |
          echo "API call failed with status: ${{ steps.api.outputs.status-code }}"
          echo "Retrying in 30 seconds..."
          sleep 30
      
      - name: Retry API Call
        if: steps.api.outputs.success != 'true'
        uses: devzery/devzery-action@v0.1.0
        with:
          api-url: 'https://api.example.com/webhook'
          api-key: ${{ secrets.API_KEY }}
          timeout: 60000
```

### Custom Headers Example
```yaml
# .github/workflows/custom-headers.yml
name: API with Custom Headers
on:
  push:
    branches: [ main ]

jobs:
  api-call:
    runs-on: ubuntu-latest
    steps:
      - name: Call API with Custom Headers
        uses: devzery/devzery-action@v0.1.0
        with:
          api-url: 'https://api.example.com/data'
          api-key: ${{ secrets.API_KEY }}
          headers: |
            {
              "X-API-Version": "2.0",
              "X-Client": "github-actions",
              "X-Request-ID": "${{ github.run_id }}-${{ github.run_number }}"
            }
          payload: |
            {
              "data": "example",
              "metadata": {
                "source": "github-actions",
                "workflow": "${{ github.workflow }}"
              }
            }
```
