@echo off
REM ============================================================
REM Gyawun Music - Windows Run Script
REM ============================================================
REM This script runs the Flutter application on Windows
REM ============================================================

echo.
echo ========================================
echo   Gyawun Music - Run on Windows
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    pause
    exit /b 1
)

echo [1/3] Enabling Windows desktop support...
flutter config --enable-windows-desktop
echo.

echo [2/3] Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [3/3] Running in debug mode...
echo.
echo ========================================
echo   App is starting...
echo   Press Ctrl+C to stop
echo ========================================
echo.
flutter run -d windows
