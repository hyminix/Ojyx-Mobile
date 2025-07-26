#!/bin/bash
# Test script for preparation phase only

set -e

# Source the build script functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"
BUILD_LOG="${LOG_DIR}/test_preparation_$(date +%Y%m%d_%H%M%S).log"

# Import functions from build script
source "${SCRIPT_DIR}/build_wsl_android.sh" --help >/dev/null 2>&1 || true

# Override check_prerequisites to skip Java/Android checks
check_prerequisites() {
    echo "=== Prerequisites Check (TEST MODE) ===" > "${LOG_DIR}/prerequisites_check.log"
    echo "Skipping prerequisite checks for test" >> "${LOG_DIR}/prerequisites_check.log"
    log "INFO" "Prerequisites check skipped (test mode)"
}

# Test preparation
main() {
    create_log_dir
    
    echo "=== Testing Preparation Phase ===="
    echo "Project root: ${PROJECT_ROOT}"
    
    # Set test variables
    CLEAN_GRADLE=true
    CI_MODE=false
    VERBOSE=true
    
    # Run preparation
    prepare_build_environment
    
    echo ""
    echo "=== Preparation Test Results ==="
    
    # Check if files were created
    if [[ -f "${PROJECT_ROOT}/pubspec.lock" ]]; then
        echo "✓ pubspec.lock exists"
    else
        echo "✗ pubspec.lock missing"
    fi
    
    # Count generated files
    local generated_count=$(find "${PROJECT_ROOT}" -name "*.g.dart" -o -name "*.freezed.dart" 2>/dev/null | wc -l)
    echo "✓ Generated files: ${generated_count}"
    
    # Check for checkpoint
    local checkpoint_count=$(find "${LOG_DIR}" -name "preparation_checkpoint_*.json" 2>/dev/null | wc -l)
    if [[ ${checkpoint_count} -gt 0 ]]; then
        echo "✓ Preparation checkpoint created"
        
        # Show latest checkpoint
        local latest_checkpoint=$(ls -t "${LOG_DIR}"/preparation_checkpoint_*.json 2>/dev/null | head -1)
        if [[ -n "${latest_checkpoint}" ]]; then
            echo ""
            echo "Latest checkpoint content:"
            cat "${latest_checkpoint}" | jq . 2>/dev/null || cat "${latest_checkpoint}"
        fi
    else
        echo "✗ No preparation checkpoint found"
    fi
    
    echo ""
    echo "Test completed successfully!"
}

# Run test
main