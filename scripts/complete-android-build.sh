#!/bin/bash

# Script to complete Android SDK setup and build APK
# Run this after Java is installed

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APP_DIR="$PROJECT_ROOT/BaguioStride-App"
WEBSITE_DIR="$PROJECT_ROOT/BaguioStride-Website"
DOWNLOAD_DIR="$WEBSITE_DIR/public/downloads"

echo -e "${GREEN}🔧 Completing Android SDK Setup${NC}"
echo ""

# Check for Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java is not installed${NC}"
    echo "   Please install Java first:"
    echo "   brew install --cask temurin"
    exit 1
fi

export JAVA_HOME=$(/usr/libexec/java_home)
echo -e "${GREEN}✓ Java found at: $JAVA_HOME${NC}"

# Set up Android SDK
ANDROID_SDK="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Fix SDK structure if needed
if [ ! -d "$ANDROID_SDK/cmdline-tools/latest" ]; then
    echo -e "${YELLOW}📂 Fixing Android SDK structure...${NC}"
    cd "$ANDROID_SDK"
    if [ -d "latest" ]; then
        mkdir -p cmdline-tools
        mv latest cmdline-tools/
    fi
fi

# Accept licenses
echo -e "${YELLOW}📝 Accepting Android SDK licenses...${NC}"
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1 || true

# Install required packages
echo -e "${YELLOW}📥 Installing Android SDK packages...${NC}"
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" 2>&1 | grep -E "(Installing|Done|package)" || true

echo ""
echo -e "${GREEN}✅ Android SDK setup complete!${NC}"
echo ""

# Build Android APK
echo -e "${GREEN}📱 Building Android APK...${NC}"
cd "$APP_DIR"

flutter build apk --release

# Copy APK to downloads folder
if [ -f "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk" ]; then
    mkdir -p "$DOWNLOAD_DIR"
    cp "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk" "$DOWNLOAD_DIR/baguiostride.apk"
    echo -e "${GREEN}✅ Android APK built and copied to $DOWNLOAD_DIR/baguiostride.apk${NC}"
    echo ""
    ls -lh "$DOWNLOAD_DIR/baguiostride.apk"
else
    echo -e "${RED}❌ APK file not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✨ Android build complete!${NC}"
echo -e "${GREEN}   The APK is now available for download at /downloads/baguiostride.apk${NC}"


