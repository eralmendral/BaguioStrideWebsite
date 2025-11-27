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
    
    # Build iOS app
    flutter build ios --release --no-codesign
    
    # Check if build was successful
    if [ ! -d "$APP_DIR/build/ios/iphoneos" ]; then
        echo -e "${RED}❌ iOS build directory not found${NC}"
        return 1
    fi
    
    APP_NAME="Runner"
    APP_BUNDLE="$APP_DIR/build/ios/iphoneos/$APP_NAME.app"
    IPA_PATH="$DOWNLOAD_DIR/baguiostride.ipa"
    
    if [ ! -d "$APP_BUNDLE" ]; then
        echo -e "${RED}❌ App bundle not found at $APP_BUNDLE${NC}"
        return 1
    fi
    
    # Create IPA file
    echo -e "${YELLOW}📦 Creating IPA file...${NC}"
    
    # Create Payload directory
    TEMP_IPA_DIR=$(mktemp -d)
    PAYLOAD_DIR="$TEMP_IPA_DIR/Payload"
    mkdir -p "$PAYLOAD_DIR"
    
    # Copy app bundle to Payload
    cp -R "$APP_BUNDLE" "$PAYLOAD_DIR/"
    
    # Create IPA using zip
    cd "$TEMP_IPA_DIR"
    zip -r "$IPA_PATH" Payload > /dev/null
    
    # Clean up
    rm -rf "$TEMP_IPA_DIR"
    
    if [ -f "$IPA_PATH" ]; then
        echo -e "${GREEN}✅ iOS IPA created at $IPA_PATH${NC}"
        echo -e "${YELLOW}⚠️  Note: This IPA is unsigned and may require manual signing for installation${NC}"
    else
        echo -e "${RED}❌ IPA creation failed${NC}"
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

