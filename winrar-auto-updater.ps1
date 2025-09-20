<#
.SYNOPSIS
    WinRAR Auto Updater - Automatically update WinRAR to the latest version

.DESCRIPTION
    This PowerShell script intelligently updates WinRAR to the latest version from the official RARLab website.
    Supports both stable and beta versions with automatic scheduling capabilities.

.PARAMETER register
    Register a Windows Scheduled Task to run the updater daily at 3:00 AM

.EXAMPLE
    .\winrar-auto-updater.ps1
    Run the updater immediately

.EXAMPLE
    .\winrar-auto-updater.ps1 -register
    Register scheduled task for daily automatic updates

.NOTES
    File Name      : winrar-auto-updater.ps1
    Author         : vnsur (https://github.com/vnsur)
    Prerequisite   : PowerShell 5.1+, Windows 10/11, Administrator privileges
    Version        : 1.0.0
    Created        : 2025-01-20
    Last Modified  : 2025-01-20
    
.LINK
    https://github.com/vnsur/winrar-auto-updater

#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="Register Windows Scheduled Task for daily updates")]
    [switch]$register
)

# =====================================
# SCRIPT METADATA & AUTHOR INFORMATION
# =====================================

$ScriptInfo = @{
    Name = "WinRAR Auto Updater"
    Version = "1.0.0"
    Author = "vnsur"
    GitHub = "https://github.com/vnsur"
    Repository = "https://github.com/vnsur/winrar-auto-updater"
    Created = "2025-01-20"
    Description = "Automatically update WinRAR to the latest version"
    License = "MIT"
}

# Display script header
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  WinRAR Auto Updater v$($ScriptInfo.Version)" -ForegroundColor Yellow
Write-Host "  Author: $($ScriptInfo.Author)" -ForegroundColor Green
Write-Host "  GitHub: $($ScriptInfo.GitHub)" -ForegroundColor Blue
Write-Host "  Created: $($ScriptInfo.Created)" -ForegroundColor Magenta
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = $MyInvocation.MyCommand.Definition

# Check for Administrator privileges
if ($register) {
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
        Write-Host "Administrator privileges required for scheduling tasks!" -ForegroundColor Yellow
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" -register" -Verb RunAs
        exit 
    }
} else {
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
        Write-Host "Administrator privileges required for WinRAR installation!" -ForegroundColor Yellow
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        exit 
    }
}

# =====================================
# SCHEDULED TASK REGISTRATION
# =====================================

$time = [datetime]"03:00:00"

if ($register) {
    try {
        Write-Host "Registering scheduled task 'AutoUpdateWinRAR_DarkMethod'..." -ForegroundColor Yellow

        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

        # Trigger: daily at specific time
        $triggerTime = New-ScheduledTaskTrigger -Daily -At $time
        $triggerTime.ExecutionTimeLimit = 'PT1H'
        $triggerTime.StartBoundary = (Get-Date).Date.Add($time.TimeOfDay).ToString("s")

        $now = (Get-Date)

        if ($now -gt (Get-Date).Date.Add($time.TimeOfDay)) {
            Write-Host "Scheduled time already passed, running script for the first time now..." -ForegroundColor Cyan
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        }

        $triggers = @($triggerTime)
        $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
        $principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -RunLevel Highest

        Register-ScheduledTask -TaskName "AutoUpdateWinRAR_DarkMethod" `
                                -Action $action `
                                -Trigger $triggers `
                                -Principal $principal `
                                -Settings $settings `
                                -Force `
                                -Description "Daily auto update WinRAR - Created by $($ScriptInfo.Name) v$($ScriptInfo.Version)"

        Write-Host "Task registered successfully! Will run daily at $($time.TimeOfDay)" -ForegroundColor Green
        Write-Host "Task Name: AutoUpdateWinRAR_DarkMethod" -ForegroundColor Gray
        Write-Host "Created by: $($ScriptInfo.Author)" -ForegroundColor Gray

        exit
    } catch {
        Write-Host "Failed to register scheduled task: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# =====================================
# MAIN UPDATE LOGIC
# =====================================

Write-Host "Initializing WinRAR Auto Updater..." -ForegroundColor Cyan

$webClient = New-Object System.Net.WebClient
$webClient.Headers.Add("User-Agent", "Mozilla/5.0 WinRAR-AutoUpdater/$($ScriptInfo.Version)")

# Function to get installed WinRAR version
function Get-CurrentWinRARVersion {
    Write-Host "Detecting current WinRAR version..." -ForegroundColor Yellow
    
    # Check registry for WinRAR installation
    $regPaths = @(
        "HKLM:\SOFTWARE\WinRAR",
        "HKLM:\SOFTWARE\WOW6432Node\WinRAR",
        "HKCU:\SOFTWARE\WinRAR"
    )
    
    foreach ($path in $regPaths) {
        if (Test-Path $path) {
            $version = Get-ItemProperty -Path $path -Name "exe64" -ErrorAction SilentlyContinue
            if ($version) {
                $exePath = $version.exe64
                if (Test-Path $exePath) {
                    $fileVersion = (Get-ItemProperty $exePath).VersionInfo.FileVersion
                    if ($fileVersion) {
                        Write-Host "Found WinRAR version: $fileVersion" -ForegroundColor Green
                        return $fileVersion
                    }
                }
            }
        }
    }
    
    # Alternative: Check Program Files
    $winrarPaths = @(
        "${env:ProgramFiles}\WinRAR\WinRAR.exe",
        "${env:ProgramFiles(x86)}\WinRAR\WinRAR.exe"
    )
    
    foreach ($path in $winrarPaths) {
        if (Test-Path $path) {
            $fileVersion = (Get-ItemProperty $path).VersionInfo.FileVersion
            if ($fileVersion) {
                Write-Host "Found WinRAR version: $fileVersion" -ForegroundColor Green
                return $fileVersion
            }
        }
    }
    
    Write-Host "WinRAR not found on this system" -ForegroundColor Red
    return $null
}

# Function to get latest WinRAR version from rarlab.com
function Get-LatestWinRARVersion {
    try {
        Write-Host "Checking latest version from RARLab.com..." -ForegroundColor Yellow
        
        # Get the download page
        $downloadPage = $webClient.DownloadString("https://www.rarlab.com/download.htm")
        
        # Look for beta versions first
        $betaPattern = 'WinRAR.+(\d+\.\d+)\s+beta\s*(\d*)'
        if ($downloadPage -match $betaPattern) {
            $baseVersion = $matches[1]
            $betaNumber = if ($matches[2]) { $matches[2] } else { "1" }
            Write-Host "Found beta version: WinRAR $baseVersion beta $betaNumber" -ForegroundColor Magenta
            return @{
                Version = "$baseVersion.$betaNumber"
                IsBeta = $true
                BaseVersion = $baseVersion
                BetaNumber = $betaNumber
                DisplayName = "WinRAR $baseVersion beta $betaNumber"
            }
        }

        # Look for stable versions
        $stablePattern = 'WinRAR.+(\d+\.\d+)(?!\s+beta)'
        if ($downloadPage -match $stablePattern) {
            $stableVersion = $matches[1]
            Write-Host "Found stable version: WinRAR $stableVersion.0" -ForegroundColor Green
            return @{
                Version = "$stableVersion.0"
                IsBeta = $false
                BaseVersion = $stableVersion
                BetaNumber = $null
                DisplayName = "WinRAR $stableVersion"
            }
        }
        
        # Alternative: Look for direct download links
        $linkPattern = 'winrar.+\d+(?:b\d+)?\.exe'
        if ($downloadPage -match $linkPattern) {
            $filename = $matches[0]

            # Parse beta files like "winrar-x32-700b2.exe" -> 7.00 beta 2
            if ($filename -match 'winrar.+(\d)(\d+)b(\d+)\.exe') {
                $major = $matches[1]
                $minor = $matches[2]
                $beta = $matches[3]
                Write-Host "Found beta version: WinRAR $major.$minor beta $beta" -ForegroundColor Magenta
                return @{
                    Version = "$major.$minor.$beta"
                    IsBeta = $true
                    BaseVersion = "$major.$minor"
                    BetaNumber = $beta
                    DisplayName = "$major.$minor beta $beta"
                }
            }
            # Parse stable files like "winrar-x64-713.exe" -> 7.13
            elseif ($filename -match 'winrar.+(\d)(\d+)\.exe') {
                $major = $matches[1]
                $minor = $matches[2]
                Write-Host "Found stable version: WinRAR $major.$minor.0" -ForegroundColor Green
                return @{
                    Version = "$major.$minor.0"
                    IsBeta = $false
                    BaseVersion = "$major.$minor"
                    BetaNumber = $null
                    DisplayName = "$major.$minor"
                }
            }
        }

        return $null

    } catch {
        Write-Host "Failed to get latest version from rarlab.com: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Function to download and install WinRAR
function Install-WinRAR($versionInfo) {
    try {
        # Detect architecture
        $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x32" }
        Write-Host "Detected architecture: $arch" -ForegroundColor Cyan

        $filename = $null
        
        # Construct filename based on version info
        if ($versionInfo.IsBeta) {
            # Beta version like 6.20 beta 1 -> winrar-x64-620b1.exe
            if ($versionInfo.BaseVersion -match '(\d+)\.(\d+)') {
                $major = $matches[1]
                $minor = $matches[2].PadLeft(2, '0')
                $filename = "winrar-${arch}-${major}${minor}b$($versionInfo.BetaNumber).exe"
            }
        } else {
            # Stable version like 7.13 -> winrar-x64-713.exe
            if ($versionInfo.BaseVersion -match '(\d+)\.(\d+)') {
                $major = $matches[1]
                $minor = $matches[2].PadLeft(2, '0')
                $filename = "winrar-${arch}-${major}${minor}.exe"
            }
        }

        if (-not $filename) {
            Write-Host "Unable to construct filename for version: $($versionInfo.DisplayName)" -ForegroundColor Red
            return $false
        }
        
        # Construct download URL
        $downloadUrl = "https://www.rarlab.com/rar/$filename"

        Write-Host "Downloading WinRAR $($versionInfo.DisplayName)..." -ForegroundColor Yellow
        Write-Host "URL: $downloadUrl" -ForegroundColor Gray
        
        $tempFile = Join-Path $env:TEMP $filename
        $webClient.DownloadFile($downloadUrl, $tempFile)

        if (Test-Path $tempFile) {
            $fileSize = [math]::Round((Get-Item $tempFile).Length / 1MB, 2)
            Write-Host "Download completed! Size: $fileSize MB" -ForegroundColor Green
            Write-Host "Installing WinRAR $($versionInfo.DisplayName)..." -ForegroundColor Yellow
            
            # Run installer with silent parameters
            $installArgs = "/S /LANG=English"
            $process = Start-Process -FilePath $tempFile -ArgumentList $installArgs -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host "WinRAR $($versionInfo.DisplayName) installed successfully!" -ForegroundColor Green
            } else {
                Write-Host "Installation completed with exit code: $($process.ExitCode)" -ForegroundColor Yellow
            }
            
            # Clean up
            Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
            if (Test-Path $tempFile) { 
                Remove-Item $tempFile -Recurse -Force -ErrorAction SilentlyContinue 
            }

            return $true
        } else {
            Write-Host "Download failed - file not found" -ForegroundColor Red
            return $false
        }
        
    } catch {
        Write-Host "Failed to download/install WinRAR: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Logging function
$logfile = "C:\winrar-auto-update.log"

function Log($message) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $logEntry = "[$timestamp] $message"
    Write-Host $logEntry
    $logEntry | Out-File $logfile -Append -Encoding UTF8
}

# Header log entry
Log "=================================================="
Log "$($ScriptInfo.Name) v$($ScriptInfo.Version) - Started"
Log "Author: $($ScriptInfo.Author) | GitHub: $($ScriptInfo.GitHub)"
Log "=================================================="

# Main execution logic
if (-not (Get-Process -Name "WinRAR" -ErrorAction SilentlyContinue)) {
    Log "WinRAR is not running. Proceeding with update check..."

    $currentVersion = Get-CurrentWinRARVersion

    try {
        if($currentVersion) {
            Log "Current WinRAR version: $currentVersion"
            
            $latestVersion = Get-LatestWinRARVersion
            
            if($latestVersion) {
                Log "Latest available version: $($latestVersion.Version) ($($latestVersion.DisplayName))"
                
                if([version]($latestVersion.Version) -gt [version]$currentVersion) {
                    Log "Starting update from $currentVersion to $($latestVersion.Version)..."

                    $success = Install-WinRAR $latestVersion

                    if ($success) {
                        Log "SUCCESS: WinRAR has been updated to version $($latestVersion.Version)"
                        Write-Host ""
                        Write-Host "Update completed successfully!" -ForegroundColor Green
                        Write-Host "Created by: $($ScriptInfo.Author)" -ForegroundColor Gray
                        Write-Host "Repository: $($ScriptInfo.Repository)" -ForegroundColor Gray
                    } else {
                        Log "FAILED: Failed to update WinRAR"
                        exit 1
                    }
                } else {
                    Log "WinRAR is already up to date (version $currentVersion)"
                    Write-Host "No update needed - WinRAR is current!" -ForegroundColor Green
                }
             } else {
                Log "ERROR: Could not retrieve latest version from rarlab.com"
                exit 1
             }
        } else {
            Log "WARNING: WinRAR is not installed. Skipping update."
            Write-Host "WinRAR not found on this system" -ForegroundColor Yellow
        }
    } catch {
        Log "ERROR: $($_.Exception.Message)"
        Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
} else {
    Log "WinRAR is currently running. Skipping update to avoid conflicts."
    Write-Host "WinRAR is running - update skipped" -ForegroundColor Yellow
}

Log "=================================================="
Log "$($ScriptInfo.Name) v$($ScriptInfo.Version) - Completed"
Log "=================================================="

Write-Host ""
Write-Host "Log file: $logfile" -ForegroundColor Gray
Write-Host "Script by: $($ScriptInfo.Author) | $($ScriptInfo.GitHub)" -ForegroundColor Gray
