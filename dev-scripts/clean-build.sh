#!/bin/bash

# Ojyx Clean Build Script
# Performs a complete clean and rebuild

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🧹 Ojyx Clean Build${NC}"
echo "This will clean and rebuild the entire project"
echo ""

# Navigate to project root
cd "$(dirname "$0")/.."

# Step 1: Flutter clean
echo -e "${YELLOW}Step 1/4: Cleaning Flutter build artifacts...${NC}"
flutter clean

# Step 2: Clean additional directories
echo -e "${YELLOW}Step 2/4: Cleaning additional directories...${NC}"
rm -rf .dart_tool/
rm -rf build/
rm -rf android/.gradle/
rm -rf android/app/build/
rm -f pubspec.lock
rm -f .flutter-plugins
rm -f .flutter-plugins-dependencies
rm -f .packages

# Step 3: Get dependencies
echo -e "${YELLOW}Step 3/4: Getting dependencies...${NC}"
flutter pub get

# Step 4: Generate code
echo -e "${YELLOW}Step 4/4: Running build_runner...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo -e "${GREEN}✅ Clean build completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "- Run './quick-run.sh' to start the app"
echo "- Or use VS Code F5 to debug"