# ============================================================
# Gyawun Music - Windows Project Initialization (PowerShell)
# ============================================================
# This script creates the Windows desktop project files
# Run this ONCE before building or running the app
# ============================================================

Write-Host ""
Write-Host "========================================"
Write-Host "  Gyawun Music - Windows Setup"
Write-Host "========================================"
Write-Host ""

# Check if Flutter is installed
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterPath) {
    Write-Host "[ERROR] Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter from: https://flutter.dev/docs/get-started/install/windows"
    Write-Host ""
    Write-Host "After installation:"
    Write-Host "  1. Add Flutter to your PATH"
    Write-Host "  2. Run: flutter doctor"
    Write-Host "  3. Run this script again"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[1/4] Checking Flutter installation..." -ForegroundColor Cyan
flutter doctor
Write-Host ""

Write-Host "[2/4] Enabling Windows desktop support..." -ForegroundColor Cyan
flutter config --enable-windows-desktop
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to enable Windows desktop support" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "[3/4] Creating Windows platform files..." -ForegroundColor Cyan
Write-Host "This will add the 'windows' folder to your project"
flutter create --platforms=windows .
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to create Windows platform files" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "[4/4] Getting dependencies..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "========================================"
Write-Host "  Setup completed successfully!" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
Write-Host "The Windows platform files have been created."
Write-Host "You can now use:"
Write-Host "  - run.bat        : to run the app" -ForegroundColor Yellow
Write-Host "  - build.bat      : to build for production" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"
