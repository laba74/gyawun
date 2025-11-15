@echo off
REM ============================================================
REM Gyawun Music - Windows Debug Build Script
REM ============================================================
REM This script compiles the Flutter application for Windows
REM in DEBUG mode (faster, with debugging symbols)
REM ============================================================

echo.
echo ========================================
echo   Gyawun Music - Windows Debug Build
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

echo [1/5] Checking Flutter version...
flutter --version
echo.

echo [2/5] Enabling Windows desktop support...
flutter config --enable-windows-desktop
echo.

echo [3/5] Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo [4/5] Cleaning previous build...
flutter clean
echo.

echo [5/5] Building for Windows (Debug mode)...
flutter build windows --debug
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed
    pause
    exit /b 1
)
echo.

echo ========================================
echo   Debug build completed successfully!
echo ========================================
echo.
echo The executable is located at:
echo   build\windows\x64\runner\Debug\gyawun.exe
echo.
pause
