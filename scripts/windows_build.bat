@echo off
REM windows_build.bat - Script for Windows/Android Studio builds

echo ================================
echo Flutter Windows Build Helper
echo ================================

REM Update local.properties for Windows
echo Updating local.properties for Windows...
(
echo sdk.dir=C:\\Users\\%USERNAME%\\AppData\\Local\\Android\\sdk
echo flutter.sdk=D:\\dev\\flutter\\flutter
echo flutter.buildMode=debug
echo flutter.versionName=1.0.0
echo flutter.versionCode=1
) > android\local.properties

REM Clean previous builds
echo Cleaning build artifacts...
if exist build rmdir /s /q build
if exist android\.gradle rmdir /s /q android\.gradle
if exist android\app\build rmdir /s /q android\app\build
if exist .dart_tool rmdir /s /q .dart_tool
del /f /q .flutter-plugins 2>nul
del /f /q .flutter-plugins-dependencies 2>nul

REM Get dependencies
echo Getting Flutter dependencies...
call flutter pub get

REM Build based on parameter
if "%1"=="release" (
    echo Building release APK...
    call flutter build apk --release
) else (
    echo Building debug APK...
    call flutter build apk --debug
)

echo.
echo Build complete!
echo APK location: build\app\outputs\flutter-apk\
pause