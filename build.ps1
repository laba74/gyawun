# ============================================================
# Gyawun Music - Windows Build Script (PowerShell)
# ============================================================
# This script compiles the Flutter application for Windows
# ============================================================

Write-Host ""
Write-Host "========================================"
Write-Host "  Gyawun Music - Windows Build"
Write-Host "========================================"
Write-Host ""

# Check if Flutter is installed
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterPath) {
    Write-Host "[ERROR] Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter from: https://flutter.dev/docs/get-started/install/windows"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[1/5] Checking Flutter version..." -ForegroundColor Cyan
flutter --version
Write-Host ""

Write-Host "[2/5] Enabling Windows desktop support..." -ForegroundColor Cyan
flutter config --enable-windows-desktop
Write-Host ""

Write-Host "[3/5] Getting dependencies..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "[4/5] Cleaning previous build..." -ForegroundColor Cyan
flutter clean
Write-Host ""

Write-Host "[5/5] Building for Windows (Release mode)..." -ForegroundColor Cyan
flutter build windows --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "========================================"
Write-Host "  Build completed successfully!" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
Write-Host "The executable is located at:"
Write-Host "  build\windows\x64\runner\Release\gyawun.exe" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can run it with: .\run.ps1"
Write-Host ""
Read-Host "Press Enter to exit"
