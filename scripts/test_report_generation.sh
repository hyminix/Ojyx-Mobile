#!/bin/bash
# Test script for report generation functionality

set -e

# Source the build script functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${PROJECT_ROOT}/logs"

# Import functions from build script (suppress output)
source "${SCRIPT_DIR}/build_wsl_android.sh" --help >/dev/null 2>&1 || true

# Override functions to skip actual building
check_prerequisites() {
    echo "=== Prerequisites Check (TEST MODE) ===" > "${LOG_DIR}/prerequisites_check.log"
    echo "Skipping prerequisite checks for test" >> "${LOG_DIR}/prerequisites_check.log"
    log "INFO" "Prerequisites check skipped (test mode)"
}

prepare_build_environment() {
    log "INFO" "Preparation skipped (test mode)"
    # Create a fake checkpoint
    local checkpoint_file="${LOG_DIR}/preparation_checkpoint_$(date +%Y%m%d_%H%M%S).json"
    cat > "${checkpoint_file}" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "status": "completed",
  "flutter_clean": true,
  "dependencies": true,
  "code_generation": true,
  "env_validation": true
}
EOF
}

compile_android_apk() {
    log "INFO" "Compilation skipped (test mode)"
    # Create fake artifacts
    mkdir -p "${PROJECT_ROOT}/build/outputs/apk/release"
    echo "Fake APK content" > "${PROJECT_ROOT}/build/outputs/apk/release/app-release.apk"
    
    # Set global variables for report
    BUILD_STATUS="SUCCESS"
    TOTAL_DURATION=120  # Fake 2 minute build
}

# Test report generation
main() {
    create_log_dir
    
    echo "=== Testing Report Generation ==="
    echo "Project root: ${PROJECT_ROOT}"
    
    # Set test variables
    BUILD_MODE="release"
    CI_MODE=false
    VERBOSE=true
    WEBHOOK_URL=""
    
    # Start timer
    SECONDS=0
    
    # Generate report
    generate_build_report
    
    echo ""
    echo "=== Report Generation Test Results ==="
    
    # Check if JSON report was created
    local json_reports=$(find "${LOG_DIR}" -name "build_report_*.json" -newer "${SCRIPT_DIR}/test_report_generation.sh" 2>/dev/null | wc -l)
    if [[ ${json_reports} -gt 0 ]]; then
        echo "✓ JSON report created"
        local latest_json=$(ls -t "${LOG_DIR}"/build_report_*.json 2>/dev/null | head -1)
        echo "  Latest: ${latest_json}"
        
        # Validate JSON
        if jq . "${latest_json}" >/dev/null 2>&1; then
            echo "✓ JSON is valid"
            
            # Show key fields
            echo ""
            echo "Report content preview:"
            jq '{
                build_status: .build_info.build_status,
                build_mode: .build_info.build_mode,
                duration: .build_info.duration_seconds,
                flutter_version: .build_info.flutter_version,
                artifacts_count: (.artifacts | length)
            }' "${latest_json}"
        else
            echo "✗ JSON is invalid"
        fi
    else
        echo "✗ JSON report not created"
    fi
    
    # Check if HTML report was created
    local html_reports=$(find "${LOG_DIR}" -name "build_report_*.html" -newer "${SCRIPT_DIR}/test_report_generation.sh" 2>/dev/null | wc -l)
    if [[ ${html_reports} -gt 0 ]]; then
        echo ""
        echo "✓ HTML report created"
        local latest_html=$(ls -t "${LOG_DIR}"/build_report_*.html 2>/dev/null | head -1)
        echo "  Latest: ${latest_html}"
        
        # Check HTML content
        if grep -q "Ojyx Build Report" "${latest_html}"; then
            echo "✓ HTML contains expected content"
        else
            echo "✗ HTML missing expected content"
        fi
    else
        echo "✗ HTML report not created"
    fi
    
    # Cleanup fake artifacts
    rm -rf "${PROJECT_ROOT}/build/outputs/apk"
    
    echo ""
    echo "Test completed successfully!"
}

# Run test
main