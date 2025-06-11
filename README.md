# Devzery API Testing Action

[![GitHub marketplace](https://img.shields.io/badge/marketplace-devzery--api--testing-blue?logo=github)](https://github.com/marketplace/actions/devzery-api-testing)
[![CI](https://github.com/devzery/devzery-action/actions/workflows/ci.yml/badge.svg)](https://github.com/devzery/devzery-action/actions/workflows/ci.yml)

A GitHub Action that automatically triggers API tests on the Devzery testing platform. Seamlessly integrate API testing into your CI/CD pipeline by running comprehensive API test suites whenever code changes are pushed to your repository.

To view the test results visit the [Devzery Dashboard](https://web.devzery.com)

## 🚀 Features

- **Automated API Testing**: Trigger comprehensive API test suites on the Devzery platform
- **CI/CD Integration**: Seamlessly integrate API testing into your GitHub workflows
- **Secure Authentication**: Built-in support for Devzery API key authentication
- **Test Configuration**: Support for custom test and workflow configurations
- **Real-time Results**: Get detailed test results and flow tracking
- **Error Handling**: Comprehensive error handling with detailed logging
- **Flexible Triggers**: Run tests on push, pull requests, releases, or scheduled intervals

## 📋 Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `api-key` | Your Devzery API key for authentication | ✅ | - |
| `payload` | Additional JSON payload to send with the test trigger | ❌ | `{}` |
| `headers` | Additional headers as JSON string | ❌ | `{}` |
| `timeout` | Request timeout in milliseconds | ❌ | `30000` |
| `workflow-config` | Devzery workflow configuration as JSON string | ❌ | `{}` |
| `test-config` | Devzery test configuration as JSON string | ❌ | `{}` |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `status-code` | The HTTP status code of the response |
| `success` | Whether the API test execution was successful (true/false) |
| `flow-id` | The unique flow ID returned by Devzery for tracking test execution |

## 🛠️ Usage

### Basic Example

```yaml
name: Run API Tests on Push
on:
  push:
    branches: [ main, develop ]

jobs:
  api-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Devzery API Tests
        uses: devzery/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
```

### Advanced Example with Test Configuration

```yaml
name: Comprehensive API Testing
on:
  pull_request:
    branches: [ main ]
  release:
    types: [published]

jobs:
  devzery-api-tests:
    runs-on: ubuntu-latest
    steps:
      - name: Run Devzery API Test Suite
        id: api-tests
        uses: devzery/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
          timeout: 120000

      - name: Process Test Results
        if: always()
        run: |
          echo "Test execution status: ${{ steps.api-tests.outputs.success }}"
          echo "Flow ID for tracking: ${{ steps.api-tests.outputs.flow-id }}"
          echo "Response: ${{ steps.api-tests.outputs.response }}"
          
          if [ "${{ steps.api-tests.outputs.success }}" = "false" ]; then
            echo "API tests failed! Check Devzery dashboard for details."
            exit 1
          fi
```

### Scheduled API Testing

```yaml
name: Scheduled API Health Check
on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - name: Run Devzery Health Check Tests
        uses: devzery/devzery-action@v1
        with:
          api-key: ${{ secrets.DEVZERY_API_KEY }}
          timeout: 60000
```

## 🔒 Security

- **Never commit API keys** to your repository. Always use [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets).
- Store your Devzery API key as `DEVZERY_API_KEY` in your repository secrets.
- The action uses Bearer token authentication: `Authorization: Bearer YOUR_DEVZERY_API_KEY`
- API keys and sensitive data are never logged or exposed in the workflow output.

## 🔄 GitHub Context

When triggering API tests, the action automatically includes GitHub workflow context in the payload sent to Devzery:

```json
{
  "your_custom_payload": "here",
  "workflow_config": {},
  "test_config": {},
  "github_context": {
    "repository": {
      "owner": "your-username",
      "repo": "your-repo"
    },
    "ref": "refs/heads/main",
    "sha": "abc123...",
    "actor": "username",
    "workflow": "API Testing Pipeline",
    "job": "api-tests",
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


## 📋 Requirements

- Node.js 20+
- A valid Devzery account and API key
- Properly configured API endpoints and tests in your Devzery dashboard

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ❓ Support

- 📚 [Devzery Documentation](https://docs.devzery.com)
- 🐛 [Issue Tracker](https://github.com/devzery/devzery-action/issues)
- 💬 [Discussions](https://github.com/devzery/devzery-action/discussions)
- 🌐 [Devzery Platform](https://devzery.com)

## 🏷️ Marketplace

This action is available on the [GitHub Marketplace](https://github.com/marketplace/actions/devzery-api-testing). You can also find it by searching for "Devzery API Testing" in the Actions tab of your repository.

---

Made with ❤️ by [Devzery](https://devzery.com)
