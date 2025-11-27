# Building and Deploying App Downloads

This document explains how to build the BaguioStride app and make it available for download on the website.

## Quick Start

### First Time Setup (Android)

If you haven't set up Android SDK yet, run the setup script first:

```bash
cd BaguioStride-Website
./scripts/setup-android-sdk.sh
```

This will install Java and Android SDK automatically. You'll need to enter your password when prompted.

### Building Apps

To build both iOS and Android versions and copy them to the website:

```bash
cd BaguioStride-Website
./scripts/build-app.sh
```

## Prerequisites

### For iOS Build
- Flutter SDK installed and in PATH
- Xcode installed (macOS only)
- Xcode Command Line Tools
- CocoaPods installed

### For Android Build
- Flutter SDK installed and in PATH
- Java Development Kit (JDK) - Install via: `brew install --cask temurin`
- Android SDK installed - Run setup script: `./scripts/setup-android-sdk.sh`
- Or install Android Studio from: https://developer.android.com/studio
- `ANDROID_HOME` or `ANDROID_SDK_ROOT` environment variable set (or SDK in `~/Library/Android/sdk`)

## Build Process

The build script (`scripts/build-app.sh`) will:

1. **Build iOS App**: Creates an `.ipa` file from the Flutter iOS build
2. **Build Android App**: Creates an `.apk` file (if Android SDK is available)
3. **Copy to Website**: Places build files in `public/downloads/` folder

## Output Files

After building, the following files will be available in `public/downloads/`:

- `baguiostride.ipa` - iOS app package (20MB+)
- `baguiostride.apk` - Android APK (if Android SDK is configured)

## Download Links

The website's download buttons are configured in `src/components/ui/AppStoreBadges.astro` and `src/components/layout/Footer.astro`:

- iOS: `/downloads/baguiostride.ipa`
- Android: `/downloads/baguiostride.apk`

## Manual Build Steps

If you prefer to build manually:

### iOS Build
```bash
cd BaguioStride-App
flutter build ipa --release

# Copy IPA to downloads folder
cp build/ios/ipa/baguio_stride_app.ipa \
  ../BaguioStride-Website/public/downloads/baguiostride.ipa
```

### Android Build
```bash
cd BaguioStride-App
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk \
  ../BaguioStride-Website/public/downloads/baguiostride.apk
```

## Notes

- iOS builds are created with code signing using `flutter build ipa --release`. This requires:
  - A valid Apple Developer account (paid membership)
  - Xcode signed in with your Apple ID
  - Development Team configured in Xcode project
  - Valid signing certificates installed
  - The signed IPA can be installed directly on iOS devices (with proper provisioning)
- The build script will automatically detect Android SDK in `~/Library/Android/sdk` if `ANDROID_HOME` is not set.
- The build script will skip Android build if Android SDK is not found.
- Build files should be committed to the repository or uploaded separately for deployment.

## Troubleshooting

### iOS Build Fails
- Ensure Xcode is installed and Command Line Tools are set up: `xcode-select --install`
- Check that CocoaPods is installed: `pod --version`
- Verify Flutter is properly configured: `flutter doctor`
- Ensure you're building on macOS (iOS builds require macOS)
- **Code Signing Issues:**
  - Open `ios/Runner.xcworkspace` in Xcode
  - Go to Runner target > Signing & Capabilities
  - Ensure "Automatically manage signing" is checked
  - Verify your Development Team is selected
  - Sign in to Xcode with your Apple ID: Xcode > Preferences > Accounts
  - Accept any Apple Developer agreements if prompted

### Android Build Fails
- **Java not found**: Install Java via `brew install --cask temurin` (requires password)
- **Android SDK not found**: Run the setup script: `./scripts/setup-android-sdk.sh`
- Or install Android Studio from: https://developer.android.com/studio
- The script will auto-detect SDK in `~/Library/Android/sdk`, or set `ANDROID_HOME` manually
- Run `flutter doctor` to check Android setup
- Ensure Android SDK platform tools are installed
- After setup, restart your terminal or run: `source ~/.zshrc` (or `~/.bash_profile`)

### IPA Creation Fails
- Ensure the iOS build completed successfully
- Check that the `Runner.app` bundle exists in `build/ios/iphoneos/`
- Verify you have write permissions to the downloads directory

