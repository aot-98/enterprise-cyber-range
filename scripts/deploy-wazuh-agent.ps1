<#
.SYNOPSIS
    Automated script to install and configure Wazuh agent on Windows systems.

.DESCRIPTION
    This script downloads, installs, and configures the Wazuh agent to connect to a specified manager.
    It handles both new installations and upgrades of existing agents.

.PARAMETER WazuhManager
    IP address or hostname of the Wazuh manager server. Default is the lab SIEM: 192.168.56.15

.PARAMETER AgentName
    Custom name for the agent. Default is the computer's hostname.

.EXAMPLE
    .\deploy-wazuh-agent.ps1
    # Installs agent pointing to 192.168.56.15 with current computer name

.EXAMPLE
    .\deploy-wazuh-agent.ps1 -WazuhManager "192.168.56.15" -AgentName "CLIENT01"
    # Installs agent with custom manager IP and agent name

.NOTES
    Author: Your Name
    Lab: Enterprise Cyber Range
    Requires: PowerShell 5.1 or later, Administrative privileges
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$WazuhManager = "192.168.56.15",
    
    [Parameter(Mandatory=$false)]
    [string]$AgentName = $env:COMPUTERNAME
)

# Script version
$ScriptVersion = "1.0"

# Error action preference
$ErrorActionPreference = "Stop"

# Display script header
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Wazuh Agent Deployment Script" -ForegroundColor White
Write-Host "Version: $ScriptVersion" -ForegroundColor Gray
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check for administrative privileges
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Configuration
$DownloadUrl = "https://$WazuhManager/packages/wazuh-agent-4.7.1-1.msi"
$LocalDownloadPath = "$env:TEMP\wazuh-agent-4.7.1-1.msi"
$InstallPath = "${env:ProgramFiles(x86)}\ossec-agent"
$ServiceName = "WazuhSvc"

try {
    Write-Host "[1/6] Downloading Wazuh agent..." -ForegroundColor Yellow
    # Download the agent from the manager
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $LocalDownloadPath -UseBasicParsing
    Write-Host "Download completed: $LocalDownloadPath" -ForegroundColor Green

    # Stop service if already installed
    if (Get-Service $ServiceName -ErrorAction SilentlyContinue) {
        Write-Host "[2/6] Stopping existing Wazuh service..." -ForegroundColor Yellow
        Stop-Service -Name $ServiceName -Force
        Write-Host "Service stopped." -ForegroundColor Green
    }

    Write-Host "[3/6] Installing Wazuh agent..." -ForegroundColor Yellow
    # Install the agent silently
    $InstallArgs = @(
        "/i"
        "`"$LocalDownloadPath`""
        "/q"
        "WAZUH_MANAGER=`"$WazuhManager`""
        "WAZUH_AGENT_NAME=`"$AgentName`""
        "WAZUH_AGENT_GROUP=`"default`""
    )
    
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $InstallArgs -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -ne 0) {
        throw "Installation failed with exit code: $($process.ExitCode)"
    }
    Write-Host "Installation completed successfully." -ForegroundColor Green

    Write-Host "[4/6] Configuring agent..." -ForegroundColor Yellow
    # Verify configuration
    $ConfigFile = Join-Path $InstallPath "ossec.conf"
    if (Test-Path $ConfigFile) {
        $configContent = Get-Content $ConfigFile -Raw
        if ($configContent -match "<address>$WazuhManager</address>") {
            Write-Host "Configuration verified: Manager IP set to $WazuhManager" -ForegroundColor Green
        } else {
            Write-Host "WARNING: Manager IP might not be configured correctly." -ForegroundColor Yellow
        }
    }

    Write-Host "[5/6] Starting Wazuh service..." -ForegroundColor Yellow
    # Start and configure service
    Start-Service -Name $ServiceName
    Set-Service -Name $ServiceName -StartupType Automatic
    Write-Host "Service started and set to auto-start." -ForegroundColor Green

    Write-Host "[6/6] Verification..." -ForegroundColor Yellow
    # Verify service is running
    Start-Sleep -Seconds 5
    $serviceStatus = Get-Service -Name $ServiceName
    if ($serviceStatus.Status -eq "Running") {
        Write-Host "SUCCESS: Wazuh agent is running!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Service installed but not running. Status: $($serviceStatus.Status)" -ForegroundColor Yellow
    }

    # Display final status
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "DEPLOYMENT SUMMARY" -ForegroundColor White
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "Manager Server: $WazuhManager" -ForegroundColor Gray
    Write-Host "Agent Name: $AgentName" -ForegroundColor Gray
    Write-Host "Service Status: $($serviceStatus.Status)" -ForegroundColor Gray
    Write-Host "Installation Path: $InstallPath" -ForegroundColor Gray
    Write-Host "Log File: $InstallPath\ossec.log" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Next step: Check agent status in Wazuh dashboard." -ForegroundColor Green
    Write-Host "Dashboard URL: https://$WazuhManager" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan

}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Script execution failed." -ForegroundColor Red
    exit 1
}
finally {
    # Cleanup downloaded file
    if (Test-Path $LocalDownloadPath) {
        Remove-Item $LocalDownloadPath -Force -ErrorAction SilentlyContinue
    }
}