#!/bin/bash

# Ojyx Android Emulator Creation Script
# Creates an optimized AVD for Flutter development

set -e

# Configuration
EMULATOR_NAME="Ojyx_Dev_Pixel_6"
DEVICE_DEFINITION="pixel_6"
SYSTEM_IMAGE="system-images;android-34;google_apis_playstore;x86_64"
AVDMANAGER="${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager"
SDKMANAGER="${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔧 Ojyx Emulator Setup${NC}"
echo "This will create an optimized Android emulator for Ojyx development"
echo ""

# Check ANDROID_HOME
if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}❌ Error: ANDROID_HOME is not set${NC}"
    exit 1
fi

# Check if AVD already exists
if "$AVDMANAGER" list avd | grep -q "$EMULATOR_NAME"; then
    echo -e "${YELLOW}⚠️  Emulator '$EMULATOR_NAME' already exists${NC}"
    echo "Do you want to recreate it? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Deleting existing emulator..."
        "$AVDMANAGER" delete avd -n "$EMULATOR_NAME" || true
    else
        echo "Keeping existing emulator"
        exit 0
    fi
fi

# Check and install system image
echo -e "${GREEN}Checking system image...${NC}"
if ! "$SDKMANAGER" --list_installed | grep -q "$SYSTEM_IMAGE"; then
    echo "Installing Android 34 (API 34) system image..."
    echo "This may take a few minutes..."
    "$SDKMANAGER" "$SYSTEM_IMAGE"
else
    echo "✅ System image already installed"
fi

# Accept licenses
yes | "$SDKMANAGER" --licenses >/dev/null 2>&1 || true

# Create AVD
echo -e "${GREEN}Creating AVD...${NC}"
echo "no" | "$AVDMANAGER" create avd \
    -n "$EMULATOR_NAME" \
    -k "$SYSTEM_IMAGE" \
    -d "$DEVICE_DEFINITION" \
    -c 2048M \
    --abi x86_64

# Configure AVD for performance
AVD_CONFIG_PATH="$HOME/.android/avd/${EMULATOR_NAME}.avd/config.ini"

if [ -f "$AVD_CONFIG_PATH" ]; then
    echo -e "${GREEN}Optimizing AVD configuration...${NC}"
    
    # Performance settings
    sed -i 's/hw.ramSize=.*/hw.ramSize=4096/' "$AVD_CONFIG_PATH" 2>/dev/null || \
        echo "hw.ramSize=4096" >> "$AVD_CONFIG_PATH"
    
    sed -i 's/vm.heapSize=.*/vm.heapSize=512/' "$AVD_CONFIG_PATH" 2>/dev/null || \
        echo "vm.heapSize=512" >> "$AVD_CONFIG_PATH"
    
    # Graphics acceleration
    sed -i 's/hw.gpu.enabled=.*/hw.gpu.enabled=yes/' "$AVD_CONFIG_PATH" 2>/dev/null || \
        echo "hw.gpu.enabled=yes" >> "$AVD_CONFIG_PATH"
    
    sed -i 's/hw.gpu.mode=.*/hw.gpu.mode=host/' "$AVD_CONFIG_PATH" 2>/dev/null || \
        echo "hw.gpu.mode=host" >> "$AVD_CONFIG_PATH"
    
    # CPU cores
    sed -i 's/hw.cpu.ncore=.*/hw.cpu.ncore=4/' "$AVD_CONFIG_PATH" 2>/dev/null || \
        echo "hw.cpu.ncore=4" >> "$AVD_CONFIG_PATH"
    
    # Disable unnecessary features for performance
    echo "hw.audioInput=no" >> "$AVD_CONFIG_PATH"
    echo "hw.camera.back=none" >> "$AVD_CONFIG_PATH"
    echo "hw.camera.front=none" >> "$AVD_CONFIG_PATH"
    echo "showDeviceFrame=no" >> "$AVD_CONFIG_PATH"
    
    # Quick boot
    echo "fastboot.forceFastBoot=yes" >> "$AVD_CONFIG_PATH"
    echo "fastboot.forceChosenSnapshotBoot=yes" >> "$AVD_CONFIG_PATH"
fi

echo -e "${GREEN}✅ Emulator created successfully!${NC}"
echo ""
echo "Emulator name: $EMULATOR_NAME"
echo "Device: Pixel 6"
echo "Android version: 14 (API 34)"
echo "RAM: 4GB"
echo "VM Heap: 512MB"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Run './start-emulator.sh' to start the emulator"
echo "2. The first boot will be slower (creating snapshot)"
echo "3. Subsequent boots will use the snapshot for fast startup"
echo ""
echo -e "${GREEN}Performance tips:${NC}"
echo "- Ensure virtualization is enabled in BIOS"
echo "- On Windows: Hyper-V or HAXM should be installed"
echo "- On Linux: KVM should be enabled"
echo "- On macOS: HAXM should be installed"