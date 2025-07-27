#!/bin/bash

# Quick restart emulator (useful for testing clean state)

set -e

ADB="${ANDROID_HOME}/platform-tools/adb"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🔄 Quick Restarting Emulator...${NC}"

# Check if emulator is running
if ! "$ADB" devices | grep -q "emulator-"; then
    echo -e "${RED}❌ No emulator is running${NC}"
    echo "Starting emulator..."
    ./start-emulator.sh
    exit 0
fi

# Get emulator serial
EMULATOR_SERIAL=$("$ADB" devices | grep emulator | head -1 | awk '{print $1}')

echo "Rebooting $EMULATOR_SERIAL..."
"$ADB" -s "$EMULATOR_SERIAL" reboot

echo -e "${YELLOW}Waiting for device to come back online...${NC}"
"$ADB" wait-for-device

# Wait for boot completion
while [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" != "1" ]; do
    sleep 1
    echo -n "."
done
echo ""

# Re-apply performance settings
echo -e "${GREEN}Re-applying performance settings...${NC}"
"$ADB" shell settings put global window_animation_scale 0.0
"$ADB" shell settings put global transition_animation_scale 0.0
"$ADB" shell settings put global animator_duration_scale 0.0

# Unlock screen
"$ADB" shell input keyevent 82

echo -e "${GREEN}✅ Emulator restarted successfully!${NC}"