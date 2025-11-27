#!/bin/bash

# Setup script for Android SDK and Java
# This script installs the necessary tools to build Android APKs

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔧 Setting up Android SDK and Java for BaguioStride${NC}"
echo ""

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${RED}❌ Homebrew is not installed${NC}"
    echo "   Install Homebrew from: https://brew.sh"
    exit 1
fi

# Install Java
echo -e "${YELLOW}☕ Installing Java (Temurin JDK)...${NC}"
echo "   This will require your password for sudo"
brew install --cask temurin

# Set up Java environment
export JAVA_HOME=$(/usr/libexec/java_home)
echo -e "${GREEN}✓ Java installed at: $JAVA_HOME${NC}"

# Create Android SDK directory
ANDROID_SDK="$HOME/Library/Android/sdk"
mkdir -p "$ANDROID_SDK"

# Download Android SDK Command Line Tools
echo -e "${YELLOW}📦 Downloading Android SDK Command Line Tools...${NC}"
cd "$ANDROID_SDK"
curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip

# Extract and set up command line tools
echo -e "${YELLOW}📂 Setting up Android SDK structure...${NC}"
unzip -q commandlinetools.zip
mkdir -p cmdline-tools
mv cmdline-tools latest
mv latest cmdline-tools/

# Set environment variables
export ANDROID_HOME="$ANDROID_SDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Accept licenses
echo -e "${YELLOW}📝 Accepting Android SDK licenses...${NC}"
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1

# Install required packages
echo -e "${YELLOW}📥 Installing Android SDK packages (this may take a few minutes)...${NC}"
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"

# Add to shell profile
SHELL_PROFILE=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_PROFILE="$HOME/.bash_profile"
fi

if [ -n "$SHELL_PROFILE" ]; then
    if ! grep -q "ANDROID_HOME" "$SHELL_PROFILE"; then
        echo "" >> "$SHELL_PROFILE"
        echo "# Android SDK" >> "$SHELL_PROFILE"
        echo "export ANDROID_HOME=\$HOME/Library/Android/sdk" >> "$SHELL_PROFILE"
        echo "export ANDROID_SDK_ROOT=\$ANDROID_HOME" >> "$SHELL_PROFILE"
        echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> "$SHELL_PROFILE"
        echo -e "${GREEN}✓ Added Android SDK to $SHELL_PROFILE${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✅ Android SDK setup complete!${NC}"
echo ""
echo -e "${GREEN}📋 Next steps:${NC}"
echo "   1. Restart your terminal or run: source $SHELL_PROFILE"
echo "   2. Run the build script: cd BaguioStride-Website && ./scripts/build-app.sh"
echo ""

