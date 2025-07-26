#!/bin/bash
# Test script for build_wsl_android.sh
# Tests various aspects of the build script

set -e

# Colors for output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Script paths
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_SCRIPT="${SCRIPT_DIR}/build_wsl_android.sh"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly TEST_LOG="${PROJECT_ROOT}/logs/test_build_script_$(date +%Y%m%d_%H%M%S).log"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test result function
test_result() {
    local test_name="$1"
    local result="$2"
    local message="${3:-}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$result" == "PASS" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} ${test_name}" | tee -a "${TEST_LOG}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} ${test_name}" | tee -a "${TEST_LOG}"
        if [[ -n "$message" ]]; then
            echo "  Error: $message" | tee -a "${TEST_LOG}"
        fi
    fi
}

# Test 1: Script exists and is executable
test_script_exists() {
    if [[ -f "${BUILD_SCRIPT}" && -x "${BUILD_SCRIPT}" ]]; then
        test_result "Script exists and is executable" "PASS"
    else
        test_result "Script exists and is executable" "FAIL" "Script not found or not executable"
    fi
}

# Test 2: Syntax validation
test_syntax() {
    if bash -n "${BUILD_SCRIPT}" 2>/dev/null; then
        test_result "Script syntax is valid" "PASS"
    else
        test_result "Script syntax is valid" "FAIL" "Syntax errors detected"
    fi
}

# Test 3: Help option
test_help_option() {
    if "${BUILD_SCRIPT}" --help &>/dev/null; then
        test_result "Help option works" "PASS"
    else
        test_result "Help option works" "FAIL" "Help option failed"
    fi
}

# Test 4: Unknown option handling
test_unknown_option() {
    if ! "${BUILD_SCRIPT}" --unknown-option &>/dev/null; then
        test_result "Unknown option handling" "PASS"
    else
        test_result "Unknown option handling" "FAIL" "Unknown option not rejected"
    fi
}

# Test 5: Log directory creation
test_log_directory() {
    # Remove logs directory if exists
    local log_dir="${PROJECT_ROOT}/logs"
    local temp_backup=""
    
    if [[ -d "${log_dir}" ]]; then
        temp_backup="${log_dir}_backup_$(date +%s)"
        mv "${log_dir}" "${temp_backup}"
    fi
    
    # Run script to create log directory
    "${BUILD_SCRIPT}" --help &>/dev/null
    
    if [[ -d "${log_dir}" ]]; then
        test_result "Log directory creation" "PASS"
        # Restore backup
        if [[ -n "${temp_backup}" && -d "${temp_backup}" ]]; then
            rm -rf "${log_dir}"
            mv "${temp_backup}" "${log_dir}"
        fi
    else
        test_result "Log directory creation" "FAIL" "Log directory not created"
    fi
}

# Test 6: Signal handling
test_signal_handling() {
    # Start the script in background
    "${BUILD_SCRIPT}" --verbose &>/dev/null &
    local pid=$!
    
    # Give it a moment to start
    sleep 0.5
    
    # Send interrupt signal
    if kill -INT $pid 2>/dev/null; then
        wait $pid 2>/dev/null || true
        test_result "Signal handling (SIGINT)" "PASS"
    else
        test_result "Signal handling (SIGINT)" "FAIL" "Process not found"
    fi
}

# Test 7: Command line argument parsing
test_argument_parsing() {
    local output
    
    # Test release mode
    output=$("${BUILD_SCRIPT}" --release --help 2>&1 | grep -c "release" || true)
    if [[ $output -gt 0 ]]; then
        test_result "Argument parsing (--release)" "PASS"
    else
        test_result "Argument parsing (--release)" "FAIL"
    fi
    
    # Test multiple arguments
    if "${BUILD_SCRIPT}" --release --ci --verbose --help &>/dev/null; then
        test_result "Multiple arguments parsing" "PASS"
    else
        test_result "Multiple arguments parsing" "FAIL"
    fi
}

# Test 8: Logging functionality
test_logging() {
    local log_dir="${PROJECT_ROOT}/logs"
    local log_count_before=$(find "${log_dir}" -name "build_*.log" 2>/dev/null | wc -l)
    
    # Run script
    "${BUILD_SCRIPT}" --help &>/dev/null
    
    local log_count_after=$(find "${log_dir}" -name "build_*.log" 2>/dev/null | wc -l)
    
    if [[ $log_count_after -gt $log_count_before ]]; then
        test_result "Log file creation" "PASS"
    else
        test_result "Log file creation" "FAIL" "No new log file created"
    fi
}

# Main test runner
main() {
    echo "=== Testing Ojyx Build Script ===" | tee "${TEST_LOG}"
    echo "Test started at $(date)" | tee -a "${TEST_LOG}"
    echo "" | tee -a "${TEST_LOG}"
    
    # Create logs directory for test
    mkdir -p "$(dirname "${TEST_LOG}")"
    
    # Run tests
    test_script_exists
    test_syntax
    test_help_option
    test_unknown_option
    test_log_directory
    test_signal_handling
    test_argument_parsing
    test_logging
    
    # Summary
    echo "" | tee -a "${TEST_LOG}"
    echo "=== Test Summary ===" | tee -a "${TEST_LOG}"
    echo "Tests run: ${TESTS_RUN}" | tee -a "${TEST_LOG}"
    echo -e "Tests passed: ${GREEN}${TESTS_PASSED}${NC}" | tee -a "${TEST_LOG}"
    echo -e "Tests failed: ${RED}${TESTS_FAILED}${NC}" | tee -a "${TEST_LOG}"
    
    if [[ ${TESTS_FAILED} -eq 0 ]]; then
        echo -e "\n${GREEN}All tests passed!${NC}" | tee -a "${TEST_LOG}"
        exit 0
    else
        echo -e "\n${RED}Some tests failed!${NC}" | tee -a "${TEST_LOG}"
        exit 1
    fi
}

# Run main
main