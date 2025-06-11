# API Trigger Action

[![GitHub marketplace](https://img.shields.io/badge/marketplace-api--trigger--action-blue?logo=github)](https://github.com/marketplace/actions/api-trigger-action)
[![CI](https://github.com/your-username/devzery-action/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/devzery-action/actions/workflows/ci.yml)

A powerful and flexible GitHub Action that allows you to trigger backend APIs from your GitHub workflows. Perfect for integrating CI/CD pipelines with external services, triggering deployments, sending notifications, or calling any REST API endpoint.

## 🚀 Features

- **Flexible HTTP Methods**: Support for GET, POST, PUT, DELETE requests
- **Secure Authentication**: Built-in support for Bearer token authentication
- **Rich Context**: Automatically includes GitHub workflow context in requests
- **Customizable Headers**: Add custom headers to your requests
- **Error Handling**: Comprehensive error handling with detailed logging
- **Timeout Control**: Configurable request timeouts
- **Response Outputs**: Access response data in subsequent workflow steps

## 📋 Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `api-url` | The API endpoint URL to trigger (optional - uses hardcoded URL if not provided) | ❌ | `https://your-backend-domain.com/github/run` |
| `api-key` | API key for authentication | ✅ | - |
| `method` | HTTP method (GET, POST, PUT, DELETE) | ❌ | `POST` |
| `payload` | JSON payload to send with the request | ❌ | `{}` |
| `headers` | Additional headers as JSON string | ❌ | `{}` |
| `timeout` | Request timeout in milliseconds | ❌ | `30000` |
| `workflow-config` | Workflow configuration as JSON string | ❌ | `{}` |
| `test-config` | Test configuration as JSON string | ❌ | `{}` |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `response` | The API response body |
| `status-code` | The HTTP status code of the response |
| `success` | Whether the API call was successful (true/false) |
| `flow-id` | The unique flow ID returned by the backend for tracking |

## 🛠️ Usage

### Basic Example

```yaml
name: Trigger API on Push
on:
  push:
    branches: [ main ]

jobs:
  trigger-api:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Backend API
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.API_KEY }}
          method: 'POST'
          payload: |
            {
              "event": "deployment",
              "branch": "${{ github.ref_name }}",
              "commit": "${{ github.sha }}"
            }
```

### Advanced Example with Custom Headers

```yaml
name: Advanced API Integration
on:
  release:
    types: [published]

jobs:
  notify-services:
    runs-on: ubuntu-latest
    steps:
      - name: Notify Release Service
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.API_KEY }}
          method: 'POST'
          headers: |
            {
              "X-Service-Version": "2.0",
              "X-Request-ID": "${{ github.run_id }}"
            }
          payload: |
            {
              "release_tag": "${{ github.event.release.tag_name }}",
              "release_name": "${{ github.event.release.name }}",
              "release_body": "${{ github.event.release.body }}",
              "draft": ${{ github.event.release.draft }},
              "prerelease": ${{ github.event.release.prerelease }}
            }
          timeout: 60000

      - name: Handle API Response
        if: always()
        run: |
          echo "API call status: ${{ steps.notify-services.outputs.success }}"
          echo "Status code: ${{ steps.notify-services.outputs.status-code }}"
          echo "Response: ${{ steps.notify-services.outputs.response }}"
```

### GET Request Example

```yaml
name: Health Check
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Check API Health
        uses: your-username/devzery-action@v1
        with:
          api-key: ${{ secrets.API_KEY }}
          method: 'GET'
          timeout: 10000
```

## 🔒 Security

- **Never commit API keys** to your repository. Always use [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).
- The action uses Bearer token authentication by default: `Authorization: Bearer YOUR_API_KEY`
- API keys and sensitive data are never logged or exposed in the workflow output.

## 🔄 GitHub Context

When using POST or PUT methods, the action automatically includes GitHub workflow context in the payload:

```json
{
  "your_custom_payload": "here",
  "github_context": {
    "repository": {
      "owner": "your-username",
      "repo": "your-repo"
    },
    "ref": "refs/heads/main",
    "sha": "abc123...",
    "actor": "username",
    "workflow": "CI/CD Pipeline",
    "job": "deploy",
    "run_id": 123456789,
    "run_number": 42,
    "event_name": "push"
  }
}
```

## 🛠️ Development

### Building the Action

```bash
npm install
npm run build
```

### Testing Locally

1. Set up your environment variables:
```bash
export INPUT_API_URL="https://httpbin.org/post"
export INPUT_API_KEY="test-key"
export INPUT_METHOD="POST"
export INPUT_PAYLOAD='{"test": "data"}'
```

2. Run the action:
```bash
node dist/index.js
```

## 📋 Requirements

- Node.js 20+
- The target API endpoint should support the authentication method you're using

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ❓ Support

- 📚 [Documentation](https://github.com/your-username/devzery-action/wiki)
- 🐛 [Issue Tracker](https://github.com/your-username/devzery-action/issues)
- 💬 [Discussions](https://github.com/your-username/devzery-action/discussions)

## 🏷️ Marketplace

This action is available on the [GitHub Marketplace](https://github.com/marketplace/actions/api-trigger-action). You can also find it by searching for "API Trigger" in the Actions tab of your repository.

---

Made with ❤️ by [Devzery](https://github.com/your-username)
