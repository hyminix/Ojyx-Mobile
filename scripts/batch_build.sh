#!/bin/bash
# Batch build script for Ojyx
# Builds multiple variants of the app in sequence

set -e

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_SCRIPT="${SCRIPT_DIR}/build_wsl_android.sh"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly BATCH_LOG="${PROJECT_ROOT}/logs/batch_build_$(date +%Y%m%d_%H%M%S).log"

# Colors for output
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Build configurations
declare -a BUILD_CONFIGS=(
    "debug|Development build"
    "profile|Performance testing build"
    "release|Production build"
)

# Batch configuration
PARALLEL_BUILDS=false
MAX_PARALLEL=2
DRY_RUN=false
SKIP_FAILED=false
NOTIFICATION_EMAIL=""
ARCHIVE_DIR=""

# Timing variables
BATCH_START=0
BUILD_TIMES=()

# Show usage
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Batch build script for Ojyx - builds multiple app variants

OPTIONS:
    -p, --parallel          Enable parallel builds (max 2 by default)
    -j, --jobs NUM          Set max parallel jobs (default: 2)
    -d, --dry-run          Show what would be built without building
    -s, --skip-failed      Continue batch even if a build fails
    -e, --email EMAIL      Send email notification on completion
    -a, --archive DIR      Archive APKs to specified directory
    -c, --config FILE      Use custom build configuration file
    -h, --help             Show this help message

EXAMPLES:
    # Build all variants sequentially
    $(basename "$0")
    
    # Build in parallel with 3 jobs
    $(basename "$0") --parallel --jobs 3
    
    # Dry run to see what would be built
    $(basename "$0") --dry-run
    
    # Archive builds and send notification
    $(basename "$0") --archive ./releases --email dev@example.com

EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--parallel)
                PARALLEL_BUILDS=true
                shift
                ;;
            -j|--jobs)
                MAX_PARALLEL="$2"
                shift 2
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -s|--skip-failed)
                SKIP_FAILED=true
                shift
                ;;
            -e|--email)
                NOTIFICATION_EMAIL="$2"
                shift 2
                ;;
            -a|--archive)
                ARCHIVE_DIR="$2"
                shift 2
                ;;
            -c|--config)
                load_config_file "$2"
                shift 2
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Load configuration from file
load_config_file() {
    local config_file="$1"
    
    if [[ ! -f "${config_file}" ]]; then
        echo -e "${RED}Error: Configuration file not found: ${config_file}${NC}"
        exit 1
    fi
    
    echo "Loading configuration from: ${config_file}"
    
    # Parse configuration file (expected format: MODE|DESCRIPTION|EXTRA_FLAGS)
    BUILD_CONFIGS=()
    while IFS='|' read -r mode desc flags; do
        [[ -z "$mode" || "$mode" =~ ^# ]] && continue
        BUILD_CONFIGS+=("${mode}|${desc}|${flags}")
    done < "${config_file}"
}

# Log message
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${BATCH_LOG}"
}

# Build single variant
build_variant() {
    local config="$1"
    local mode=$(echo "$config" | cut -d'|' -f1)
    local desc=$(echo "$config" | cut -d'|' -f2)
    local extra_flags=$(echo "$config" | cut -d'|' -f3)
    
    local start_time=$SECONDS
    
    echo -e "\n${BLUE}Building ${mode} variant: ${desc}${NC}"
    log_message "INFO" "Starting ${mode} build"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
        echo "DRY RUN: Would execute: ${BUILD_SCRIPT} --${mode} ${extra_flags}"
        return 0
    fi
    
    # Build command
    local cmd="${BUILD_SCRIPT} --${mode} --ci"
    [[ -n "${extra_flags}" ]] && cmd="${cmd} ${extra_flags}"
    
    # Execute build
    if ${cmd} >> "${BATCH_LOG}" 2>&1; then
        local duration=$((SECONDS - start_time))
        BUILD_TIMES+=("${mode}:${duration}")
        echo -e "${GREEN}✓ ${mode} build completed in ${duration}s${NC}"
        log_message "SUCCESS" "${mode} build completed in ${duration}s"
        return 0
    else
        local duration=$((SECONDS - start_time))
        echo -e "${RED}✗ ${mode} build failed after ${duration}s${NC}"
        log_message "ERROR" "${mode} build failed after ${duration}s"
        return 1
    fi
}

# Run builds in parallel
run_parallel_builds() {
    local pids=()
    local results=()
    
    echo -e "${YELLOW}Running builds in parallel (max ${MAX_PARALLEL} jobs)${NC}"
    
    for config in "${BUILD_CONFIGS[@]}"; do
        # Wait if we've reached max parallel jobs
        while [[ ${#pids[@]} -ge ${MAX_PARALLEL} ]]; do
            for i in "${!pids[@]}"; do
                if ! kill -0 "${pids[$i]}" 2>/dev/null; then
                    wait "${pids[$i]}"
                    results+=($?)
                    unset pids[$i]
                fi
            done
            pids=("${pids[@]}")  # Reindex array
            sleep 1
        done
        
        # Start new build
        build_variant "$config" &
        pids+=($!)
    done
    
    # Wait for remaining builds
    for pid in "${pids[@]}"; do
        wait "$pid"
        results+=($?)
    done
    
    # Check results
    local failed=0
    for result in "${results[@]}"; do
        [[ $result -ne 0 ]] && ((failed++))
    done
    
    return $failed
}

# Run builds sequentially
run_sequential_builds() {
    local failed=0
    
    echo -e "${YELLOW}Running builds sequentially${NC}"
    
    for config in "${BUILD_CONFIGS[@]}"; do
        if build_variant "$config"; then
            continue
        else
            ((failed++))
            if [[ "${SKIP_FAILED}" != "true" ]]; then
                echo -e "${RED}Stopping batch due to failed build${NC}"
                return $failed
            fi
        fi
    done
    
    return $failed
}

# Archive build artifacts
archive_builds() {
    if [[ -z "${ARCHIVE_DIR}" || "${DRY_RUN}" == "true" ]]; then
        return
    fi
    
    echo -e "\n${BLUE}Archiving build artifacts to: ${ARCHIVE_DIR}${NC}"
    mkdir -p "${ARCHIVE_DIR}"
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local archive_subdir="${ARCHIVE_DIR}/ojyx_batch_${timestamp}"
    mkdir -p "${archive_subdir}"
    
    # Find and copy APKs
    local apk_count=0
    while IFS= read -r apk; do
        local basename=$(basename "$apk")
        cp "$apk" "${archive_subdir}/${basename}"
        ((apk_count++))
        echo "  Archived: ${basename}"
    done < <(find "${PROJECT_ROOT}/build" -name "*.apk" -type f 2>/dev/null)
    
    # Copy build reports
    cp "${BATCH_LOG}" "${archive_subdir}/batch_build.log"
    
    # Copy individual build logs
    find "${PROJECT_ROOT}/logs" -name "build_*.log" -newer "${BATCH_LOG}" -exec cp {} "${archive_subdir}/" \;
    
    echo -e "${GREEN}Archived ${apk_count} APKs to ${archive_subdir}${NC}"
    log_message "INFO" "Archived ${apk_count} APKs to ${archive_subdir}"
}

# Send email notification
send_notification() {
    if [[ -z "${NOTIFICATION_EMAIL}" || "${DRY_RUN}" == "true" ]]; then
        return
    fi
    
    local subject="Ojyx Batch Build Report - $(date +%Y-%m-%d)"
    local body="Batch build completed at $(date)\n\n"
    body+="Total builds: ${#BUILD_CONFIGS[@]}\n"
    body+="Failed builds: $1\n\n"
    body+="Build times:\n"
    
    for timing in "${BUILD_TIMES[@]}"; do
        local mode=$(echo "$timing" | cut -d':' -f1)
        local duration=$(echo "$timing" | cut -d':' -f2)
        body+="  ${mode}: ${duration}s\n"
    done
    
    # Try to send email using mail command
    if command -v mail >/dev/null 2>&1; then
        echo -e "$body" | mail -s "$subject" "${NOTIFICATION_EMAIL}"
        echo "Notification sent to: ${NOTIFICATION_EMAIL}"
    else
        echo "Mail command not available, skipping notification"
    fi
}

# Generate batch report
generate_batch_report() {
    local total_duration=$((SECONDS - BATCH_START))
    
    echo -e "\n${BLUE}================================================================================${NC}"
    echo -e "${BLUE}                            BATCH BUILD REPORT${NC}"
    echo -e "${BLUE}================================================================================${NC}"
    echo "Start time:     $(date -d @$BATCH_START '+%Y-%m-%d %H:%M:%S')"
    echo "End time:       $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Total duration: $(printf '%d:%02d' $((total_duration/60)) $((total_duration%60)))"
    echo "Parallel mode:  ${PARALLEL_BUILDS}"
    echo ""
    echo "Build Summary:"
    echo "  Total builds:   ${#BUILD_CONFIGS[@]}"
    echo "  Successful:     $((${#BUILD_CONFIGS[@]} - $1))"
    echo "  Failed:         $1"
    echo ""
    
    if [[ ${#BUILD_TIMES[@]} -gt 0 ]]; then
        echo "Build Times:"
        for timing in "${BUILD_TIMES[@]}"; do
            local mode=$(echo "$timing" | cut -d':' -f1)
            local duration=$(echo "$timing" | cut -d':' -f2)
            printf "  %-10s %3ds\n" "${mode}:" "$duration"
        done
    fi
    
    echo -e "${BLUE}================================================================================${NC}"
}

# Main function
main() {
    BATCH_START=$SECONDS
    
    # Create log directory
    mkdir -p "$(dirname "${BATCH_LOG}")"
    
    echo -e "${BLUE}Ojyx Batch Build Script${NC}"
    echo "Batch started at $(date)"
    log_message "INFO" "Batch build started"
    
    # Parse arguments
    parse_arguments "$@"
    
    # Validate build script exists
    if [[ ! -f "${BUILD_SCRIPT}" ]]; then
        echo -e "${RED}Error: Build script not found: ${BUILD_SCRIPT}${NC}"
        exit 1
    fi
    
    # Show configuration
    echo ""
    echo "Configuration:"
    echo "  Builds to run: ${#BUILD_CONFIGS[@]}"
    echo "  Parallel mode: ${PARALLEL_BUILDS}"
    [[ "${PARALLEL_BUILDS}" == "true" ]] && echo "  Max parallel: ${MAX_PARALLEL}"
    [[ "${DRY_RUN}" == "true" ]] && echo "  Mode: DRY RUN"
    [[ -n "${ARCHIVE_DIR}" ]] && echo "  Archive to: ${ARCHIVE_DIR}"
    [[ -n "${NOTIFICATION_EMAIL}" ]] && echo "  Notify: ${NOTIFICATION_EMAIL}"
    echo ""
    
    # Run builds
    local failed_builds=0
    if [[ "${PARALLEL_BUILDS}" == "true" ]]; then
        run_parallel_builds
        failed_builds=$?
    else
        run_sequential_builds
        failed_builds=$?
    fi
    
    # Archive builds
    archive_builds
    
    # Generate report
    generate_batch_report $failed_builds
    
    # Send notification
    send_notification $failed_builds
    
    # Exit with appropriate code
    if [[ $failed_builds -eq 0 ]]; then
        log_message "SUCCESS" "Batch build completed successfully"
        exit 0
    else
        log_message "ERROR" "Batch build completed with ${failed_builds} failures"
        exit 1
    fi
}

# Run main
main "$@"