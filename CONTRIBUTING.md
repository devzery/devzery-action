# Contributing to API Trigger Action

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/your-username/devzery-action.git
cd devzery-action
```

2. Install dependencies:
```bash
npm install
```

3. Make your changes in the `src/` directory

4. Build and test your changes:
```bash
npm run build
npm run test
```

5. Ensure the dist/ folder is updated:
```bash
npm run package
```

## Testing

Before submitting a pull request, please test your changes:

1. **Local testing**: Use the provided test scripts
2. **Integration testing**: Test with a real GitHub workflow
3. **Edge cases**: Test error scenarios and edge cases

## Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## Any contributions you make will be under the MIT Software License

When you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project.

## Report bugs using GitHub's [issue tracker](https://github.com/your-username/devzery-action/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/your-username/devzery-action/issues/new).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## License

By contributing, you agree that your contributions will be licensed under its MIT License.
