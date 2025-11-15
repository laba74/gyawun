@echo off
REM ============================================================
REM Gyawun Music - Windows Project Initialization
REM ============================================================
REM This script creates the Windows desktop project files
REM Run this ONCE before building or running the app
REM ============================================================

echo.
echo ========================================
echo   Gyawun Music - Windows Setup
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter is not installed or not in PATH
    echo.
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo.
    echo After installation:
    echo   1. Add Flutter to your PATH
    echo   2. Run: flutter doctor
    echo   3. Run this script again
    pause
    exit /b 1
)

echo [1/4] Checking Flutter installation...
flutter doctor
echo.

echo [2/4] Enabling Windows desktop support...
flutter config --enable-windows-desktop
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to enable Windows desktop support
    pause
    exit /b 1
)
echo.

echo [3/4] Creating Windows platform files...
echo This will add the "windows" folder to your project
flutter create --platforms=windows .
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to create Windows platform files
    pause
    exit /b 1
)
echo.

echo [4/4] Getting dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to get dependencies
    pause
    exit /b 1
)
echo.

echo ========================================
echo   Setup completed successfully!
echo ========================================
echo.
echo The Windows platform files have been created.
echo You can now use:
echo   - run.bat        : to run the app
echo   - build.bat      : to build for production
echo.
pause
