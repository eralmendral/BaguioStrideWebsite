# Building and Deploying App Downloads

This document explains how to build the BaguioStride app and make it available for download on the website.

## Quick Start

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
- Android SDK installed (via Android Studio or standalone)
- `ANDROID_HOME` or `ANDROID_SDK_ROOT` environment variable set (or SDK in `~/Library/Android/sdk`)
- Java Development Kit (JDK)

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
flutter build ios --release --no-codesign

# Create IPA
APP_BUNDLE="build/ios/iphoneos/Runner.app"
TEMP_DIR=$(mktemp -d)
PAYLOAD_DIR="$TEMP_DIR/Payload"
mkdir -p "$PAYLOAD_DIR"
cp -R "$APP_BUNDLE" "$PAYLOAD_DIR/"
cd "$TEMP_DIR"
zip -r "../BaguioStride-Website/public/downloads/baguiostride.ipa" Payload
rm -rf "$TEMP_DIR"
```

### Android Build
```bash
cd BaguioStride-App
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk \
  ../BaguioStride-Website/public/downloads/baguiostride.apk
```

## Notes

- iOS builds are created without code signing (`--no-codesign`). For distribution, you'll need to sign the IPA or use TestFlight/App Store.
- The build script will automatically detect Android SDK in `~/Library/Android/sdk` if `ANDROID_HOME` is not set.
- The build script will skip Android build if Android SDK is not found.
- Build files should be committed to the repository or uploaded separately for deployment.

## Troubleshooting

### iOS Build Fails
- Ensure Xcode is installed and Command Line Tools are set up: `xcode-select --install`
- Check that CocoaPods is installed: `pod --version`
- Verify Flutter is properly configured: `flutter doctor`
- Ensure you're building on macOS (iOS builds require macOS)

### Android Build Fails
- Install Android Studio from: https://developer.android.com/studio
- The script will auto-detect SDK in `~/Library/Android/sdk`, or set `ANDROID_HOME` manually
- Run `flutter doctor` to check Android setup
- Ensure Android SDK platform tools are installed via Android Studio SDK Manager

### IPA Creation Fails
- Ensure the iOS build completed successfully
- Check that the `Runner.app` bundle exists in `build/ios/iphoneos/`
- Verify you have write permissions to the downloads directory

