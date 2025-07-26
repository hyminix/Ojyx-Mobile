#!/bin/bash
# CI Build Wrapper for GitHub Actions
# This wrapper simplifies the build_wsl_android.sh script usage in CI environments

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set up environment for CI
export CI_MODE=true

# Disable color output for cleaner logs
export TERM=dumb

# Parse build type from argument or environment
BUILD_TYPE="${1:-${BUILD_TYPE:-debug}}"

# Convert GitHub Actions inputs to script arguments
ARGS="--ci"

case "${BUILD_TYPE}" in
    debug)
        ARGS="${ARGS} --debug"
        ;;
    release)
        ARGS="${ARGS} --release"
        ;;
    profile)
        ARGS="${ARGS} --profile"
        ;;
    *)
        echo "::error::Invalid build type: ${BUILD_TYPE}"
        exit 1
        ;;
esac

# Add low memory flag if needed (for CI environments)
if [[ "${LOW_MEMORY}" == "true" ]]; then
    ARGS="${ARGS} --low-memory"
fi

# Add verbose flag if debug logging is enabled
if [[ "${RUNNER_DEBUG}" == "1" || "${VERBOSE}" == "true" ]]; then
    ARGS="${ARGS} --verbose"
fi

echo "::group::Build Environment Info"
echo "Build Type: ${BUILD_TYPE}"
echo "Flutter Version: $(flutter --version | head -1)"
echo "Java Version: $(java -version 2>&1 | head -1)"
echo "Arguments: ${ARGS}"
echo "::endgroup::"

# Run the main build script
echo "::group::Running Android Build"
"${SCRIPT_DIR}/build_wsl_android.sh" ${ARGS}
BUILD_EXIT_CODE=$?
echo "::endgroup::"

# Extract build information for GitHub Actions
if [[ ${BUILD_EXIT_CODE} -eq 0 ]]; then
    # Find the generated APK
    APK_PATH=$(find "${SCRIPT_DIR}/../build/app/outputs/flutter-apk" -name "*.apk" -type f | head -1)
    
    if [[ -n "${APK_PATH}" ]]; then
        APK_SIZE=$(ls -lh "${APK_PATH}" | awk '{print $5}')
        echo "::notice::Build successful! APK: $(basename "${APK_PATH}"), Size: ${APK_SIZE}"
        
        # Set outputs for GitHub Actions
        echo "apk_path=${APK_PATH}" >> $GITHUB_OUTPUT
        echo "apk_size=${APK_SIZE}" >> $GITHUB_OUTPUT
        echo "build_status=success" >> $GITHUB_OUTPUT
    else
        echo "::error::Build succeeded but APK not found"
        exit 1
    fi
else
    echo "::error::Build failed with exit code ${BUILD_EXIT_CODE}"
    echo "build_status=failed" >> $GITHUB_OUTPUT
    exit ${BUILD_EXIT_CODE}
fi