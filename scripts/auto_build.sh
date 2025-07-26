#!/bin/bash
# Automated build wrapper for Ojyx
# Provides scheduling, monitoring, and automation features

set -e

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BUILD_SCRIPT="${SCRIPT_DIR}/build_wsl_android.sh"
readonly BATCH_SCRIPT="${SCRIPT_DIR}/batch_build.sh"
readonly PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly AUTO_LOG="${PROJECT_ROOT}/logs/auto_build_$(date +%Y%m%d_%H%M%S).log"
readonly PID_FILE="${PROJECT_ROOT}/.ojyx/auto_build.pid"

# Colors
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Automation modes
MODE="single"  # single, batch, watch, schedule
BUILD_TYPE="release"
WATCH_PATHS=("lib" "test" "pubspec.yaml")
SCHEDULE_TIME=""
WEBHOOK_URL=""
MAX_RETRIES=3
RETRY_DELAY=60

# Show usage
show_usage() {
    cat << EOF
Usage: $(basename "$0") [MODE] [OPTIONS]

Automated build wrapper for Ojyx

MODES:
    single              Run a single build (default)
    batch               Run batch builds for all variants
    watch               Watch for file changes and rebuild
    schedule            Schedule builds at specific times
    daemon              Run as background daemon

OPTIONS:
    -t, --type TYPE     Build type: debug, profile, release (default: release)
    -w, --watch PATHS   Paths to watch (comma-separated)
    -s, --schedule TIME Schedule format: HH:MM or cron expression
    -r, --retries NUM   Max retry attempts on failure (default: 3)
    -d, --delay SECS    Delay between retries (default: 60)
    -n, --notify URL    Webhook URL for notifications
    -p, --pid FILE      PID file location for daemon mode
    -h, --help          Show this help message

EXAMPLES:
    # Watch mode - rebuild on file changes
    $(basename "$0") watch --type debug
    
    # Schedule daily release build at 2 AM
    $(basename "$0") schedule --schedule "02:00" --type release
    
    # Run as daemon with notifications
    $(basename "$0") daemon --notify https://hooks.slack.com/...
    
    # Batch build with retries
    $(basename "$0") batch --retries 5 --delay 120

EOF
}

# Parse arguments
parse_arguments() {
    # First argument is mode if not a flag
    if [[ $# -gt 0 && ! "$1" =~ ^- ]]; then
        MODE="$1"
        shift
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                BUILD_TYPE="$2"
                shift 2
                ;;
            -w|--watch)
                IFS=',' read -ra WATCH_PATHS <<< "$2"
                shift 2
                ;;
            -s|--schedule)
                SCHEDULE_TIME="$2"
                shift 2
                ;;
            -r|--retries)
                MAX_RETRIES="$2"
                shift 2
                ;;
            -d|--delay)
                RETRY_DELAY="$2"
                shift 2
                ;;
            -n|--notify)
                WEBHOOK_URL="$2"
                shift 2
                ;;
            -p|--pid)
                PID_FILE="$2"
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

# Log message
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${AUTO_LOG}"
}

# Send notification
send_notification() {
    local status="$1"
    local message="$2"
    local details="${3:-}"
    
    if [[ -z "${WEBHOOK_URL}" ]]; then
        return
    fi
    
    local color="#36a64f"  # Green
    [[ "$status" == "error" ]] && color="#ff0000"  # Red
    [[ "$status" == "warning" ]] && color="#ff9900"  # Orange
    
    local payload=$(cat <<EOF
{
  "attachments": [{
    "color": "${color}",
    "title": "Ojyx Build ${status^}",
    "text": "${message}",
    "fields": [
      {"title": "Project", "value": "Ojyx", "short": true},
      {"title": "Mode", "value": "${MODE}", "short": true},
      {"title": "Build Type", "value": "${BUILD_TYPE}", "short": true},
      {"title": "Time", "value": "$(date '+%Y-%m-%d %H:%M:%S')", "short": true}
    ],
    "footer": "Auto Build System",
    "ts": $(date +%s)
  }]
}
EOF
)
    
    curl -s -X POST "${WEBHOOK_URL}" \
        -H "Content-Type: application/json" \
        -d "${payload}" > /dev/null 2>&1 || true
}

# Run build with retries
run_build_with_retry() {
    local attempt=1
    local success=false
    
    while [[ $attempt -le $MAX_RETRIES ]]; do
        log_message "INFO" "Build attempt ${attempt}/${MAX_RETRIES}"
        
        if "${BUILD_SCRIPT}" "--${BUILD_TYPE}" --ci >> "${AUTO_LOG}" 2>&1; then
            success=true
            log_message "SUCCESS" "Build completed successfully"
            send_notification "success" "Build completed successfully" "Attempt ${attempt}/${MAX_RETRIES}"
            break
        else
            log_message "ERROR" "Build failed on attempt ${attempt}"
            
            if [[ $attempt -lt $MAX_RETRIES ]]; then
                log_message "INFO" "Retrying in ${RETRY_DELAY} seconds..."
                sleep "${RETRY_DELAY}"
            fi
        fi
        
        ((attempt++))
    done
    
    if [[ "$success" == "false" ]]; then
        log_message "ERROR" "Build failed after ${MAX_RETRIES} attempts"
        send_notification "error" "Build failed after ${MAX_RETRIES} attempts"
        return 1
    fi
    
    return 0
}

# Watch mode - rebuild on file changes
watch_mode() {
    echo -e "${BLUE}Starting watch mode${NC}"
    echo "Watching paths: ${WATCH_PATHS[*]}"
    echo "Build type: ${BUILD_TYPE}"
    echo "Press Ctrl+C to stop"
    
    log_message "INFO" "Watch mode started"
    send_notification "info" "Watch mode started" "Monitoring: ${WATCH_PATHS[*]}"
    
    # Check if inotifywait is available
    if ! command -v inotifywait >/dev/null 2>&1; then
        echo -e "${YELLOW}Warning: inotifywait not found. Using polling mode.${NC}"
        watch_mode_polling
        return
    fi
    
    # Use inotifywait for efficient file monitoring
    while true; do
        # Wait for file changes
        inotifywait -r -e modify,create,delete,move "${WATCH_PATHS[@]}" 2>/dev/null
        
        echo -e "\n${YELLOW}Changes detected, rebuilding...${NC}"
        log_message "INFO" "File changes detected"
        
        # Small delay to let file operations complete
        sleep 2
        
        # Run build
        run_build_with_retry
    done
}

# Polling-based watch mode (fallback)
watch_mode_polling() {
    local last_mod_time=""
    
    while true; do
        # Get latest modification time
        local current_mod_time=$(find "${WATCH_PATHS[@]}" -type f -name "*.dart" -o -name "*.yaml" 2>/dev/null | xargs stat -c %Y 2>/dev/null | sort -n | tail -1)
        
        if [[ -n "$current_mod_time" && "$current_mod_time" != "$last_mod_time" ]]; then
            if [[ -n "$last_mod_time" ]]; then
                echo -e "\n${YELLOW}Changes detected, rebuilding...${NC}"
                log_message "INFO" "File changes detected (polling)"
                run_build_with_retry
            fi
            last_mod_time="$current_mod_time"
        fi
        
        sleep 5
    done
}

# Schedule mode - run builds at specific times
schedule_mode() {
    echo -e "${BLUE}Starting schedule mode${NC}"
    echo "Schedule: ${SCHEDULE_TIME}"
    echo "Build type: ${BUILD_TYPE}"
    echo "Press Ctrl+C to stop"
    
    log_message "INFO" "Schedule mode started: ${SCHEDULE_TIME}"
    send_notification "info" "Schedule mode started" "Schedule: ${SCHEDULE_TIME}"
    
    # Parse schedule time
    if [[ "${SCHEDULE_TIME}" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        # Simple HH:MM format
        while true; do
            local current_time=$(date +%H:%M)
            if [[ "$current_time" == "${SCHEDULE_TIME}" ]]; then
                echo -e "\n${GREEN}Scheduled build time reached${NC}"
                log_message "INFO" "Running scheduled build"
                run_build_with_retry
                
                # Wait until next minute to avoid duplicate builds
                sleep 60
            fi
            sleep 30
        done
    else
        echo -e "${RED}Error: Invalid schedule format. Use HH:MM${NC}"
        exit 1
    fi
}

# Daemon mode - run in background
daemon_mode() {
    # Check if already running
    if [[ -f "${PID_FILE}" ]]; then
        local old_pid=$(cat "${PID_FILE}")
        if kill -0 "$old_pid" 2>/dev/null; then
            echo -e "${RED}Error: Daemon already running with PID ${old_pid}${NC}"
            exit 1
        fi
    fi
    
    # Create PID directory
    mkdir -p "$(dirname "${PID_FILE}")"
    
    # Fork to background
    {
        echo $$ > "${PID_FILE}"
        trap 'rm -f "${PID_FILE}"; exit' EXIT INT TERM
        
        log_message "INFO" "Daemon started with PID $$"
        send_notification "info" "Build daemon started" "PID: $$"
        
        # Run watch mode in background
        watch_mode
    } &
    
    local daemon_pid=$!
    echo $daemon_pid > "${PID_FILE}"
    
    echo -e "${GREEN}Daemon started with PID ${daemon_pid}${NC}"
    echo "PID file: ${PID_FILE}"
    echo "Logs: ${AUTO_LOG}"
}

# Stop daemon
stop_daemon() {
    if [[ ! -f "${PID_FILE}" ]]; then
        echo "No daemon PID file found"
        return
    fi
    
    local pid=$(cat "${PID_FILE}")
    if kill -0 "$pid" 2>/dev/null; then
        echo "Stopping daemon (PID ${pid})..."
        kill "$pid"
        rm -f "${PID_FILE}"
        echo "Daemon stopped"
    else
        echo "Daemon not running (stale PID file)"
        rm -f "${PID_FILE}"
    fi
}

# Main function
main() {
    # Create log directory
    mkdir -p "$(dirname "${AUTO_LOG}")"
    
    echo -e "${BLUE}Ojyx Automated Build System${NC}"
    log_message "INFO" "Auto build started - Mode: ${MODE}"
    
    # Parse arguments
    parse_arguments "$@"
    
    # Validate scripts exist
    if [[ ! -f "${BUILD_SCRIPT}" ]]; then
        echo -e "${RED}Error: Build script not found: ${BUILD_SCRIPT}${NC}"
        exit 1
    fi
    
    # Handle stop command
    if [[ "${MODE}" == "stop" ]]; then
        stop_daemon
        exit 0
    fi
    
    # Execute mode
    case "${MODE}" in
        single)
            echo "Running single build (${BUILD_TYPE})"
            run_build_with_retry
            ;;
        batch)
            echo "Running batch builds"
            "${BATCH_SCRIPT}" >> "${AUTO_LOG}" 2>&1
            ;;
        watch)
            watch_mode
            ;;
        schedule)
            schedule_mode
            ;;
        daemon)
            daemon_mode
            ;;
        *)
            echo -e "${RED}Error: Unknown mode: ${MODE}${NC}"
            show_usage
            exit 1
            ;;
    esac
}

# Signal handlers
trap 'log_message "INFO" "Received interrupt signal"; exit 0' INT TERM

# Run main
main "$@"