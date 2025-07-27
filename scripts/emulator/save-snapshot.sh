#!/bin/bash

# Save emulator snapshot for fast startup

set -e

ADB="${ANDROID_HOME}/platform-tools/adb"
EMULATOR="${ANDROID_HOME}/emulator/emulator"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📸 Saving Emulator Snapshot${NC}"

# Check if emulator is running
if ! "$ADB" devices | grep -q "emulator-"; then
    echo -e "${RED}❌ No emulator is running${NC}"
    echo "Please start the emulator first with './start-emulator.sh'"
    exit 1
fi

# Get snapshot name
if [ -z "$1" ]; then
    echo "Enter snapshot name (e.g., 'ojyx_clean', 'ojyx_logged_in'):"
    read -r SNAPSHOT_NAME
else
    SNAPSHOT_NAME="$1"
fi

if [ -z "$SNAPSHOT_NAME" ]; then
    echo -e "${RED}❌ Snapshot name cannot be empty${NC}"
    exit 1
fi

echo -e "${YELLOW}Saving snapshot: $SNAPSHOT_NAME${NC}"

# Save snapshot via telnet
# Get emulator console port
CONSOLE_PORT=$(adb devices | grep emulator | head -1 | cut -d'-' -f2 | cut -d' ' -f1)

if [ -z "$CONSOLE_PORT" ]; then
    echo -e "${RED}❌ Could not determine emulator console port${NC}"
    exit 1
fi

# Save snapshot using adb emu command
echo "Saving snapshot..."
"$ADB" emu avd snapshot save "$SNAPSHOT_NAME"

# Verify snapshot was saved
sleep 2
if "$ADB" emu avd snapshot list | grep -q "$SNAPSHOT_NAME"; then
    echo -e "${GREEN}✅ Snapshot saved successfully!${NC}"
    echo ""
    echo "Available snapshots:"
    "$ADB" emu avd snapshot list
    echo ""
    echo -e "${YELLOW}To use this snapshot:${NC}"
    echo "- Edit start-emulator.sh and change: -snapshot $SNAPSHOT_NAME"
    echo "- Or start manually: emulator -avd Ojyx_Dev_Pixel_6 -snapshot $SNAPSHOT_NAME"
else
    echo -e "${RED}❌ Failed to save snapshot${NC}"
    exit 1
fi