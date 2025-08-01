#!/bin/bash

# flutter_cross_platform.sh - Advanced cross-platform Flutter build management
# Supports seamless switching between Windows and WSL2 environments

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print header
print_header() {
    echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
}

# Function to detect environment
detect_environment() {
    if [[ "$(uname -r)" =~ "microsoft" ]] || [[ "$(uname -r)" =~ "WSL" ]]; then
        echo "WSL2"
    elif [[ "$OS" == "Windows_NT" ]]; then
        echo "Windows"
    else
        echo "Linux"
    fi
}

# Function to save current environment state
save_environment_state() {
    local env_type="$1"
    local state_dir="$PROJECT_ROOT/.flutter_env_states"
    mkdir -p "$state_dir"
    
    # Save current files
    if [ -f "$PROJECT_ROOT/android/local.properties" ]; then
        cp "$PROJECT_ROOT/android/local.properties" "$state_dir/local.properties.$env_type"
    fi
    
    # Save environment info
    cat > "$state_dir/env.$env_type" << EOF
ENVIRONMENT=$env_type
SAVED_AT=$(date +%Y-%m-%d_%H:%M:%S)
FLUTTER_VERSION=$(flutter --version --machine | grep '"frameworkVersion"' | cut -d'"' -f4 || echo "unknown")
EOF
}

# Function to restore environment state
restore_environment_state() {
    local env_type="$1"
    local state_dir="$PROJECT_ROOT/.flutter_env_states"
    
    if [ -f "$state_dir/local.properties.$env_type" ]; then
        cp "$state_dir/local.properties.$env_type" "$PROJECT_ROOT/android/local.properties"
        echo -e "${GREEN}✓ Restored $env_type environment configuration${NC}"
        return 0
    fi
    
    return 1
}

# Function to create local.properties for WSL2
create_wsl2_config() {
    local android_sdk=""
    local flutter_sdk=""
    
    # Find Android SDK
    if [ -n "$ANDROID_HOME" ]; then
        android_sdk="$ANDROID_HOME"
    elif [ -d "$HOME/Android/Sdk" ]; then
        android_sdk="$HOME/Android/Sdk"
    elif [ -d "/opt/android-sdk" ]; then
        android_sdk="/opt/android-sdk"
    fi
    
    # Find Flutter SDK
    if [ -n "$FLUTTER_ROOT" ]; then
        flutter_sdk="$FLUTTER_ROOT"
    elif command -v flutter &> /dev/null; then
        flutter_sdk="$(dirname "$(dirname "$(which flutter)")")"
    elif [ -d "$HOME/flutter" ]; then
        flutter_sdk="$HOME/flutter"
    fi
    
    if [ -z "$android_sdk" ] || [ -z "$flutter_sdk" ]; then
        echo -e "${RED}Could not auto-detect SDK paths${NC}"
        return 1
    fi
    
    cat > "$PROJECT_ROOT/android/local.properties" << EOF
sdk.dir=$android_sdk
flutter.sdk=$flutter_sdk
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1
EOF
    
    echo -e "${GREEN}✓ Created WSL2 configuration${NC}"
    echo "  Android SDK: $android_sdk"
    echo "  Flutter SDK: $flutter_sdk"
}

# Function to clean build artifacts
clean_build_artifacts() {
    echo -e "${YELLOW}Cleaning build artifacts...${NC}"
    
    # Remove all build artifacts and generated files
    rm -rf "$PROJECT_ROOT/build"
    rm -rf "$PROJECT_ROOT/.dart_tool"
    rm -rf "$PROJECT_ROOT/android/.gradle"
    rm -rf "$PROJECT_ROOT/android/app/build"
    rm -f "$PROJECT_ROOT/.flutter-plugins"
    rm -f "$PROJECT_ROOT/.flutter-plugins-dependencies"
    
    # Clean Gradle cache for this project
    if [ -d "$HOME/.gradle/caches" ]; then
        find "$HOME/.gradle/caches" -name "*ojyx*" -type d -exec rm -rf {} + 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✓ Build artifacts cleaned${NC}"
}

# Function to setup environment
setup_environment() {
    local target_env="${1:-auto}"
    
    if [ "$target_env" = "auto" ]; then
        target_env=$(detect_environment)
    fi
    
    print_header "Flutter Cross-Platform Setup - $target_env"
    
    # Save current state if exists
    local current_env=$(detect_environment)
    if [ -f "$PROJECT_ROOT/android/local.properties" ]; then
        save_environment_state "$current_env"
    fi
    
    # Try to restore saved state first
    if restore_environment_state "$target_env"; then
        echo -e "${BLUE}Using saved $target_env configuration${NC}"
    else
        # Create new configuration
        case "$target_env" in
            "WSL2"|"Linux")
                create_wsl2_config || {
                    echo -e "${RED}Failed to create WSL2 configuration${NC}"
                    exit 1
                }
                ;;
            "Windows")
                echo -e "${YELLOW}Windows environment requires manual configuration${NC}"
                echo "Please update android/local.properties with your Windows paths"
                ;;
        esac
    fi
    
    # Clean and regenerate
    clean_build_artifacts
    
    echo -e "\n${YELLOW}Regenerating Flutter configuration...${NC}"
    cd "$PROJECT_ROOT"
    flutter pub get
    
    echo -e "\n${GREEN}✓ Environment setup complete!${NC}"
}

# Function to build APK
build_apk() {
    local build_type="${1:-debug}"
    
    print_header "Building APK ($build_type)"
    
    cd "$PROJECT_ROOT"
    
    # Ensure environment is set up
    if [ ! -f "android/local.properties" ]; then
        echo -e "${YELLOW}Setting up environment first...${NC}"
        setup_environment
    fi
    
    # Build with appropriate settings for current environment
    if [[ "$(detect_environment)" == "WSL2" ]]; then
        echo -e "${BLUE}Using WSL2 optimized build settings${NC}"
        export GRADLE_OPTS="-Xmx1024m -Dorg.gradle.daemon=false -Dorg.gradle.parallel=false"
    fi
    
    echo -e "${YELLOW}Building APK...${NC}"
    flutter build apk --$build_type
}

# Function to show status
show_status() {
    print_header "Flutter Environment Status"
    
    echo -e "${BLUE}Current Environment:${NC} $(detect_environment)"
    
    if [ -f "$PROJECT_ROOT/android/local.properties" ]; then
        echo -e "\n${BLUE}local.properties:${NC}"
        grep -E "sdk.dir|flutter.sdk" "$PROJECT_ROOT/android/local.properties" | sed 's/^/  /'
    else
        echo -e "\n${RED}No local.properties found${NC}"
    fi
    
    local state_dir="$PROJECT_ROOT/.flutter_env_states"
    if [ -d "$state_dir" ]; then
        echo -e "\n${BLUE}Saved Environments:${NC}"
        for env_file in "$state_dir"/env.*; do
            if [ -f "$env_file" ]; then
                local env_name=$(basename "$env_file" | cut -d. -f2)
                local saved_at=$(grep SAVED_AT "$env_file" | cut -d= -f2)
                echo -e "  ${GREEN}$env_name${NC} - saved at $saved_at"
            fi
        done
    fi
    
    echo -e "\n${BLUE}Flutter Doctor:${NC}"
    flutter doctor -v | grep -E "Flutter|Android|Java" | sed 's/^/  /'
}

# Main command handling
case "${1:-setup}" in
    "setup")
        setup_environment "${2:-auto}"
        ;;
    "build")
        build_apk "${2:-debug}"
        ;;
    "clean")
        clean_build_artifacts
        ;;
    "status")
        show_status
        ;;
    "save")
        save_environment_state "$(detect_environment)"
        echo -e "${GREEN}✓ Saved current environment state${NC}"
        ;;
    "switch")
        if [ "$2" = "windows" ]; then
            setup_environment "Windows"
        elif [ "$2" = "wsl2" ] || [ "$2" = "wsl" ]; then
            setup_environment "WSL2"
        else
            echo -e "${RED}Usage: $0 switch [windows|wsl2]${NC}"
            exit 1
        fi
        ;;
    "help"|"--help"|"-h")
        echo "Flutter Cross-Platform Build Tool"
        echo ""
        echo "Usage: $0 [command] [options]"
        echo ""
        echo "Commands:"
        echo "  setup [auto|wsl2|windows]  - Setup environment (default: auto-detect)"
        echo "  build [debug|release]      - Build APK (default: debug)"
        echo "  clean                      - Clean all build artifacts"
        echo "  status                     - Show current environment status"
        echo "  save                       - Save current environment state"
        echo "  switch [windows|wsl2]      - Switch to specific environment"
        echo "  help                       - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0                   # Auto setup for current environment"
        echo "  $0 build release     # Build release APK"
        echo "  $0 switch wsl2       # Switch to WSL2 environment"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac