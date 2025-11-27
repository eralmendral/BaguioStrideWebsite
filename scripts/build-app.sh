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
    
    # Check if Android SDK is available
    if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
        # Try to find Android SDK in common locations
        if [ -d "$HOME/Library/Android/sdk" ]; then
            export ANDROID_HOME="$HOME/Library/Android/sdk"
            export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
            echo -e "${GREEN}✓ Found Android SDK at $ANDROID_HOME${NC}"
        else
            echo -e "${YELLOW}⚠️  Android SDK not found. Skipping Android build.${NC}"
            echo "   Install Android Studio from: https://developer.android.com/studio"
            echo "   Or set ANDROID_HOME or ANDROID_SDK_ROOT environment variable"
            return 1
        fi
    fi
    
    flutter build apk --release
    
    # Copy APK to downloads folder
    if [ -f "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk" ]; then
        cp "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk" "$DOWNLOAD_DIR/baguiostride.apk"
        echo -e "${GREEN}✅ Android APK copied to $DOWNLOAD_DIR/baguiostride.apk${NC}"
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

