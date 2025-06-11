<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# GitHub Action Development Guidelines

This is a TypeScript-based GitHub Action project that triggers backend APIs. When working on this project:

## Code Style
- Use TypeScript for all source code
- Follow GitHub Actions best practices for input validation and error handling
- Use @actions/core for logging and setting outputs
- Include proper error handling with detailed error messages

## Security Considerations
- Never log sensitive information like API keys
- Use GitHub secrets for sensitive inputs
- Validate all inputs before using them
- Handle authentication errors gracefully

## Testing
- Test the action with various input combinations
- Ensure proper error handling for network failures
- Validate that outputs are set correctly in both success and failure cases

## Documentation
- Keep README.md updated with usage examples
- Document all inputs and outputs clearly
- Include troubleshooting section for common issues

## Packaging
- Use @vercel/ncc to bundle the action for distribution
- Always run `npm run build` before releasing
- Ensure dist/ folder is committed to the repository
