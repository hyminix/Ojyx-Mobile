#!/bin/bash

# TDD Compliance Check Script
# This script runs as part of pre-commit hook to ensure test quality

echo "🔍 Running TDD Compliance Check..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if dart is available
if ! command -v dart &> /dev/null; then
    echo -e "${RED}❌ Dart is not installed or not in PATH${NC}"
    exit 1
fi

# Run the compliance validator
REPORT_PATH=".taskmaster/reports/tdd-compliance-report.json"
mkdir -p .taskmaster/reports

# Execute validation
dart test/validate_tdd_compliance.dart . "$REPORT_PATH"
VALIDATION_EXIT_CODE=$?

# Check validation result
if [ $VALIDATION_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ TDD compliance check passed!${NC}"
    exit 0
elif [ $VALIDATION_EXIT_CODE -eq 1 ]; then
    echo -e "${RED}❌ TDD compliance check failed!${NC}"
    echo ""
    echo "Common issues to fix:"
    echo "  - Test names must follow 'should_[behavior]_when_[condition]' pattern"
    echo "  - No commented or skipped tests allowed"
    echo "  - All tests must have assertions"
    echo "  - Consider adding 'reason' parameter to assertions"
    echo ""
    echo "Run 'dart test/validate_tdd_compliance.dart' for detailed report"
    exit 1
else
    echo -e "${RED}❌ TDD compliance check encountered an error${NC}"
    exit 2
fi