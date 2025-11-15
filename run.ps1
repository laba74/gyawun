# ============================================================
# Gyawun Music - Windows Run Script (PowerShell)
# ============================================================
# This script runs the Flutter application on Windows
# ============================================================

Write-Host ""
Write-Host "========================================"
Write-Host "  Gyawun Music - Run on Windows"
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

Write-Host "[1/3] Enabling Windows desktop support..." -ForegroundColor Cyan
flutter config --enable-windows-desktop
Write-Host ""

Write-Host "[2/3] Getting dependencies..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

Write-Host "[3/3] Running in debug mode..." -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================"
Write-Host "  App is starting..."
Write-Host "  Press Ctrl+C to stop"
Write-Host "========================================"
Write-Host ""
flutter run -d windows
