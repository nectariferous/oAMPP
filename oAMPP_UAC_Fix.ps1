# oAMPP - XAMPP UAC Warn solution
# Run this script as administrator

function Show-Animation {
    param ($text)
    $text.ToCharArray() | ForEach-Object {
        Write-Host $_ -NoNewline
        Start-Sleep -Milliseconds 50
    }
    Write-Host ""
}

function Open-Telegram {
    Start-Process "https://t.me/VorTexCyberBD"
}

# Animated intro
Show-Animation "Welcome to oAMPP - The XAMPP UAC Warn solution!"
Show-Animation "Developed by Apache Friends and enhanced by VorTexCyberBD"

$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$name = "EnableLUA"

# Check current value
$currentValue = (Get-ItemProperty -Path $registryPath -Name $name).$name

Show-Animation "Checking current EnableLUA value..."
Start-Sleep -Seconds 1

if ($currentValue -eq 1) {
    Show-Animation "EnableLUA is currently set to 1. Changing to 0..."
    
    # Set the new value
    Set-ItemProperty -Path $registryPath -Name $name -Value 0
    
    Show-Animation "EnableLUA has been set to 0. Please restart your computer for changes to take effect."
} else {
    Show-Animation "EnableLUA is already set to 0. No changes needed."
}

# Create registry file
$regContent = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"EnableLUA"=dword:00000000
"@

$regContent | Out-File -FilePath "oAMPP_UAC_Fix.reg" -Encoding ASCII

Show-Animation "Created oAMPP_UAC_Fix.reg file for manual fixing."

# Create batch file for easy execution
$batchContent = @"
@echo off
powershell -ExecutionPolicy Bypass -File "%~dp0oAMPP_UAC_Fix.ps1"
pause
"@

$batchContent | Out-File -FilePath "Run_oAMPP_UAC_Fix.bat" -Encoding ASCII

Show-Animation "Created Run_oAMPP_UAC_Fix.bat for easy execution."

Show-Animation "Opening Telegram channel..."
Open-Telegram

Show-Animation "Fix complete! Thank you for using oAMPP!"
Read-Host -Prompt "Press Enter to exit"
