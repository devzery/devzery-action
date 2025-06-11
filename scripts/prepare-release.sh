#!/bin/bash

# Release preparation script for Devzery GitHub Action
# This script builds, tests, and prepares the action for release

set -e

echo "🚀 Preparing Devzery GitHub Action for Release"
echo "=============================================="

# Check if we're in the right directory
if [ ! -f "action.yml" ]; then
    echo "❌ action.yml not found. Please run this script from the repository root."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Build the action
echo "🔨 Building the action..."
npm run build

# Run basic validation
echo "🧪 Running validation..."
if [ ! -f "dist/index.js" ]; then
    echo "❌ Build failed - dist/index.js not found"
    exit 1
fi

if [ ! -s "dist/index.js" ]; then
    echo "❌ Build failed - dist/index.js is empty"
    exit 1
fi

# Check for TypeScript compilation errors
echo "🔍 Checking TypeScript compilation..."
npx tsc --noEmit

# Validate action.yml
echo "📋 Validating action.yml..."
if ! grep -q "runs:" action.yml; then
    echo "❌ action.yml is missing 'runs:' section"
    exit 1
fi

if ! grep -q "node20" action.yml; then
    echo "❌ action.yml should use node20"
    exit 1
fi

# Check if all required files exist
echo "📁 Checking required files..."
required_files=("README.md" "LICENSE" "action.yml" "package.json" "dist/index.js")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Required file missing: $file"
        exit 1
    fi
done

# Verify dist directory is up to date
echo "🔄 Verifying dist directory is up to date..."
npm run build
if git diff --exit-code dist/; then
    echo "✅ dist directory is up to date"
else
    echo "❌ dist directory is not up to date. Please run 'npm run build' and commit changes."
    exit 1
fi

echo ""
echo "✅ Release preparation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Commit and push all changes"
echo "2. Create a new release tag (e.g., v1.0.0)"
echo "3. Push the tag: git push origin v1.0.0"
echo "4. Create a GitHub release from the tag"
echo "5. Submit to GitHub Marketplace"
echo ""
echo "🏷️  Suggested tag creation:"
echo "   git tag -a v1.0.0 -m 'Release v1.0.0'"
echo "   git push origin v1.0.0"
