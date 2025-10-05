# GPO Backup: COMPANY - Global Baseline Policy

## 📋 Overview

This directory contains a complete backup of the **COMPANY - Global Baseline Policy** Group Policy Object (GPO). This GPO establishes the foundational security and configuration standards for all users and computers within the `COMPANY.LOCAL` domain.

## 🎯 Purpose

The Global Baseline Policy ensures consistent security posture across the entire organization by enforcing essential settings that:
- Enhance security awareness through logon messages
- Maintain corporate branding on user desktops
- Provide a secure foundation for all endpoint devices

## 🔧 GPO Configuration Details

| Setting | Value |
|---------|-------|
| **GPO Name** | `COMPANY - Global Baseline Policy` |
| **GPO Status** | Enabled |
| **Enforced** | No |
| **GUID** | `{7A34B6E1-23C8-4F89-BD67-5E1C8D3F45A2}` |
| **Domain** | `company.local` |
| **Link Location** | Domain Level (`company.local`) |
| **Security Filtering** | Authenticated Users |
| **WMI Filtering** | None |

## ⚙️ Policy Settings Applied

### User Configuration → Policies → Administrative Templates → Control Panel → Personalization
- **Force a specific default lock screen and logon image:** `Enabled`
  - Image URL: `https://company.com/assets/company-logo.png`
- **Prevent changing lock screen image:** `Enabled`

### Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Security Options
- **Interactive logon: Message title for users attempting to log on:** `Enabled`
  - Message Title: `COMPANY CORPORATE SYSTEM`
- **Interactive logon: Message text for users attempting to log on:** `Enabled`
  - Message Text: `Unauthorized use is prohibited. All activity may be monitored and reported.`

## 📁 Backup Contents

This directory contains:

1.  **`backup.xml`** - The actual GPO backup data (settings, permissions, etc.)
2.  **`gpreport.xml`** - Human-readable report of GPO configuration and settings

## 🚀 Restoration Instructions

### Method 1: Using PowerShell
```powershell
# Import the GroupPolicy module
Import-Module GroupPolicy

# Restore the GPO from backup
Restore-GPO -Name "COMPANY - Global Baseline Policy" -Path ".\GPO-Backup-COMPANY-Global-Baseline\" -Domain "company.local"

# Verify restoration
Get-GPO -Name "COMPANY - Global Baseline Policy" | Format-List DisplayName, Description, GpoStatus
Method 2: Using Group Policy Management Console (GUI)
Open Group Policy Management (gpmc.msc)

Right-click Group Policy Objects in the target domain

Select Manage Backups...

Browse to this backup directory location

Select the GPO from the list and click Restore

Verify the GPO appears in the Group Policy Objects container

🔍 Verification
After restoration, verify the GPO settings:

Open Group Policy Management Editor for the restored GPO

Navigate through the policy settings to confirm all configurations are intact

Run GPUPDATE on a test client machine: gpupdate /force

Verify policy application on the client

📝 Notes
Backup Created: January 1, 2024

Backup Tool: PowerShell Backup-GPO cmdlet

Domain Functional Level: Windows Server 2016

GPO Version: Directory: 16, SYSVOL: 16

🛡️ Security Considerations
This GPO applies to all authenticated users in the domain. Ensure that any modifications to this baseline policy are thoroughly tested in a non-production environment before deployment.

Part of the Enterprise Cyber Range Lab - https://github.com/[your-username]/enterprise-cyber-range



This README provides comprehensive documentation for your GPO backup, making it easy for others (or your future self) to understand what the GPO does and how to restore it. It shows professional-level documentation skills that would be valuable in a real enterprise environment.