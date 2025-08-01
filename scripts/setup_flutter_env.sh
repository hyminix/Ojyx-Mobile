#!/bin/bash

# setup_flutter_env.sh - Configure Flutter for current environment (Windows/WSL2)
# This script auto-detects your environment and sets up the correct paths

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Flutter Environment Setup${NC}"
echo "========================="

# Detect environment
if [[ "$(uname -r)" =~ "microsoft" ]] || [[ "$(uname -r)" =~ "WSL" ]]; then
    ENVIRONMENT="WSL2"
else
    ENVIRONMENT="Linux"
fi

# Check if running from Windows (Git Bash, etc)
if [[ "$OS" == "Windows_NT" ]]; then
    ENVIRONMENT="Windows"
fi

echo -e "Detected environment: ${YELLOW}$ENVIRONMENT${NC}"

# Function to create local.properties for WSL2
setup_wsl2() {
    echo -e "${GREEN}Setting up Flutter for WSL2...${NC}"
    
    # Find Android SDK
    if [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_SDK="$HOME/Android/Sdk"
    elif [ -d "/opt/android-sdk" ]; then
        ANDROID_SDK="/opt/android-sdk"
    else
        echo -e "${RED}Android SDK not found!${NC}"
        echo "Please install Android SDK or set ANDROID_HOME"
        exit 1
    fi
    
    # Find Flutter SDK
    if [ -n "$FLUTTER_ROOT" ]; then
        FLUTTER_SDK="$FLUTTER_ROOT"
    elif [ -d "$HOME/flutter" ]; then
        FLUTTER_SDK="$HOME/flutter"
    elif command -v flutter &> /dev/null; then
        FLUTTER_SDK="$(dirname "$(dirname "$(which flutter)")")"
    else
        echo -e "${RED}Flutter SDK not found!${NC}"
        echo "Please install Flutter or set FLUTTER_ROOT"
        exit 1
    fi
    
    # Create local.properties
    cat > "$PROJECT_ROOT/android/local.properties" << EOF
sdk.dir=$ANDROID_SDK
flutter.sdk=$FLUTTER_SDK
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
EOF
    
    echo -e "${GREEN}✓ Created android/local.properties for WSL2${NC}"
    echo "  Android SDK: $ANDROID_SDK"
    echo "  Flutter SDK: $FLUTTER_SDK"
}

# Function to create local.properties for Windows
setup_windows() {
    echo -e "${GREEN}Setting up Flutter for Windows...${NC}"
    echo -e "${YELLOW}Please update android/local.properties manually with your Windows paths:${NC}"
    
    cat > "$PROJECT_ROOT/android/local.properties" << 'EOF'
# TODO: Update these paths for your Windows system
sdk.dir=C:\\Users\\[YOUR_USERNAME]\\AppData\\Local\\Android\\sdk
flutter.sdk=D:\\dev\\flutter\\flutter
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
EOF
    
    echo -e "${YELLOW}⚠ Please edit android/local.properties and replace:${NC}"
    echo "  - [YOUR_USERNAME] with your Windows username"
    echo "  - flutter.sdk path with your Flutter installation path"
}

# Main setup based on environment
case "$ENVIRONMENT" in
    "WSL2"|"Linux")
        setup_wsl2
        ;;
    "Windows")
        setup_windows
        ;;
    *)
        echo -e "${RED}Unknown environment: $ENVIRONMENT${NC}"
        exit 1
        ;;
esac

# Clean Flutter environment
echo -e "\n${GREEN}Cleaning Flutter environment...${NC}"
cd "$PROJECT_ROOT"

# Remove generated files that might have wrong paths
rm -f .flutter-plugins
rm -f .flutter-plugins-dependencies
rm -rf .dart_tool/
rm -rf android/.gradle/
rm -rf android/app/build/

# Regenerate Flutter files
echo -e "${GREEN}Regenerating Flutter files...${NC}"
flutter pub get

echo -e "\n${GREEN}✓ Flutter environment setup complete!${NC}"
echo -e "${YELLOW}You can now build with:${NC}"
echo "  flutter build apk --debug"
echo -e "\n${YELLOW}Note:${NC} If switching between Windows and WSL2, run this script again."