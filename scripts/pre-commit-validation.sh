#!/bin/bash
# Pre-commit validation script for Ojyx project
# Checks for common patterns that should be avoided

echo "🔍 Running Ojyx pre-commit validation..."

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track if any issues are found
ISSUES_FOUND=0

# Function to check for pattern and report
check_pattern() {
    local pattern="$1"
    local message="$2"
    local file_pattern="$3"
    
    if git diff --cached --name-only | grep -E "$file_pattern" | xargs -I {} git diff --cached {} | grep -E "$pattern" > /dev/null 2>&1; then
        echo -e "${RED}❌ Found problematic pattern: $message${NC}"
        ISSUES_FOUND=1
        return 1
    fi
    return 0
}

# Check for auth.uid() without SELECT in SQL files
echo "Checking RLS policies..."
if git diff --cached --name-only | grep -E "\.sql$|supabase/migrations/" | xargs -I {} git diff --cached {} | grep -E "auth\.uid\(\)(?!\s*\))" > /dev/null 2>&1; then
    echo -e "${RED}❌ Found auth.uid() without SELECT wrapper in SQL files${NC}"
    echo -e "${YELLOW}   Use (SELECT auth.uid()) instead for better performance${NC}"
    ISSUES_FOUND=1
fi

# Check for ref.read without mounted check in Dart files
echo "Checking Riverpod lifecycle safety..."
if git diff --cached --name-only | grep "\.dart$" | xargs -I {} git diff --cached {} | grep -B5 "ref\.read" | grep -v "mounted" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Found ref.read() that might not check mounted state${NC}"
    echo -e "${YELLOW}   Consider adding 'if (!mounted) return;' before ref.read()${NC}"
fi

# Check for Supabase operations without auth check
echo "Checking Supabase auth verification..."
if git diff --cached --name-only | grep "\.dart$" | xargs -I {} git diff --cached {} | grep -E "supabase\.from\(.*\)\.(insert|update|delete)" | grep -B10 -v "currentUser" > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Found Supabase mutation that might not check auth${NC}"
    echo -e "${YELLOW}   Consider verifying currentUser before mutations${NC}"
fi

# Check for AppInitializer after runApp
echo "Checking main.dart initialization order..."
if git diff --cached --name-only | grep "main\.dart$" | xargs -I {} git diff --cached {} | grep -A5 "runApp" | grep "AppInitializer\.initialize" > /dev/null 2>&1; then
    echo -e "${RED}❌ Found AppInitializer.initialize() after runApp()${NC}"
    echo -e "${YELLOW}   This causes Zone mismatch errors. Initialize before runApp()${NC}"
    ISSUES_FOUND=1
fi

# Run flutter analyze (non-blocking, just warning)
echo "Running flutter analyze..."
if ! flutter analyze --no-fatal-warnings > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Flutter analyze found some issues (non-blocking)${NC}"
    echo -e "${YELLOW}   Run 'flutter analyze' to see details${NC}"
fi

# Summary
echo ""
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All pre-commit checks passed!${NC}"
else
    echo -e "${RED}❌ Pre-commit validation failed!${NC}"
    echo -e "${YELLOW}Please fix the issues above before committing.${NC}"
    echo -e "${YELLOW}Use --no-verify to bypass (not recommended).${NC}"
    exit 1
fi