# Cross-Platform Build Guide (Windows & WSL2)

## Overview

This project supports building from both Windows (Android Studio) and WSL2 environments. The main challenge is that Flutter generates platform-specific paths that differ between environments.

## Quick Setup

### First Time Setup

1. **Run the setup script for your environment:**
   ```bash
   ./scripts/setup_flutter_env.sh
   ```
   This will auto-detect your environment (Windows/WSL2) and configure the correct paths.

2. **For Windows users:**
   - After running the script, edit `android/local.properties`
   - Replace `[YOUR_USERNAME]` with your actual Windows username
   - Update the Flutter SDK path if needed

### Switching Between Environments

When switching between Windows and WSL2, simply run:
```bash
./scripts/setup_flutter_env.sh
```

The script will:
- Detect your current environment
- Update `android/local.properties` with correct paths
- Clean build artifacts
- Regenerate Flutter plugin files

## Manual Configuration

### Windows (Android Studio)

`android/local.properties`:
```properties
sdk.dir=C:\\Users\\yarri\\AppData\\Local\\Android\\sdk
flutter.sdk=D:\\dev\\flutter\\flutter
```

### WSL2

`android/local.properties`:
```properties
sdk.dir=/home/hyminix/Android/Sdk
flutter.sdk=/home/hyminix/flutter
```

## Important Files

- **android/local.properties** - Contains platform-specific paths (gitignored)
- **.flutter-plugins** - Generated by Flutter with plugin paths (gitignored)
- **android/local.properties.example** - Template for manual configuration

## Troubleshooting

### "Package does not exist" errors on Windows

This happens when Flutter plugin paths are generated in WSL2 format. Fix:
```bash
flutter clean
./scripts/setup_flutter_env.sh
flutter build apk --debug
```

### Gradle daemon crashes in WSL2

WSL2 has memory constraints. The build scripts automatically configure:
- Reduced heap size
- Disabled parallel builds
- Conservative memory settings

### Build works in one environment but not the other

Always run the setup script when switching:
```bash
./scripts/setup_flutter_env.sh
```

## CI/CD Considerations

The GitHub Actions CI uses Linux paths, similar to WSL2. The `local.properties` file is generated during CI builds.

## Development Tips

1. **Use the same Flutter version** in both environments
2. **Keep Android SDK updated** in both locations
3. **Run setup script** after pulling changes that might affect build configuration
4. **Check gradle.properties** memory settings if builds fail

## Memory Settings

### Windows (Android Studio)
Can use default settings or increase for faster builds:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### WSL2
Must use conservative settings:
```properties
org.gradle.jvmargs=-Xmx1536m -XX:MaxMetaspaceSize=256m
```