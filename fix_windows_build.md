# Fix Windows Build Issues

## Problem
When building on Windows, you get errors like:
```
package com.llfbandit.app_links does not exist
package dev.fluttercommunity.plus.connectivity does not exist
```

## Solution

### 1. Update local.properties
Replace the content of `android/local.properties` with Windows paths:
```properties
sdk.dir=C:\\Users\\[YOUR_USERNAME]\\AppData\\Local\\Android\\sdk
flutter.sdk=[YOUR_FLUTTER_PATH]
```

For example:
```properties
sdk.dir=C:\\Users\\yarri\\AppData\\Local\\Android\\sdk
flutter.sdk=D:\\dev\\flutter\\flutter
```

### 2. Clean and rebuild
```bash
flutter clean
flutter pub get
cd android
gradlew clean
cd ..
flutter build apk --debug
```

### 3. If still failing, force plugin resolution
Delete these files/folders:
- `.dart_tool/`
- `android/.gradle/`
- `android/app/build/`
- `.flutter-plugins`
- `.flutter-plugins-dependencies`

Then run:
```bash
flutter pub get
flutter build apk --debug
```

## Alternative: Use command line flags
If you don't want to modify local.properties:
```bash
flutter build apk --debug --dart-define-from-file=.env
```

## Notes
- The issue is caused by path differences between WSL and Windows
- The `.flutter-plugins` file uses Unix paths which don't work on Windows
- Jetifier must be enabled for some older plugins