#!/bin/bash

# Ojyx Quick Run Script
# Loads environment variables and runs the app

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🚀 Ojyx Quick Run${NC}"

# Navigate to project root
cd "$(dirname "$0")/.."

# Load environment variables
if [ -f .env ]; then
    echo -e "${BLUE}Loading environment variables from .env...${NC}"
    # Export variables from .env file
    export $(grep -v '^#' .env | xargs -0)
else
    echo -e "${YELLOW}⚠️  No .env file found${NC}"
    echo "Creating .env from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${RED}Please edit .env with your Supabase credentials${NC}"
        exit 1
    else
        echo -e "${RED}❌ No .env.example file found${NC}"
        exit 1
    fi
fi

# Verify required variables
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ Missing required environment variables${NC}"
    echo "Please ensure SUPABASE_URL and SUPABASE_ANON_KEY are set in .env"
    exit 1
fi

# Check if emulator is running
if ! adb devices | grep -q "emulator-\|device$"; then
    echo -e "${YELLOW}No device detected. Starting emulator...${NC}"
    if [ -f scripts/emulator/start-emulator.sh ]; then
        ./scripts/emulator/start-emulator.sh &
        echo "Waiting for emulator to be ready..."
        adb wait-for-device
        sleep 5
    else
        echo -e "${RED}❌ No emulator script found and no device connected${NC}"
        echo "Please connect a device or start an emulator"
        exit 1
    fi
fi

# Run Flutter with environment variables
echo -e "${GREEN}Starting Ojyx app...${NC}"
echo "Device: $(adb devices | grep -E 'emulator-|device$' | head -1)"
echo ""

flutter run \
    --dart-define=SUPABASE_URL="$SUPABASE_URL" \
    --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
    --dart-define=DEBUG_MODE="${DEBUG_MODE:-true}" \
    --dart-define=SENTRY_DSN="${SENTRY_DSN:-}" \
    --dart-define=SENTRY_ENABLED="${SENTRY_ENABLED:-false}"