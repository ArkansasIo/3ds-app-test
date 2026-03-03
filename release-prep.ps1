#!/usr/bin/env powershell
# 3DS Homebrew FBI Release Prep Script

param(
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "3DS FBI Release Prep Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check for CIA file
Write-Host "[1/3] Checking for CIA file..." -ForegroundColor Yellow
$ciaFile = "3ds-homebrew-template/output/3ds-homebrew-template.cia"

if (-not (Test-Path $ciaFile)) {
    Write-Host "CIA file not found. Creating mock CIA..." -ForegroundColor Yellow
    
    if (Test-Path "3ds-homebrew-template/output/3ds-homebrew-template.3dsx.mock") {
        Copy-Item "3ds-homebrew-template/output/3ds-homebrew-template.3dsx.mock" $ciaFile -Force
        Write-Host "[OK] Mock CIA created: $ciaFile" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] No .3dsx.mock found." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[OK] CIA file found: $ciaFile" -ForegroundColor Green
}

# Step 2: Update FBI install URL
Write-Host "[2/3] Updating FBI install URL..." -ForegroundColor Yellow
$downloadUrl = "https://github.com/ArkansasIo/3ds-app-test/releases/download/v$Version/3ds-homebrew-template.cia"
Set-Content -Path "3ds-homebrew-template/output/fbi-install-url.txt" -Value $downloadUrl -Encoding ascii
Write-Host "[OK] URL updated: $downloadUrl" -ForegroundColor Green

# Step 3: Generate QR code
Write-Host "[3/3] Generating QR code..." -ForegroundColor Yellow
$encoded = [uri]::EscapeDataString($downloadUrl)
$qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=" + $encoded

try {
    Invoke-WebRequest -Uri $qrUrl -OutFile "3ds-homebrew-template/output/fbi-install-qr.png" -ErrorAction Stop
    Write-Host "[OK] QR code generated" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] QR generation failed, but files are ready" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "Release Prep Complete!" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output files in: 3ds-homebrew-template/output/" -ForegroundColor Cyan
Write-Host "  - 3ds-homebrew-template.cia (Mock)" -ForegroundColor Green
Write-Host "  - fbi-install-qr.png (QR Code)" -ForegroundColor Green
Write-Host "  - fbi-install-url.txt (Install URL)" -ForegroundColor Green
Write-Host ""
Write-Host "To publish release:" -ForegroundColor Cyan
Write-Host "  1. Create GitHub Release v$Version" -ForegroundColor Green
Write-Host "  2. Upload 3ds-homebrew-template.cia as asset" -ForegroundColor Green
Write-Host "  3. Share QR code with users" -ForegroundColor Green
Write-Host ""
