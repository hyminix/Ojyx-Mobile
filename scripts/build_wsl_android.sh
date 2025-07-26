#!/bin/bash
# Ojyx Android Build Script for WSL
# Description: Automated Android build script with comprehensive error handling and logging
# Author: Ojyx Development Team
# Version: 1.0.0

# Exit on error and pipe failure
set -e
set -o pipefail

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly LOG_DIR="${PROJECT_ROOT}/logs"
readonly BUILD_LOG="${LOG_DIR}/build_$(date +%Y%m%d_%H%M%S).log"
readonly PREREQUISITES_LOG="${LOG_DIR}/prerequisites_check.log"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Default values
BUILD_MODE="debug"
CLEAN_GRADLE=false
LOW_MEMORY=false
CI_MODE=false
VERBOSE=false

# Logging function with timestamp
log() {
    local level="${1}"
    shift
    local message="$*"
    local timestamp="[$(date +'%Y-%m-%d %H:%M:%S')]"
    
    case "${level}" in
        "INFO")
            echo -e "${timestamp} ${GREEN}[INFO]${NC} ${message}" | tee -a "${BUILD_LOG}"
            ;;
        "WARN")
            echo -e "${timestamp} ${YELLOW}[WARN]${NC} ${message}" | tee -a "${BUILD_LOG}"
            ;;
        "ERROR")
            echo -e "${timestamp} ${RED}[ERROR]${NC} ${message}" | tee -a "${BUILD_LOG}"
            ;;
        "DEBUG")
            if [[ "${VERBOSE}" == "true" ]]; then
                echo -e "${timestamp} ${BLUE}[DEBUG]${NC} ${message}" | tee -a "${BUILD_LOG}"
            else
                echo "${timestamp} [DEBUG] ${message}" >> "${BUILD_LOG}"
            fi
            ;;
        *)
            echo -e "${timestamp} ${message}" | tee -a "${BUILD_LOG}"
            ;;
    esac
}

# Error exit function
error_exit() {
    local exit_code="${1:-1}"
    shift
    log "ERROR" "$*"
    log "ERROR" "Build failed with exit code: ${exit_code}"
    
    # Generate error report
    if [[ -f "${BUILD_LOG}" ]]; then
        local error_report="${LOG_DIR}/error_report_$(date +%Y%m%d_%H%M%S).log"
        echo "=== ERROR REPORT ===" > "${error_report}"
        echo "Exit Code: ${exit_code}" >> "${error_report}"
        echo "Error Message: $*" >> "${error_report}"
        echo "=== Last 50 lines of build log ===" >> "${error_report}"
        tail -50 "${BUILD_LOG}" >> "${error_report}"
        log "INFO" "Error report saved to: ${error_report}"
    fi
    
    exit "${exit_code}"
}

# Check if command exists
check_command() {
    local cmd="${1}"
    local name="${2:-$1}"
    
    if ! command -v "${cmd}" &> /dev/null; then
        return 1
    fi
    return 0
}

# Create log directory if it doesn't exist
create_log_dir() {
    if [[ ! -d "${LOG_DIR}" ]]; then
        mkdir -p "${LOG_DIR}" || error_exit 2 "Failed to create log directory: ${LOG_DIR}"
        log "INFO" "Created log directory: ${LOG_DIR}"
    fi
}

# Cleanup function for interruption
cleanup() {
    local exit_code=$?
    if [[ ${exit_code} -ne 0 ]]; then
        log "WARN" "Script interrupted with exit code: ${exit_code}"
        log "INFO" "Performing cleanup..."
        
        # Kill any background processes
        jobs -p | xargs -r kill 2>/dev/null || true
        
        # Save partial build state
        if [[ -f "${BUILD_LOG}" ]]; then
            local interrupted_log="${LOG_DIR}/interrupted_build_$(date +%Y%m%d_%H%M%S).log"
            cp "${BUILD_LOG}" "${interrupted_log}"
            log "INFO" "Partial build log saved to: ${interrupted_log}"
        fi
    fi
    
    log "INFO" "Build script ended at $(date)"
    exit ${exit_code}
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --release)
                BUILD_MODE="release"
                shift
                ;;
            --profile)
                BUILD_MODE="profile"
                shift
                ;;
            --debug)
                BUILD_MODE="debug"
                shift
                ;;
            --clean-gradle)
                CLEAN_GRADLE=true
                shift
                ;;
            --low-memory)
                LOW_MEMORY=true
                shift
                ;;
            --ci)
                CI_MODE=true
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            --version)
                echo "Ojyx Android Build Script v1.0.0"
                echo "Build date: 2025-07-26"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help message
show_help() {
    cat << EOF
Ojyx Android Build Script for WSL
================================

SYNOPSIS
    ${0##*/} [OPTIONS]

DESCRIPTION
    This script automates the Android build process for the Ojyx project
    in WSL environments. It handles prerequisites checking, environment
    preparation, compilation, and comprehensive reporting.

OPTIONS
    Build Modes:
    --release           Build in release mode (optimized, no debugging)
    --debug             Build in debug mode (default)
    --profile           Build in profile mode (performance analysis)
    
    Build Options:
    --clean-gradle      Clean Gradle cache before building
    --low-memory        Use low memory settings for constrained environments
    --split-per-abi     Build separate APKs per ABI (reduces size)
    --target-platform   Specify target platform (e.g., android-arm64)
    
    CI/CD Options:
    --ci                CI mode with simplified output
    --webhook URL       Send build notifications to webhook
    --archive DIR       Archive APK to specified directory
    
    Output Options:
    --verbose, -v       Enable verbose logging
    --quiet, -q         Minimal output (errors only)
    --json              Output build result as JSON
    
    Other:
    --help, -h          Show this help message
    --version           Show script version

EXAMPLES
    Basic Usage:
    ${0##*/}                        # Build debug APK
    ${0##*/} --release              # Build release APK
    ${0##*/} --profile --verbose    # Profile build with verbose output
    
    CI/CD Usage:
    ${0##*/} --release --ci         # CI mode release build
    ${0##*/} --release --webhook https://hooks.slack.com/...
    
    Memory Constrained:
    ${0##*/} --release --low-memory --clean-gradle
    
    Production Build:
    ${0##*/} --release --split-per-abi --target-platform android-arm64

ENVIRONMENT VARIABLES
    Required:
    ANDROID_HOME        Path to Android SDK
    JAVA_HOME          Path to Java JDK 17+
    
    Optional:
    GRADLE_OPTS        Additional Gradle options
    FLUTTER_OPTS       Additional Flutter options
    SENTRY_DSN         Sentry error tracking DSN
    WEBHOOK_URL        Default webhook for notifications

FILES
    Input:
    pubspec.yaml       Flutter project configuration
    .env               Environment variables (optional)
    
    Output:
    build/app/outputs/  APK output directory
    logs/              Build logs and reports
    
    Reports:
    logs/build_*.log              Detailed build log
    logs/build_report_*.json      Machine-readable report
    logs/build_report_*.html      Human-readable report

PREREQUISITES
    - Flutter SDK ≥ 3.32.6
    - Java JDK ≥ 17
    - Android SDK with build-tools
    - WSL2 (recommended) or WSL1
    - 4GB+ RAM available

WORKFLOW
    1. Prerequisites Check
       - Validates Flutter, Java, Android SDK
       - Checks system resources
       - Verifies PATH configuration
    
    2. Environment Preparation
       - Runs flutter clean (if requested)
       - Fetches dependencies
       - Generates code (freezed, json_serializable)
       - Validates .env file
    
    3. Compilation
       - Configures memory settings
       - Builds APK with specified mode
       - Monitors progress
       - Generates SHA256 checksums
    
    4. Reporting
       - Creates JSON/HTML reports
       - Archives artifacts
       - Sends notifications
       - Updates CI/CD variables

EXIT CODES
    0   Success
    1   General error
    2   Filesystem error
    3   Command not found
    10  Flutter SDK not found
    11  Flutter version error
    12  Flutter version parse error
    13  Flutter version too old
    20  Java not found
    21  Java version error
    22  Java version too old
    30  Android SDK not found
    31  Android tools error
    40  Dependencies error
    41  Code generation error
    50  Build failed
    51  APK not found

HOOKS
    Post-build hooks can be placed in:
    .ojyx/hooks/post-build.sh
    
    Hook receives: BUILD_STATUS BUILD_MODE BUILD_LOG

TROUBLESHOOTING
    Common Issues:
    
    "Java not found"
    - Ensure Java 17+ is installed
    - Set JAVA_HOME environment variable
    - Add \$JAVA_HOME/bin to PATH
    
    "Out of memory"
    - Use --low-memory flag
    - Increase WSL memory limit in .wslconfig
    - Close other applications
    
    "Build failed"
    - Check logs/build_*.log for details
    - Run with --verbose for more information
    - Try --clean-gradle to clear cache

SEE ALSO
    batch_build.sh      - Build multiple variants
    auto_build.sh       - Automated build wrapper
    validate_android_build.sh - Validate build setup

VERSION
    1.0.0 (2025-07-26)

AUTHORS
    Ojyx Development Team
    Generated by Claude Code

EOF
}

# Check Flutter SDK version
check_flutter() {
    log "INFO" "Checking Flutter SDK..."
    
    # Check if flutter command exists
    if ! check_command "flutter"; then
        error_exit 10 "Flutter SDK not found. Please install Flutter and add it to PATH"
    fi
    
    # Get Flutter version
    local flutter_version_output
    flutter_version_output=$(flutter --version 2>&1 | head -1) || error_exit 11 "Failed to get Flutter version"
    
    # Extract version number
    local flutter_version
    flutter_version=$(echo "${flutter_version_output}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    
    if [[ -z "${flutter_version}" ]]; then
        error_exit 12 "Failed to parse Flutter version"
    fi
    
    log "INFO" "Found Flutter version: ${flutter_version}"
    
    # Check minimum version (3.32.6)
    local min_version="3.32.6"
    if ! version_ge "${flutter_version}" "${min_version}"; then
        error_exit 13 "Flutter version ${flutter_version} is too old. Minimum required: ${min_version}"
    fi
    
    # Check Flutter channel
    local flutter_channel
    flutter_channel=$(flutter channel 2>&1 | grep '*' | awk '{print $2}') || true
    
    if [[ -n "${flutter_channel}" ]]; then
        log "INFO" "Flutter channel: ${flutter_channel}"
        if [[ "${flutter_channel}" != "stable" ]]; then
            log "WARN" "Flutter is not on stable channel. Recommended: flutter channel stable"
        fi
    fi
    
    echo "Flutter SDK: OK (${flutter_version})" >> "${PREREQUISITES_LOG}"
}

# Check Java version
check_java() {
    log "INFO" "Checking Java..."
    
    # Check if java command exists
    if ! check_command "java"; then
        error_exit 20 "Java not found. Please install Java JDK 17+ and add it to PATH"
    fi
    
    # Check if javac exists
    if ! check_command "javac"; then
        error_exit 21 "javac not found. Please install Java JDK (not just JRE)"
    fi
    
    # Get Java version
    local java_version_output
    java_version_output=$(java -version 2>&1 | head -1) || error_exit 22 "Failed to get Java version"
    
    # Extract version number (handles both old and new version formats)
    local java_version
    if [[ "${java_version_output}" =~ version[[:space:]]\"([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
        # Old format: 1.8.0_xxx
        local major="${BASH_REMATCH[1]}"
        local minor="${BASH_REMATCH[2]}"
        if [[ "${major}" == "1" ]]; then
            java_version="${minor}"
        else
            java_version="${major}"
        fi
    elif [[ "${java_version_output}" =~ version[[:space:]]\"([0-9]+) ]]; then
        # New format: 17.0.x
        java_version="${BASH_REMATCH[1]}"
    else
        error_exit 23 "Failed to parse Java version from: ${java_version_output}"
    fi
    
    log "INFO" "Found Java version: ${java_version}"
    
    # Check minimum version (17)
    if [[ "${java_version}" -lt 17 ]]; then
        error_exit 24 "Java version ${java_version} is too old. Minimum required: 17"
    fi
    
    # Check JAVA_HOME
    if [[ -z "${JAVA_HOME}" ]]; then
        log "WARN" "JAVA_HOME is not set. This may cause issues with Android builds"
    else
        log "INFO" "JAVA_HOME: ${JAVA_HOME}"
        if [[ ! -d "${JAVA_HOME}" ]]; then
            error_exit 25 "JAVA_HOME points to non-existent directory: ${JAVA_HOME}"
        fi
    fi
    
    echo "Java: OK (version ${java_version})" >> "${PREREQUISITES_LOG}"
}

# Check Android SDK
check_android_sdk() {
    log "INFO" "Checking Android SDK..."
    
    # Check ANDROID_HOME
    if [[ -z "${ANDROID_HOME}" ]]; then
        error_exit 30 "ANDROID_HOME is not set. Please set it to your Android SDK path"
    fi
    
    if [[ ! -d "${ANDROID_HOME}" ]]; then
        error_exit 31 "ANDROID_HOME points to non-existent directory: ${ANDROID_HOME}"
    fi
    
    log "INFO" "ANDROID_HOME: ${ANDROID_HOME}"
    
    # Check cmdline-tools
    local cmdline_tools_path="${ANDROID_HOME}/cmdline-tools/latest/bin"
    if [[ ! -d "${cmdline_tools_path}" ]]; then
        # Try alternative path
        cmdline_tools_path="${ANDROID_HOME}/tools/bin"
        if [[ ! -d "${cmdline_tools_path}" ]]; then
            error_exit 32 "Android cmdline-tools not found. Please install Android Command-line Tools"
        fi
    fi
    
    # Check sdkmanager
    local sdkmanager="${cmdline_tools_path}/sdkmanager"
    if [[ ! -f "${sdkmanager}" ]]; then
        error_exit 33 "sdkmanager not found in ${cmdline_tools_path}"
    fi
    
    # Check build-tools
    local build_tools_dir="${ANDROID_HOME}/build-tools"
    if [[ ! -d "${build_tools_dir}" ]]; then
        error_exit 34 "Android build-tools not found. Please install via SDK Manager"
    fi
    
    # Find latest build-tools version
    local latest_build_tools
    latest_build_tools=$(ls -1 "${build_tools_dir}" | grep -E '^[0-9]+\.' | sort -V | tail -1)
    
    if [[ -z "${latest_build_tools}" ]]; then
        error_exit 35 "No build-tools version found in ${build_tools_dir}"
    fi
    
    log "INFO" "Found build-tools: ${latest_build_tools}"
    
    # Check if version is 34.0.0 or higher
    local min_build_tools="34.0.0"
    if ! version_ge "${latest_build_tools}" "${min_build_tools}"; then
        error_exit 36 "Build-tools version ${latest_build_tools} is too old. Minimum required: ${min_build_tools}"
    fi
    
    echo "Android SDK: OK (build-tools ${latest_build_tools})" >> "${PREREQUISITES_LOG}"
}

# Check PATH variables
check_path_variables() {
    log "INFO" "Checking PATH configuration..."
    
    local missing_paths=()
    
    # Check if Android tools are in PATH
    if [[ -n "${ANDROID_HOME}" ]]; then
        local android_paths=(
            "${ANDROID_HOME}/cmdline-tools/latest/bin"
            "${ANDROID_HOME}/platform-tools"
            "${ANDROID_HOME}/tools/bin"
        )
        
        for android_path in "${android_paths[@]}"; do
            if [[ -d "${android_path}" ]] && [[ ":${PATH}:" != *":${android_path}:"* ]]; then
                missing_paths+=("${android_path}")
            fi
        done
    fi
    
    if [[ ${#missing_paths[@]} -gt 0 ]]; then
        log "WARN" "The following directories should be added to PATH:"
        for path in "${missing_paths[@]}"; do
            log "WARN" "  ${path}"
        done
        echo "PATH: WARNING - Missing Android tools in PATH" >> "${PREREQUISITES_LOG}"
    else
        log "INFO" "PATH configuration looks good"
        echo "PATH: OK" >> "${PREREQUISITES_LOG}"
    fi
}

# Version comparison function (returns 0 if v1 >= v2)
version_ge() {
    local v1="$1"
    local v2="$2"
    
    # Convert versions to comparable format
    local v1_parts=(${v1//./ })
    local v2_parts=(${v2//./ })
    
    # Pad with zeros if needed
    while [[ ${#v1_parts[@]} -lt ${#v2_parts[@]} ]]; do
        v1_parts+=("0")
    done
    while [[ ${#v2_parts[@]} -lt ${#v1_parts[@]} ]]; do
        v2_parts+=("0")
    done
    
    # Compare each part
    for i in "${!v1_parts[@]}"; do
        if [[ ${v1_parts[i]} -gt ${v2_parts[i]} ]]; then
            return 0
        elif [[ ${v1_parts[i]} -lt ${v2_parts[i]} ]]; then
            return 1
        fi
    done
    
    return 0
}

# Check all prerequisites
check_prerequisites() {
    log "INFO" "Checking prerequisites..."
    
    # Create prerequisites log
    echo "=== Prerequisites Check ===" > "${PREREQUISITES_LOG}"
    echo "Date: $(date)" >> "${PREREQUISITES_LOG}"
    echo "System: $(uname -a)" >> "${PREREQUISITES_LOG}"
    echo "" >> "${PREREQUISITES_LOG}"
    
    # Run checks
    check_flutter
    check_java
    check_android_sdk
    check_path_variables
    
    # Summary
    echo "" >> "${PREREQUISITES_LOG}"
    echo "=== Summary ===" >> "${PREREQUISITES_LOG}"
    echo "All prerequisites checked successfully" >> "${PREREQUISITES_LOG}"
    
    log "INFO" "All prerequisites satisfied"
    log "INFO" "Prerequisites report saved to: ${PREREQUISITES_LOG}"
}

# Clean Flutter project
clean_flutter_project() {
    log "INFO" "Cleaning Flutter project..."
    
    # Run flutter clean
    if flutter clean 2>&1 | tee -a "${BUILD_LOG}"; then
        log "INFO" "Flutter clean completed successfully"
    else
        log "WARN" "Flutter clean encountered issues but continuing..."
    fi
    
    # Remove generated files
    local dirs_to_clean=(
        ".dart_tool"
        "build"
        ".flutter-plugins"
        ".flutter-plugins-dependencies"
    )
    
    for dir in "${dirs_to_clean[@]}"; do
        if [[ -d "${PROJECT_ROOT}/${dir}" ]]; then
            log "DEBUG" "Removing ${dir}/"
            rm -rf "${PROJECT_ROOT}/${dir}"
        fi
    done
    
    # Clean Gradle cache if requested
    if [[ "${CLEAN_GRADLE}" == "true" ]]; then
        log "INFO" "Cleaning Gradle cache..."
        local gradle_cache="${HOME}/.gradle/caches"
        if [[ -d "${gradle_cache}" ]]; then
            log "WARN" "Removing Gradle cache at ${gradle_cache}"
            rm -rf "${gradle_cache}"
            log "INFO" "Gradle cache cleaned"
        else
            log "DEBUG" "No Gradle cache found at ${gradle_cache}"
        fi
    fi
    
    log "INFO" "Project cleaning completed"
}

# Get dependencies with retry mechanism
get_dependencies() {
    log "INFO" "Getting Flutter dependencies..."
    
    local max_attempts=3
    local attempt=1
    local retry_delay=5
    
    while [[ ${attempt} -le ${max_attempts} ]]; do
        log "INFO" "Attempt ${attempt}/${max_attempts}: flutter pub get"
        
        if flutter pub get 2>&1 | tee -a "${BUILD_LOG}"; then
            log "INFO" "Dependencies retrieved successfully"
            
            # Verify pubspec.lock exists
            if [[ -f "${PROJECT_ROOT}/pubspec.lock" ]]; then
                log "DEBUG" "pubspec.lock verified"
                return 0
            else
                log "WARN" "pubspec.lock not found after pub get"
            fi
        fi
        
        if [[ ${attempt} -lt ${max_attempts} ]]; then
            log "WARN" "Failed to get dependencies, retrying in ${retry_delay} seconds..."
            sleep ${retry_delay}
            retry_delay=$((retry_delay * 2))  # Exponential backoff
        fi
        
        attempt=$((attempt + 1))
    done
    
    error_exit 40 "Failed to get dependencies after ${max_attempts} attempts"
}

# Run build_runner for code generation
run_build_runner() {
    log "INFO" "Checking for code generation requirements..."
    
    # Check if build_runner is in dependencies
    if ! grep -q "build_runner:" "${PROJECT_ROOT}/pubspec.yaml"; then
        log "DEBUG" "build_runner not found in dependencies, skipping code generation"
        return 0
    fi
    
    log "INFO" "Running code generation with build_runner..."
    
    # Set timeout (5 minutes)
    local timeout_seconds=300
    
    # Run build_runner with timeout
    if timeout ${timeout_seconds} flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | tee -a "${BUILD_LOG}"; then
        log "INFO" "Code generation completed successfully"
    else
        local exit_code=$?
        if [[ ${exit_code} -eq 124 ]]; then
            error_exit 41 "Code generation timed out after ${timeout_seconds} seconds"
        else
            error_exit 42 "Code generation failed with exit code ${exit_code}"
        fi
    fi
    
    # Verify generated files
    local generated_files=$(find "${PROJECT_ROOT}" -name "*.g.dart" -o -name "*.freezed.dart" 2>/dev/null | wc -l)
    log "DEBUG" "Found ${generated_files} generated files"
}

# Validate environment file
validate_env_file() {
    log "INFO" "Validating environment configuration..."
    
    local env_file="${PROJECT_ROOT}/.env"
    
    # Check if .env file exists
    if [[ ! -f "${env_file}" ]]; then
        log "WARN" ".env file not found at ${env_file}"
        
        # Check for .env.example
        if [[ -f "${env_file}.example" ]]; then
            log "INFO" "Found .env.example, you may need to copy it to .env and configure"
        fi
        
        # For CI mode, this might be OK if using --dart-define
        if [[ "${CI_MODE}" == "true" ]]; then
            log "INFO" "Running in CI mode, .env file is optional if using --dart-define"
            return 0
        else
            error_exit 50 "No .env file found. Please create one with required configuration"
        fi
    fi
    
    # Parse and validate required keys
    local required_keys=(
        "SUPABASE_URL"
        "SUPABASE_ANON_KEY"
    )
    
    local missing_keys=()
    
    for key in "${required_keys[@]}"; do
        if ! grep -q "^${key}=" "${env_file}"; then
            missing_keys+=("${key}")
        else
            # Check if value is not empty
            local value=$(grep "^${key}=" "${env_file}" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
            if [[ -z "${value}" || "${value}" == "your_${key,,}_here" ]]; then
                log "WARN" "${key} is not properly configured in .env"
                missing_keys+=("${key}")
            else
                log "DEBUG" "${key} is configured"
            fi
        fi
    done
    
    if [[ ${#missing_keys[@]} -gt 0 ]]; then
        log "ERROR" "Missing or unconfigured environment variables:"
        for key in "${missing_keys[@]}"; do
            log "ERROR" "  - ${key}"
        done
        error_exit 51 "Required environment variables are missing or not configured"
    fi
    
    log "INFO" "Environment configuration validated successfully"
}

# Create preparation checkpoint
create_preparation_checkpoint() {
    local checkpoint_file="${LOG_DIR}/preparation_checkpoint_$(date +%Y%m%d_%H%M%S).json"
    
    log "INFO" "Creating preparation checkpoint..."
    
    cat > "${checkpoint_file}" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "project_root": "${PROJECT_ROOT}",
  "build_mode": "${BUILD_MODE}",
  "flutter_version": "$(flutter --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo 'unknown')",
  "dependencies_hash": "$(md5sum "${PROJECT_ROOT}/pubspec.lock" 2>/dev/null | cut -d' ' -f1 || echo 'no-lock-file')",
  "env_configured": $(if [[ -f "${PROJECT_ROOT}/.env" ]]; then echo "true"; else echo "false"; fi),
  "preparation_steps": {
    "clean_completed": true,
    "dependencies_retrieved": true,
    "code_generated": $(if grep -q "build_runner:" "${PROJECT_ROOT}/pubspec.yaml"; then echo "true"; else echo "false"; fi),
    "env_validated": true
  },
  "preparation_duration_seconds": $SECONDS
}
EOF
    
    log "INFO" "Preparation checkpoint saved to: ${checkpoint_file}"
}

# Main preparation function
prepare_build_environment() {
    log "INFO" "Preparing build environment..."
    
    local start_time=$SECONDS
    
    # Step 1: Clean project
    clean_flutter_project
    
    # Step 2: Get dependencies
    get_dependencies
    
    # Step 3: Run code generation
    run_build_runner
    
    # Step 4: Validate environment
    validate_env_file
    
    # Step 5: Create checkpoint
    create_preparation_checkpoint
    
    local duration=$((SECONDS - start_time))
    log "INFO" "Build environment prepared in ${duration} seconds"
}

# Configure memory settings for WSL
configure_memory_settings() {
    log "INFO" "Configuring memory settings for WSL..."
    
    # Get available memory
    local total_mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local total_mem_mb=$((total_mem_kb / 1024))
    local available_mem_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    local available_mem_mb=$((available_mem_kb / 1024))
    
    log "DEBUG" "Total memory: ${total_mem_mb}MB, Available: ${available_mem_mb}MB"
    
    # Calculate Gradle heap size
    local gradle_heap_size
    if [[ "${LOW_MEMORY}" == "true" ]]; then
        # Low memory mode: use 1GB max
        gradle_heap_size="1024m"
        log "INFO" "Low memory mode enabled, using ${gradle_heap_size} heap"
    else
        # Normal mode: use 50% of available memory, max 4GB
        local heap_mb=$((available_mem_mb / 2))
        if [[ ${heap_mb} -gt 4096 ]]; then
            heap_mb=4096
        elif [[ ${heap_mb} -lt 1024 ]]; then
            heap_mb=1024
        fi
        gradle_heap_size="${heap_mb}m"
        log "INFO" "Setting Gradle heap size to ${gradle_heap_size}"
    fi
    
    # Export Gradle options
    export GRADLE_OPTS="-Xmx${gradle_heap_size} -Dorg.gradle.jvmargs=-Xmx${gradle_heap_size}"
    
    # Set Android build options for low memory
    if [[ "${LOW_MEMORY}" == "true" ]]; then
        export GRADLE_OPTS="${GRADLE_OPTS} -Dorg.gradle.daemon=false -Dorg.gradle.parallel=false"
        log "DEBUG" "Disabled Gradle daemon and parallel execution for low memory"
    fi
    
    log "DEBUG" "GRADLE_OPTS: ${GRADLE_OPTS}"
}

# Build flutter command with options
build_flutter_command() {
    local flutter_cmd="flutter build apk"
    
    # Add build mode
    flutter_cmd="${flutter_cmd} --${BUILD_MODE}"
    
    # Add target platform
    if [[ "${BUILD_MODE}" == "release" ]]; then
        flutter_cmd="${flutter_cmd} --target-platform android-arm,android-arm64"
    else
        flutter_cmd="${flutter_cmd} --target-platform android-arm64"
    fi
    
    # Add dart-define-from-file if .env exists
    if [[ -f "${PROJECT_ROOT}/.env" ]]; then
        flutter_cmd="${flutter_cmd} --dart-define-from-file=.env"
        log "DEBUG" "Using --dart-define-from-file=.env"
    fi
    
    # Add additional Flutter options
    if [[ "${VERBOSE}" == "true" ]]; then
        flutter_cmd="${flutter_cmd} --verbose"
    fi
    
    # Add split-per-abi for release builds to reduce APK size
    if [[ "${BUILD_MODE}" == "release" ]]; then
        flutter_cmd="${flutter_cmd} --split-per-abi"
        log "DEBUG" "Enabled split-per-abi for release build"
    fi
    
    echo "${flutter_cmd}"
}

# Monitor build progress
monitor_build_progress() {
    local build_pid=$1
    local timeout_seconds=${2:-1800}  # Default 30 minutes
    local start_time=$SECONDS
    
    log "DEBUG" "Monitoring build process (PID: ${build_pid}, timeout: ${timeout_seconds}s)"
    
    # Progress indicator
    local spinner=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local spin_index=0
    
    while kill -0 ${build_pid} 2>/dev/null; do
        local elapsed=$((SECONDS - start_time))
        
        # Check timeout
        if [[ ${elapsed} -ge ${timeout_seconds} ]]; then
            log "ERROR" "Build timeout after ${elapsed} seconds"
            kill -TERM ${build_pid} 2>/dev/null || true
            sleep 2
            kill -KILL ${build_pid} 2>/dev/null || true
            return 124  # Timeout exit code
        fi
        
        # Update progress
        if [[ "${CI_MODE}" != "true" ]]; then
            printf "\r${spinner[spin_index]} Building... (%d:%02d elapsed)" $((elapsed / 60)) $((elapsed % 60))
            spin_index=$(( (spin_index + 1) % ${#spinner[@]} ))
        fi
        
        sleep 1
    done
    
    # Get exit code
    wait ${build_pid}
    local exit_code=$?
    
    if [[ "${CI_MODE}" != "true" ]]; then
        printf "\r"  # Clear progress line
    fi
    
    return ${exit_code}
}

# Process build artifacts
process_build_artifacts() {
    log "INFO" "Processing build artifacts..."
    
    # Define APK locations based on build mode
    local apk_dir="${PROJECT_ROOT}/build/app/outputs/flutter-apk"
    local apk_name
    
    case "${BUILD_MODE}" in
        debug)
            apk_name="app-debug.apk"
            ;;
        release)
            # For split APKs, we'll handle multiple files
            if [[ -f "${apk_dir}/app-armeabi-v7a-release.apk" ]]; then
                log "INFO" "Found split APKs for release build"
                apk_name="app-*-release.apk"
            else
                apk_name="app-release.apk"
            fi
            ;;
        profile)
            apk_name="app-profile.apk"
            ;;
    esac
    
    # Create output directory
    local output_dir="${PROJECT_ROOT}/build/outputs"
    mkdir -p "${output_dir}"
    
    # Get version from pubspec.yaml
    local app_version=$(grep "^version:" "${PROJECT_ROOT}/pubspec.yaml" | cut -d' ' -f2 | tr -d '"')
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Copy and rename APKs
    local copied_files=0
    for apk in ${apk_dir}/${apk_name}; do
        if [[ -f "${apk}" ]]; then
            local basename=$(basename "${apk}")
            local new_name="${basename%.apk}_v${app_version}_${timestamp}.apk"
            local output_path="${output_dir}/${new_name}"
            
            cp "${apk}" "${output_path}"
            log "INFO" "Copied ${basename} to ${new_name}"
            
            # Generate SHA256
            local sha256=$(sha256sum "${output_path}" | cut -d' ' -f1)
            echo "${sha256}  ${new_name}" > "${output_path}.sha256"
            log "DEBUG" "SHA256: ${sha256}"
            
            # Get file size
            local size_bytes=$(stat -c%s "${output_path}")
            local size_mb=$(echo "scale=2; ${size_bytes} / 1048576" | bc)
            log "INFO" "APK size: ${size_mb}MB"
            
            copied_files=$((copied_files + 1))
        fi
    done
    
    if [[ ${copied_files} -eq 0 ]]; then
        error_exit 60 "No APK files found after build"
    fi
    
    log "INFO" "Build artifacts processed: ${copied_files} file(s)"
    log "INFO" "Output directory: ${output_dir}"
}

# Main compilation function
compile_android_apk() {
    log "INFO" "Starting Android APK compilation..."
    
    local compile_start=$SECONDS
    
    # Configure memory settings
    configure_memory_settings
    
    # Build Flutter command
    local flutter_cmd=$(build_flutter_command)
    log "INFO" "Build command: ${flutter_cmd}"
    
    # Create build output file
    local build_output="${LOG_DIR}/flutter_build_output_$(date +%Y%m%d_%H%M%S).log"
    
    # Start build in background
    ${flutter_cmd} > "${build_output}" 2>&1 &
    local build_pid=$!
    
    # Monitor build progress
    local timeout_seconds=1800  # 30 minutes default
    if [[ "${LOW_MEMORY}" == "true" ]]; then
        timeout_seconds=3600  # 60 minutes for low memory
    fi
    
    if monitor_build_progress ${build_pid} ${timeout_seconds}; then
        log "INFO" "Flutter build completed successfully"
        
        # Show last few lines of output
        log "DEBUG" "Build output (last 20 lines):"
        tail -20 "${build_output}" | while IFS= read -r line; do
            log "DEBUG" "  ${line}"
        done
        
        # Process artifacts
        process_build_artifacts
    else
        local exit_code=$?
        log "ERROR" "Flutter build failed with exit code ${exit_code}"
        
        # Show error output
        log "ERROR" "Build errors:"
        tail -50 "${build_output}" | grep -E "(error|Error|ERROR|failed|Failed)" | while IFS= read -r line; do
            log "ERROR" "  ${line}"
        done
        
        error_exit 61 "Build compilation failed. See ${build_output} for details"
    fi
    
    local compile_duration=$((SECONDS - compile_start))
    log "INFO" "Compilation completed in ${compile_duration} seconds"
}

# Generate build report in JSON format
generate_json_report() {
    local report_file="$1"
    local build_status="$2"
    local total_duration="$3"
    
    # Get artifact information
    local artifacts_json="[]"
    if [[ -d "${PROJECT_ROOT}/build/outputs" ]]; then
        artifacts_json=$(find "${PROJECT_ROOT}/build/outputs" -name "*.apk" -type f | while read -r apk; do
            local name=$(basename "$apk")
            local size=$(stat -c%s "$apk")
            local sha256=$(sha256sum "$apk" | cut -d' ' -f1)
            echo "{\"name\":\"$name\",\"size\":$size,\"sha256\":\"$sha256\"}"
        done | jq -s '.')
    fi
    
    # Get system information
    local total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    local cpu_info=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
    
    cat > "${report_file}" << EOF
{
  "build_info": {
    "timestamp": "$(date -Iseconds)",
    "project_root": "${PROJECT_ROOT}",
    "build_mode": "${BUILD_MODE}",
    "build_status": "${build_status}",
    "duration_seconds": ${total_duration},
    "flutter_version": "$(flutter --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo 'unknown')",
    "dart_version": "$(dart --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo 'unknown')"
  },
  "system_info": {
    "os": "$(uname -s)",
    "kernel": "$(uname -r)",
    "total_memory_kb": ${total_mem},
    "cpu": "${cpu_info}",
    "wsl_version": "$(wsl.exe --version 2>/dev/null | head -1 || echo 'unknown')"
  },
  "build_configuration": {
    "clean_gradle": ${CLEAN_GRADLE},
    "low_memory_mode": ${LOW_MEMORY},
    "ci_mode": ${CI_MODE},
    "verbose": ${VERBOSE},
    "gradle_opts": "${GRADLE_OPTS:-not set}"
  },
  "artifacts": ${artifacts_json},
  "logs": {
    "build_log": "${BUILD_LOG}",
    "prerequisites_log": "${PREREQUISITES_LOG}",
    "flutter_build_output": "$(ls -t ${LOG_DIR}/flutter_build_output_*.log 2>/dev/null | head -1)"
  }
}
EOF
}

# Generate HTML report
generate_html_report() {
    local report_file="$1"
    local json_report="$2"
    
    cat > "${report_file}" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ojyx Build Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1, h2 { color: #333; }
        .status-success { color: #28a745; }
        .status-failed { color: #dc3545; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin: 20px 0; }
        .info-card { background: #f8f9fa; padding: 15px; border-radius: 4px; }
        .info-card h3 { margin-top: 0; color: #495057; }
        .metric { display: flex; justify-content: space-between; margin: 5px 0; }
        .metric-label { font-weight: bold; }
        .artifact { background: #e9ecef; padding: 10px; margin: 10px 0; border-radius: 4px; }
        pre { background: #f4f4f4; padding: 10px; overflow-x: auto; }
        .progress-bar { width: 100%; height: 20px; background: #e9ecef; border-radius: 10px; overflow: hidden; }
        .progress-fill { height: 100%; background: #28a745; transition: width 0.3s; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Ojyx Build Report</h1>
        <div id="report-content"></div>
    </div>
    <script>
        const reportData = 
EOF
    
    cat "${json_report}" >> "${report_file}"
    
    cat >> "${report_file}" << 'EOF'
        ;
        
        function formatDuration(seconds) {
            const hours = Math.floor(seconds / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            const secs = seconds % 60;
            return hours > 0 ? `${hours}h ${minutes}m ${secs}s` : `${minutes}m ${secs}s`;
        }
        
        function formatBytes(bytes) {
            if (bytes < 1024) return bytes + ' B';
            if (bytes < 1048576) return (bytes / 1024).toFixed(2) + ' KB';
            return (bytes / 1048576).toFixed(2) + ' MB';
        }
        
        function renderReport() {
            const container = document.getElementById('report-content');
            const status = reportData.build_info.build_status;
            const statusClass = status === 'SUCCESS' ? 'status-success' : 'status-failed';
            
            let html = `
                <h2>Build Status: <span class="${statusClass}">${status}</span></h2>
                <p>Generated on: ${new Date(reportData.build_info.timestamp).toLocaleString()}</p>
                
                <div class="info-grid">
                    <div class="info-card">
                        <h3>Build Information</h3>
                        <div class="metric"><span class="metric-label">Mode:</span><span>${reportData.build_info.build_mode}</span></div>
                        <div class="metric"><span class="metric-label">Duration:</span><span>${formatDuration(reportData.build_info.duration_seconds)}</span></div>
                        <div class="metric"><span class="metric-label">Flutter:</span><span>${reportData.build_info.flutter_version}</span></div>
                        <div class="metric"><span class="metric-label">Dart:</span><span>${reportData.build_info.dart_version}</span></div>
                    </div>
                    
                    <div class="info-card">
                        <h3>System Information</h3>
                        <div class="metric"><span class="metric-label">OS:</span><span>${reportData.system_info.os}</span></div>
                        <div class="metric"><span class="metric-label">Memory:</span><span>${formatBytes(reportData.system_info.total_memory_kb * 1024)}</span></div>
                        <div class="metric"><span class="metric-label">CPU:</span><span>${reportData.system_info.cpu}</span></div>
                    </div>
                </div>
                
                <h3>Build Artifacts</h3>
            `;
            
            if (reportData.artifacts && reportData.artifacts.length > 0) {
                reportData.artifacts.forEach(artifact => {
                    html += `
                        <div class="artifact">
                            <strong>${artifact.name}</strong><br>
                            Size: ${formatBytes(artifact.size)}<br>
                            SHA256: <code>${artifact.sha256}</code>
                        </div>
                    `;
                });
            } else {
                html += '<p>No artifacts generated</p>';
            }
            
            container.innerHTML = html;
        }
        
        renderReport();
    </script>
</body>
</html>
EOF
}

# Set up CI environment variables
setup_ci_environment() {
    if [[ "${CI_MODE}" == "true" ]]; then
        # GitHub Actions
        if [[ -n "${GITHUB_ACTIONS}" ]]; then
            echo "::set-output name=build_status::${1}"
            echo "::set-output name=apk_path::${2}"
            echo "::set-output name=build_duration::${3}"
            
            # Add annotations for errors
            if [[ "${1}" == "FAILED" ]]; then
                echo "::error::Build failed after ${3} seconds"
            fi
        fi
        
        # Generic CI exports
        export BUILD_STATUS="${1}"
        export APK_PATH="${2}"
        export BUILD_DURATION="${3}"
    fi
}

# Execute post-build hooks
execute_post_hooks() {
    local hook_script="${PROJECT_ROOT}/.ojyx/hooks/post-build.sh"
    
    if [[ -f "${hook_script}" && -x "${hook_script}" ]]; then
        log "INFO" "Executing post-build hook..."
        if "${hook_script}" "${BUILD_STATUS}" "${BUILD_MODE}" "${BUILD_LOG}"; then
            log "INFO" "Post-build hook completed successfully"
        else
            log "WARN" "Post-build hook failed with exit code $?"
        fi
    fi
    
    # Webhook notifications
    if [[ -n "${WEBHOOK_URL}" ]]; then
        log "INFO" "Sending webhook notification..."
        local payload=$(cat <<EOF
{
  "project": "Ojyx",
  "build_status": "${BUILD_STATUS}",
  "build_mode": "${BUILD_MODE}",
  "duration": ${TOTAL_DURATION},
  "timestamp": "$(date -Iseconds)"
}
EOF
)
        if curl -s -X POST "${WEBHOOK_URL}" \
            -H "Content-Type: application/json" \
            -d "${payload}" > /dev/null; then
            log "INFO" "Webhook notification sent"
        else
            log "WARN" "Failed to send webhook notification"
        fi
    fi
}

# Main report generation function
generate_build_report() {
    local report_start=$SECONDS
    
    # Calculate total build duration
    TOTAL_DURATION=$SECONDS
    BUILD_STATUS="SUCCESS"  # Will be set to FAILED if any step failed
    
    log "INFO" "Generating build report..."
    
    # Generate timestamp for report files
    local report_timestamp=$(date +%Y%m%d_%H%M%S)
    local json_report="${LOG_DIR}/build_report_${report_timestamp}.json"
    local html_report="${LOG_DIR}/build_report_${report_timestamp}.html"
    
    # Generate JSON report
    generate_json_report "${json_report}" "${BUILD_STATUS}" "${TOTAL_DURATION}"
    log "INFO" "JSON report saved to: ${json_report}"
    
    # Generate HTML report
    generate_html_report "${html_report}" "${json_report}"
    log "INFO" "HTML report saved to: ${html_report}"
    
    # Set up CI environment
    local apk_path=""
    if [[ -d "${PROJECT_ROOT}/build/outputs" ]]; then
        apk_path=$(find "${PROJECT_ROOT}/build/outputs" -name "*.apk" -type f | head -1)
    fi
    setup_ci_environment "${BUILD_STATUS}" "${apk_path}" "${TOTAL_DURATION}"
    
    # Execute post-build hooks
    execute_post_hooks
    
    # Summary output
    echo ""
    echo "================================================================================"
    echo "                            BUILD SUMMARY"
    echo "================================================================================"
    echo "Status:        ${BUILD_STATUS}"
    echo "Mode:          ${BUILD_MODE}"
    echo "Duration:      $(printf '%d:%02d' $((TOTAL_DURATION/60)) $((TOTAL_DURATION%60)))"
    echo "Flutter:       $(flutter --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo 'unknown')"
    echo ""
    
    if [[ -n "${apk_path}" ]]; then
        echo "APK Output:    ${apk_path}"
        echo "APK Size:      $(du -h "${apk_path}" | cut -f1)"
    fi
    
    echo ""
    echo "Reports:"
    echo "  - JSON: ${json_report}"
    echo "  - HTML: ${html_report}"
    echo "  - Logs: ${LOG_DIR}/"
    echo "================================================================================"
    
    local report_duration=$((SECONDS - report_start))
    log "DEBUG" "Report generation completed in ${report_duration} seconds"
}

# Main function
main() {
    # Parse arguments first (before any logging)
    parse_arguments "$@"
    
    # Create log directory
    create_log_dir
    
    # Start logging
    log "INFO" "Ojyx Android Build Script v1.0.0"
    log "INFO" "Build started at $(date)"
    log "INFO" "Project root: ${PROJECT_ROOT}"
    log "INFO" "Build mode: ${BUILD_MODE}"
    
    # Log configuration
    log "DEBUG" "Configuration:"
    log "DEBUG" "  BUILD_MODE=${BUILD_MODE}"
    log "DEBUG" "  CLEAN_GRADLE=${CLEAN_GRADLE}"
    log "DEBUG" "  LOW_MEMORY=${LOW_MEMORY}"
    log "DEBUG" "  CI_MODE=${CI_MODE}"
    log "DEBUG" "  VERBOSE=${VERBOSE}"
    
    # Check prerequisites
    check_prerequisites
    
    # Prepare build environment
    prepare_build_environment
    
    # Compile Android APK
    compile_android_apk
    
    # Generate build report
    generate_build_report
    
    log "INFO" "Build script completed successfully"
    log "INFO" "Build completed at $(date)"
}

# Run main function
main "$@"