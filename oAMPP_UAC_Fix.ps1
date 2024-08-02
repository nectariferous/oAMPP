<#
.SYNOPSIS
    oAMPP - XAMPP UAC Warn Solution
.DESCRIPTION
    This script fixes the XAMPP UAC warning by modifying the EnableLUA registry value.
    It also provides additional tools and information for XAMPP users.
.NOTES
    Version:        1.0
    Author:         VorTexCyberBD
    Creation Date:  2024-08-02
    License:        MIT
#>

# Require administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    Break
}

# Import required modules
Import-Module BitsTransfer

# Function to display animated text
function Show-AnimatedText {
    param (
        [string]$Text,
        [int]$DelayMS = 30,
        [string]$ForegroundColor = "Cyan"
    )
    $Text.ToCharArray() | ForEach-Object {
        Write-Host $_ -NoNewline -ForegroundColor $ForegroundColor
        Start-Sleep -Milliseconds $DelayMS
    }
    Write-Host
}

# Function to create a progress bar
function Show-Progress {
    param (
        [int]$Percentage
    )
    $progressBar = "[" + ("=" * ($Percentage / 2)) + (" " * ((100 - $Percentage) / 2)) + "]"
    Write-Host -NoNewline "`r$progressBar $Percentage%" -ForegroundColor Yellow
}

# Main script execution
Clear-Host
Show-AnimatedText "Welcome to oAMPP - The Ultimate XAMPP UAC Warn Solution!" -ForegroundColor Magenta
Show-AnimatedText "Developed by Apache Friends, enhanced by VorTexCyberBD" -ForegroundColor Green

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$name = "EnableLUA"

Show-AnimatedText "Checking current EnableLUA value..." -ForegroundColor Cyan
for ($i = 0; $i -le 100; $i += 10) {
    Show-Progress -Percentage $i
    Start-Sleep -Milliseconds 100
}
Write-Host

$currentValue = (Get-ItemProperty -Path $registryPath -Name $name).$name

if ($currentValue -eq 1) {
    Show-AnimatedText "EnableLUA is currently set to 1. Changing to 0..." -ForegroundColor Yellow
    Set-ItemProperty -Path $registryPath -Name $name -Value 0
    Show-AnimatedText "EnableLUA has been set to 0. Please restart your computer for changes to take effect." -ForegroundColor Green
} else {
    Show-AnimatedText "EnableLUA is already set to 0. No changes needed." -ForegroundColor Green
}

# Create registry file
$regContent = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"EnableLUA"=dword:00000000
"@

$regContent | Out-File -FilePath "oAMPP_UAC_Fix.reg" -Encoding ASCII

Show-AnimatedText "Created oAMPP_UAC_Fix.reg file for manual fixing." -ForegroundColor Cyan

# Create batch file for easy execution
$batchContent = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0oAMPP_UAC_Fix.ps1"
pause
"@

$batchContent | Out-File -FilePath "Run_oAMPP_UAC_Fix.bat" -Encoding ASCII

Show-AnimatedText "Created Run_oAMPP_UAC_Fix.bat for easy execution." -ForegroundColor Cyan

# Download XAMPP configuration guide
$url = "https://www.apachefriends.org/xampp-files/8.2.4/xampp-windows-x64-8.2.4-0-VS16-installer.exe"
$output = "xampp-installer.exe"
Show-AnimatedText "Downloading latest XAMPP installer..." -ForegroundColor Yellow
Start-BitsTransfer -Source $url -Destination $output

Show-AnimatedText "Opening Telegram channel..." -ForegroundColor Magenta
Start-Process "https://t.me/VorTexCyberBD"

Show-AnimatedText "Fix complete! Thank you for using oAMPP!" -ForegroundColor Green
Read-Host -Prompt "Press Enter to exit"
