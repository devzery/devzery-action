# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

Please report (suspected) security vulnerabilities to **[security@yourcompany.com](mailto:security@yourcompany.com)**. You will receive a response from us within 48 hours. If the issue is confirmed, we will release a patch as soon as possible depending on complexity but historically within a few days.

## Security Best Practices

When using this action:

1. **Always use GitHub Secrets** for API keys and sensitive data
2. **Never log or expose** API keys in workflow outputs
3. **Use HTTPS endpoints** for API calls
4. **Validate API responses** before using them in subsequent steps
5. **Set appropriate timeouts** to prevent hanging workflows
6. **Use specific version tags** rather than `@main` for production workflows

## Known Security Considerations

- API keys are passed as environment variables to the action
- Response data may contain sensitive information - handle appropriately
- Network requests are made to external services - ensure endpoints are trusted
- GitHub context is automatically included in POST/PUT requests

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine the affected versions
2. Audit code to find any potential similar problems
3. Prepare fixes for all releases still under maintenance
4. Release new versions as soon as possible
