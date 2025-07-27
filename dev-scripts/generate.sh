#!/bin/bash

# Ojyx Code Generation Script
# Runs build_runner for Freezed, Riverpod, etc.

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔧 Running Code Generation${NC}"

# Navigate to project root
cd "$(dirname "$0")/.."

# Check if build_runner is in dependencies
if ! grep -q "build_runner" pubspec.yaml; then
    echo -e "${YELLOW}⚠️  build_runner not found in dependencies${NC}"
    echo "Running flutter pub get first..."
    flutter pub get
fi

# Run build_runner
echo "Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

echo -e "${GREEN}✅ Code generation completed!${NC}"
echo ""
echo "Generated files:"
echo "- *.g.dart (JSON serialization)"
echo "- *.freezed.dart (Freezed models)"
echo "- *Provider.g.dart (Riverpod providers)"