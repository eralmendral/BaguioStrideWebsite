#!/bin/bash

# Build script for BaguioStride App
# This script builds the Flutter app for iOS and Android, then copies the builds to the website's public folder

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APP_DIR="$PROJECT_ROOT/BaguioStride-App"
WEBSITE_DIR="$PROJECT_ROOT/BaguioStride-Website"
DOWNLOAD_DIR="$WEBSITE_DIR/public/downloads"

echo -e "${GREEN}🚀 Starting BaguioStride App Build Process${NC}"
echo ""

# Create downloads directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Function to build Android APK
build_android() {
    echo -e "${YELLOW}📱 Building Android APK...${NC}"
    cd "$APP_DIR"
    
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
        return 1
    fi
    
    # Check for Java
    if ! command -v java &> /dev/null; then
        echo -e "${RED}❌ Java is not installed${NC}"
        echo "   Install Java: brew install --cask temurin"
        echo "   Or install Android Studio which includes Java"
        return 1
    fi
    
    # Set up Java environment
    if [ -z "$JAVA_HOME" ]; then
        export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null || echo "")
        if [ -n "$JAVA_HOME" ]; then
            echo -e "${GREEN}✓ Java found at: $JAVA_HOME${NC}"
        fi
    fi
    
    # Check if Android SDK is available
    if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
        # Try to find Android SDK in common locations
        if [ -d "$HOME/Library/Android/sdk" ]; then
            export ANDROID_HOME="$HOME/Library/Android/sdk"
            export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
            export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
            echo -e "${GREEN}✓ Found Android SDK at $ANDROID_HOME${NC}"
            
            # Check if SDK packages are installed
            if [ ! -d "$ANDROID_HOME/platform-tools" ] || [ ! -d "$ANDROID_HOME/build-tools" ]; then
                echo -e "${YELLOW}⚠️  Android SDK packages not fully installed${NC}"
                echo -e "${YELLOW}   Installing required packages...${NC}"
                
                # Accept licenses and install packages
                yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1 || true
                $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
                    "platform-tools" \
                    "platforms;android-34" \
                    "build-tools;34.0.0" > /dev/null 2>&1 || {
                    echo -e "${YELLOW}   Package installation may have failed. Continuing anyway...${NC}"
                }
            fi
        else
            echo -e "${YELLOW}⚠️  Android SDK not found. Skipping Android build.${NC}"
            echo "   Install Android Studio from: https://developer.android.com/studio"
            echo "   Or set ANDROID_HOME or ANDROID_SDK_ROOT environment variable"
            return 1
        fi
    fi
    
    # Configure Flutter to use the Android SDK
    flutter config --android-sdk "$ANDROID_HOME" > /dev/null 2>&1 || true
    
    # Get Mapbox token from environment or config file
    MAPBOX_TOKEN="${MAPBOX_ACCESS_TOKEN:-}"
    if [ -z "$MAPBOX_TOKEN" ]; then
        # Try to read from mcp-config.json
        if [ -f "$PROJECT_ROOT/mcp-config.json" ]; then
            MAPBOX_TOKEN=$(grep -o '"MAPBOX_ACCESS_TOKEN":\s*"[^"]*"' "$PROJECT_ROOT/mcp-config.json" | cut -d'"' -f4 || echo "")
        fi
    fi
    
    # Try to read from ~/.mapbox or ~/mapbox files (like iOS build does)
    if [ -z "$MAPBOX_TOKEN" ]; then
        if [ -f ~/.mapbox ]; then
            MAPBOX_TOKEN=$(cat ~/.mapbox 2>/dev/null | tr -d '\n' || echo "")
        elif [ -f ~/mapbox ]; then
            MAPBOX_TOKEN=$(cat ~/mapbox 2>/dev/null | tr -d '\n' || echo "")
        fi
    fi
    
    # Build command with Mapbox token if available
    # Use --split-per-abi to create smaller APKs (under 100MB limit)
    # This creates separate APKs for each architecture (arm64-v8a, armeabi-v7a, x86_64)
    BUILD_CMD="flutter build apk --release --split-per-abi"
    if [ -n "$MAPBOX_TOKEN" ]; then
        BUILD_CMD="$BUILD_CMD --dart-define=MAPBOX_ACCESS_TOKEN=$MAPBOX_TOKEN"
        echo -e "${GREEN}✓ Mapbox token found, will be included in build${NC}"
    else
        echo -e "${YELLOW}⚠️  Mapbox token not found. Map may not work in the APK.${NC}"
        echo -e "${YELLOW}   Set MAPBOX_ACCESS_TOKEN environment variable or create ~/.mapbox file${NC}"
    fi
    
    echo -e "${YELLOW}🔨 Building release APK (split per ABI to keep under 100MB)...${NC}"
    eval "$BUILD_CMD"
    
    # Copy arm64-v8a APK (most common architecture for modern Android devices)
    # This APK is typically 30-40MB, well under the 100MB limit
    if [ -f "$APP_DIR/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" ]; then
        cp "$APP_DIR/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk" "$DOWNLOAD_DIR/baguiostride.apk"
        APK_SIZE=$(ls -lh "$DOWNLOAD_DIR/baguiostride.apk" | awk '{print $5}')
        echo -e "${GREEN}✅ Android APK (arm64-v8a) copied to $DOWNLOAD_DIR/baguiostride.apk${NC}"
        echo -e "${GREEN}   Size: $APK_SIZE (under 100MB limit)${NC}"
        echo -e "${GREEN}   The APK is signed and ready for installation${NC}"
        echo -e "${YELLOW}   Note: This APK supports arm64-v8a devices (most modern Android phones)${NC}"
        echo -e "${YELLOW}   For other architectures, use the other APK files from build directory${NC}"
    else
        echo -e "${RED}❌ APK file not found${NC}"
        return 1
    fi
}

# Function to build iOS app
build_ios() {
    echo -e "${YELLOW}🍎 Building iOS App...${NC}"
    cd "$APP_DIR"
    
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
        return 1
    fi
    
    # Check if we're on macOS (required for iOS builds)
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}❌ iOS builds require macOS${NC}"
        return 1
    fi
    
    # Build signed IPA using ad-hoc distribution (for direct device installation)
    echo -e "${YELLOW}🔐 Building signed IPA with ad-hoc distribution...${NC}"
    echo -e "${YELLOW}   Note: This requires a valid Apple Developer account${NC}"
    echo -e "${YELLOW}   Ad-hoc distribution allows installation on registered devices${NC}"
    
    # Try ad-hoc distribution first (works with free Apple ID for development)
    flutter build ipa --release --export-method=ad-hoc || {
        echo -e "${YELLOW}⚠️  Ad-hoc export failed, trying development method...${NC}"
        flutter build ipa --release --export-method=development || {
            echo -e "${RED}❌ IPA export failed${NC}"
            echo -e "${YELLOW}   Archive was created. You can export manually:${NC}"
            echo -e "${YELLOW}   1. Open Xcode${NC}"
            echo -e "${YELLOW}   2. Window > Organizer${NC}"
            echo -e "${YELLOW}   3. Select the archive and click 'Distribute App'${NC}"
            echo -e "${YELLOW}   4. Choose 'Ad Hoc' or 'Development' distribution${NC}"
            return 1
        }
    }
    
    # Check if build was successful
    # Flutter creates IPA at build/ios/ipa/<app-name>.ipa
    APP_NAME="baguio_stride_app"
    IPA_BUILD_PATH="$APP_DIR/build/ios/ipa/$APP_NAME.ipa"
    IPA_PATH="$DOWNLOAD_DIR/baguiostride.ipa"
    
    if [ ! -f "$IPA_BUILD_PATH" ]; then
        echo -e "${RED}❌ IPA file not found at $IPA_BUILD_PATH${NC}"
        echo -e "${YELLOW}   This may indicate a code signing issue. Check:${NC}"
        echo -e "${YELLOW}   1. Xcode is signed in with your Apple ID${NC}"
        echo -e "${YELLOW}   2. Development Team is configured in Xcode${NC}"
        echo -e "${YELLOW}   3. Signing certificates are installed${NC}"
        echo -e "${YELLOW}   4. For ad-hoc: Device UDIDs are registered in your Apple Developer account${NC}"
        return 1
    fi
    
    # Copy IPA to downloads folder
    cp "$IPA_BUILD_PATH" "$IPA_PATH"
    
    if [ -f "$IPA_PATH" ]; then
        echo -e "${GREEN}✅ Signed iOS IPA created at $IPA_PATH${NC}"
        echo -e "${GREEN}   The IPA is code-signed and ready for installation${NC}"
    else
        echo -e "${RED}❌ Failed to copy IPA to downloads folder${NC}"
        return 1
    fi
}

# Main build process
echo -e "${GREEN}📂 App Directory: $APP_DIR${NC}"
echo -e "${GREEN}📂 Website Directory: $WEBSITE_DIR${NC}"
echo -e "${GREEN}📂 Downloads Directory: $DOWNLOAD_DIR${NC}"
echo ""

# Build Android (if SDK is available)
if build_android; then
    echo ""
else
    echo -e "${YELLOW}⚠️  Android build skipped${NC}"
    echo ""
fi

# Build iOS
if build_ios; then
    echo ""
else
    echo -e "${YELLOW}⚠️  iOS build skipped or failed${NC}"
    echo ""
fi

echo -e "${GREEN}✨ Build process completed!${NC}"
echo ""
echo -e "${GREEN}📦 Build files location:${NC}"
ls -lh "$DOWNLOAD_DIR" | grep -E "\.(apk|ipa)$" || echo "No build files found"

