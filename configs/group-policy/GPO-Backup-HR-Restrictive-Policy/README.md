# GPO Backup: HR - Highly Restrictive Policy

## 📋 Overview

This directory contains a complete backup of the **HR - Highly Restrictive Policy** Group Policy Object (GPO). This GPO implements extreme security lockdown measures for HR department workstations that handle sensitive personnel data, financial information, and confidential employee records.

## 🎯 Purpose

This GPO creates a **secure kiosk-like environment** for HR personnel by:
- Preventing data exfiltration through multiple channels
- Eliminating system modification capabilities
- Restricting access to only approved HR applications
- Creating an audit-friendly, controlled workstation environment
- Demonstrating maximum security lockdown principles

## 🔧 GPO Configuration Details

| Setting | Value |
|---------|-------|
| **GPO Name** | `HR - Highly Restrictive Policy` |
| **GPO Status** | Enabled |
| **Enforced** | Yes |
| **GUID** | `{9C56D8E3-2A47-4F89-BD22-5E1C8D3F99A3}` |
| **Domain** | `company.local` |
| **Link Location** | HR Organizational Unit |
| **Security Filtering** | COMPANY\HR_Users |
| **WMI Filtering** | None |

## ⚙️ Policy Settings Applied

### User Configuration → Policies → Administrative Templates → System
- **Prevent access to command prompt:** `Enabled` (Disables script processing)
- **Disable registry editing tools:** `Enabled`
- **Remove Screen Saver tab:** `Enabled`
- **Remove Background tab:** `Enabled`
- **Remove Settings tab:** `Enabled`

### User Configuration → Policies → Administrative Templates → Windows Components
- **Remove Map Network Drive and Disconnect Network Drive:** `Enabled`
- **Remove ability to connect/disconnect network connections:** `Enabled`
- **Remove access to Windows Update:** `Enabled`

### User Configuration → Policies → Administrative Templates → Control Panel
- **Force classic Control Panel view:** `Enabled`
- **Disable Control Panel:** `Enabled`

### User Configuration → Policies → Administrative Templates → Start Menu and Taskbar
- **Remove Run menu from Start Menu:** `Enabled`
- **Remove "Search Internet" option:** `Enabled`
- **Prevent users from pinning items to taskbar:** `Enabled`

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
Restore-GPO -Name "HR - Highly Restrictive Policy" -Path ".\GPO-Backup-HR-Restrictive-Policy\" -Domain "company.local"

# Verify restoration
Get-GPO -Name "HR - Highly Restrictive Policy" | Format-List DisplayName, Description, GpoStatus
Method 2: Using Group Policy Management Console (GUI)
Open Group Policy Management (gpmc.msc)

Right-click Group Policy Objects in the target domain

Select Manage Backups...

Browse to this backup directory location

Select the GPO from the list and click Restore

Link the restored GPO to the HR Organizational Unit

Set the GPO to Enforced for highest priority

🔍 Verification
After restoration, verify the GPO settings and application:

Policy Application Test:

powershell
# Run on an HR department workstation
gpresult /r /scope:user
# Verify "HR - Highly Restrictive Policy" appears in Applied GPOs
Settings Verification:

Log in as an HR user account

Verify command prompt (cmd.exe) is completely blocked

Confirm registry editor (regedit.exe) is disabled

Check that Network Drive mapping is unavailable

Verify Control Panel is either classic view or completely disabled

Confirm Run menu is missing from Start Menu

📝 Notes
Backup Created: January 1, 2024

Target Users: Members of COMPANY\HR_Users security group

OU Structure: Linked to company.local/_COMPANY Users/HR/

Enforcement: This GPO is set to Enforced to prevent accidental override

Testing Recommendation: Test with non-administrator HR user accounts

🛡️ Security Rationale
This GPO implements defense-in-depth for sensitive data environments:

Data Exfiltration Prevention: No network drives, no command prompt, no scripting

System Integrity Protection: Registry disabled, system modifications prevented

Controlled Environment: UI restrictions create predictable, auditable workspace

Least Privilege: Users can only use approved applications, nothing more

⚠️ Production Considerations
In a production environment:

Communication: Explain security rationale to HR staff before deployment

Exceptions: Create a separate less-restrictive GPO for HR administrators

Testing: Thoroughly test all required HR applications work within restrictions

Monitoring: Implement enhanced auditing for HR workstations

Backout Plan: Have a procedure to quickly remove restrictions if business impact occurs

🔄 Alternative Approaches
For less restrictive environments, consider:

Using AppLocker instead of disabling entire components

Implementing Windows Defender Application Control (WDAC)

Using folder redirection and read-only permissions instead of full lockdown

Part of the Enterprise Cyber Range Lab - https://github.com/[your-username]/enterprise-cyber-range

text

This README provides comprehensive documentation that shows understanding of extreme security lockdown scenarios, which is valuable for demonstrating knowledge of data protection in high-security environments like HR, finance, or healthcare sectors.