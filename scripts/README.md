# Ojyx Build Scripts

This directory contains automated build scripts for the Ojyx Flutter project, specifically designed for WSL environments.

## Scripts Overview

### 1. `build_wsl_android.sh` - Main Build Script
The core build script that handles Android APK compilation in WSL environments.

**Features:**
- Comprehensive prerequisite checking (Flutter, Java, Android SDK)
- Memory optimization for WSL environments
- Multiple build modes (debug, release, profile)
- Detailed JSON/HTML reporting
- CI/CD integration support
- Post-build hooks and notifications

**Usage:**
```bash
# Basic usage
./build_wsl_android.sh                    # Debug build
./build_wsl_android.sh --release          # Release build
./build_wsl_android.sh --help             # Show comprehensive help
```

### 2. `batch_build.sh` - Batch Build Script
Builds multiple app variants in sequence or parallel.

**Features:**
- Sequential or parallel build execution
- Custom configuration file support
- Build failure handling
- Artifact archiving
- Email notifications

**Usage:**
```bash
# Build all variants
./batch_build.sh

# Parallel builds with 3 jobs
./batch_build.sh --parallel --jobs 3

# Use custom configuration
./batch_build.sh --config build_configs/production.conf
```

### 3. `auto_build.sh` - Automation Wrapper
Provides advanced automation features for continuous builds.

**Features:**
- Watch mode for file changes
- Scheduled builds
- Daemon mode
- Retry mechanisms
- Webhook notifications

**Usage:**
```bash
# Watch mode
./auto_build.sh watch --type debug

# Schedule daily builds
./auto_build.sh schedule --schedule "02:00" --type release

# Run as daemon
./auto_build.sh daemon --notify https://hooks.slack.com/...
```

### 4. Helper Scripts

- `validate_android_build.sh` - Validates Android build environment
- `clean_build.sh` - Comprehensive cleanup of build artifacts
- `test_build_script.sh` - Tests the main build script functionality
- `test_preparation.sh` - Tests preparation phase only
- `test_report_generation.sh` - Tests report generation

## Directory Structure

```
scripts/
├── build_wsl_android.sh        # Main build script
├── batch_build.sh              # Batch build script
├── auto_build.sh               # Automation wrapper
├── validate_android_build.sh   # Environment validation
├── clean_build.sh              # Cleanup utility
├── build_configs/              # Build configurations
│   └── production.conf         # Production build config
└── test_*.sh                   # Test scripts
```

## Prerequisites

1. **Flutter SDK** ≥ 3.32.6
2. **Java JDK** ≥ 17
3. **Android SDK** with build-tools
4. **WSL2** (recommended) or WSL1
5. **4GB+ RAM** available

## Quick Start

1. **First Time Setup:**
   ```bash
   # Validate environment
   ./scripts/validate_android_build.sh
   
   # Install git hooks
   ./scripts/install-hooks.sh
   ```

2. **Development Build:**
   ```bash
   ./scripts/build_wsl_android.sh --debug
   ```

3. **Production Build:**
   ```bash
   ./scripts/build_wsl_android.sh --release --clean-gradle
   ```

4. **CI/CD Build:**
   ```bash
   ./scripts/build_wsl_android.sh --release --ci
   ```

## Output Files

- **APK Files:** `build/app/outputs/apk/`
- **Build Logs:** `logs/build_*.log`
- **JSON Reports:** `logs/build_report_*.json`
- **HTML Reports:** `logs/build_report_*.html`

## Environment Variables

Required:
- `ANDROID_HOME` - Path to Android SDK
- `JAVA_HOME` - Path to Java JDK 17+

Optional:
- `GRADLE_OPTS` - Additional Gradle options
- `WEBHOOK_URL` - Default webhook for notifications
- `SENTRY_DSN` - Sentry error tracking

## Troubleshooting

### Common Issues

1. **"Java not found"**
   - Install Java 17+
   - Set `JAVA_HOME` environment variable
   - Add `$JAVA_HOME/bin` to PATH

2. **"Out of memory"**
   - Use `--low-memory` flag
   - Increase WSL memory in `.wslconfig`
   - Close other applications

3. **"Build failed"**
   - Check `logs/build_*.log` for details
   - Run with `--verbose` for more information
   - Try `--clean-gradle` to clear cache

## Contributing

When adding new build scripts:
1. Follow the existing script structure
2. Include comprehensive help (`--help`)
3. Add appropriate error handling
4. Create test scripts
5. Update this README

## License

Part of the Ojyx project. See main project LICENSE file.