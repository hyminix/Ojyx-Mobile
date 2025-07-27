#!/bin/bash

# Ojyx Development Environment Setup
# One-time setup for new developers

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🎮 Ojyx Development Setup${NC}"
echo "This script will set up your development environment"
echo ""

# Navigate to project root
cd "$(dirname "$0")/.."
PROJECT_ROOT=$(pwd)

# Step 1: Check Flutter installation
echo -e "${BLUE}Step 1: Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed${NC}"
    echo "Please install Flutter first: https://flutter.dev/docs/get-started/install"
    exit 1
fi

flutter doctor
echo ""

# Step 2: Create .env file
echo -e "${BLUE}Step 2: Setting up environment variables...${NC}"
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${YELLOW}Created .env from .env.example${NC}"
        echo -e "${RED}⚠️  Please edit .env with your Supabase credentials${NC}"
    else
        echo -e "${RED}❌ No .env.example found${NC}"
    fi
else
    echo -e "${GREEN}✅ .env already exists${NC}"
fi

# Step 3: Install dependencies
echo -e "${BLUE}Step 3: Installing dependencies...${NC}"
flutter pub get

# Step 4: Generate code
echo -e "${BLUE}Step 4: Generating code...${NC}"
flutter pub run build_runner build --delete-conflicting-outputs || true

# Step 5: Configure Git
echo -e "${BLUE}Step 5: Configuring Git...${NC}"
git config core.autocrlf input || true

# Step 6: Make scripts executable
echo -e "${BLUE}Step 6: Making scripts executable...${NC}"
chmod +x dev-scripts/*.sh
chmod +x scripts/*.sh
chmod +x scripts/emulator/*.sh 2>/dev/null || true

# Step 7: Create aliases (optional)
echo -e "${BLUE}Step 7: Creating shell aliases...${NC}"
SHELL_RC=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

if [ -n "$SHELL_RC" ]; then
    echo "Would you like to add Ojyx aliases to your shell? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Add aliases if not already present
        if ! grep -q "ojyx-run" "$SHELL_RC"; then
            echo "" >> "$SHELL_RC"
            echo "# Ojyx development aliases" >> "$SHELL_RC"
            echo "alias ojyx-run='$PROJECT_ROOT/dev-scripts/quick-run.sh'" >> "$SHELL_RC"
            echo "alias ojyx-clean='$PROJECT_ROOT/dev-scripts/clean-build.sh'" >> "$SHELL_RC"
            echo "alias ojyx-gen='$PROJECT_ROOT/dev-scripts/generate.sh'" >> "$SHELL_RC"
            echo "alias ojyx-emu='$PROJECT_ROOT/scripts/emulator/start-emulator.sh'" >> "$SHELL_RC"
            echo -e "${GREEN}✅ Aliases added to $SHELL_RC${NC}"
            echo "Run 'source $SHELL_RC' to use them immediately"
        else
            echo -e "${YELLOW}Aliases already configured${NC}"
        fi
    fi
fi

# Step 8: VS Code setup check
echo -e "${BLUE}Step 8: Checking VS Code setup...${NC}"
if [ -d .vscode ]; then
    echo -e "${GREEN}✅ VS Code configuration found${NC}"
    echo "Recommended extensions:"
    echo "- Flutter (Dart-Code.flutter)"
    echo "- Dart (Dart-Code.dart-code)"
    echo "- Awesome Flutter Snippets"
    echo "- Error Lens"
else
    echo -e "${YELLOW}⚠️  No .vscode directory found${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}🎉 Setup completed!${NC}"
echo ""
echo "Next steps:"
echo "1. Edit .env with your Supabase credentials"
echo "2. Run './dev-scripts/quick-run.sh' to start developing"
echo "3. Or open VS Code and press F5"
echo ""
echo "Useful commands:"
echo "- ojyx-run    : Start the app"
echo "- ojyx-clean  : Clean build"
echo "- ojyx-gen    : Generate code"
echo "- ojyx-emu    : Start emulator"
echo ""
echo -e "${BLUE}Happy coding! 🚀${NC}"