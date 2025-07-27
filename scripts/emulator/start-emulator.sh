#!/bin/bash

# Ojyx Android Emulator Startup Script
# Optimized for performance with hardware acceleration

set -e

# Configuration
EMULATOR_NAME="Ojyx_Dev_Pixel_6"
EMULATOR_EXECUTABLE="${ANDROID_HOME}/emulator/emulator"
ADB="${ANDROID_HOME}/platform-tools/adb"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Ojyx Development Emulator...${NC}"

# Check if ANDROID_HOME is set
if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}❌ Error: ANDROID_HOME is not set${NC}"
    echo "Please set ANDROID_HOME to your Android SDK path"
    exit 1
fi

# Check if emulator exists
if ! "$EMULATOR_EXECUTABLE" -list-avds | grep -q "$EMULATOR_NAME"; then
    echo -e "${RED}❌ Error: Emulator '$EMULATOR_NAME' not found${NC}"
    echo "Available emulators:"
    "$EMULATOR_EXECUTABLE" -list-avds
    echo ""
    echo "Please create the emulator first using create-emulator.sh"
    exit 1
fi

# Check if emulator is already running
if "$ADB" devices | grep -q "emulator-"; then
    echo -e "${YELLOW}⚠️  An emulator is already running${NC}"
    "$ADB" devices
    echo "Do you want to kill it and start a new one? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Killing existing emulator..."
        "$ADB" -s emulator-5554 emu kill 2>/dev/null || true
        sleep 2
    else
        echo "Using existing emulator"
        exit 0
    fi
fi

# Start emulator with optimized settings
echo -e "${GREEN}Starting emulator with hardware acceleration...${NC}"

# Launch emulator with performance flags
"$EMULATOR_EXECUTABLE" \
    -avd "$EMULATOR_NAME" \
    -gpu host \
    -accel-check \
    -no-boot-anim \
    -no-audio \
    -no-snapshot-save \
    -snapshot ojyx_clean \
    -memory 4096 \
    -cores 4 \
    -no-snapshot-load \
    &

# Get the emulator PID
EMULATOR_PID=$!

# Wait for emulator to boot
echo -e "${YELLOW}Waiting for emulator to boot...${NC}"
"$ADB" wait-for-device

# Wait for boot completion
while [ "$("$ADB" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" != "1" ]; do
    sleep 1
    echo -n "."
done
echo ""

# Optimize emulator settings
echo -e "${GREEN}Applying performance optimizations...${NC}"

# Disable animations for better performance
"$ADB" shell settings put global window_animation_scale 0.0
"$ADB" shell settings put global transition_animation_scale 0.0
"$ADB" shell settings put global animator_duration_scale 0.0

# Set up for Ojyx development
"$ADB" shell settings put global development_settings_enabled 1
"$ADB" shell settings put global adb_enabled 1

# Unlock screen
"$ADB" shell input keyevent 82

# Show device info
echo -e "${GREEN}✅ Emulator started successfully!${NC}"
echo ""
echo "Device info:"
"$ADB" shell getprop ro.product.model
"$ADB" shell getprop ro.build.version.release
echo ""
echo "Emulator is ready for Ojyx development!"
echo "Run 'flutter devices' to verify connection"
echo ""
echo -e "${YELLOW}Tip: Use 'save-snapshot.sh' to save current state${NC}"