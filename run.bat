@echo off
title IDM Trial Reset Tool
cd /d "%~dp0"

:: Periksa hak Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: Elevate diri sendiri sebagai Administrator
    powershell Start-Process cmd -Verb RunAs -ArgumentList '/c "%~f0"'
    exit /b
)

:: Jalankan PowerShell script dengan bypass execution policy
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0reset-idm-trial.ps1"
pause
