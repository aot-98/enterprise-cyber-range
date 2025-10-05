# GPO Backup: IT - Power User Configurations

## 📋 Overview

This directory contains a complete backup of the **IT - Power User Configurations** Group Policy Object (GPO). This GPO provides enhanced system access for IT department staff while maintaining necessary security restrictions for privileged accounts.

## 🎯 Purpose

This GPO implements the principle of **"least privilege"** for IT personnel by:
- Granting necessary administrative access for system maintenance
- Restricting non-essential functions to reduce attack surface
- Creating a secure baseline for IT workstation configurations
- Demonstrating role-based access control implementation

## 🔧 GPO Configuration Details

| Setting | Value |
|---------|-------|
| **GPO Name** | `IT - Power User Configurations` |
| **GPO Status** | Enabled |
| **Enforced** | No |
| **GUID** | `{8B45C7D2-19F3-4E76-A5C9-1B88E6D3F7C1}` |
| **Domain** | `company.local` |
| **Link Location** | IT Organizational Unit |
| **Security Filtering** | COMPANY\IT_Users |
| **WMI Filtering** | None |

## ⚙️ Policy Settings Applied

### Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → User Rights Assignment
- **Allow log on locally:** `COMPANY\IT_Users`
- **Allow log on through Remote Desktop Services:** `COMPANY\IT_Users`

### User Configuration → Policies → Administrative Templates → System
- **Remove Lock Computer:** `Enabled`
- **Remove Change Password:** `Enabled`

### User Configuration → Policies → Administrative Templates → Windows Components → File Explorer
- **Hide these specified drives in My Computer:** `Enabled`
  - Restrict all drives: `Yes`

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
Restore-GPO -Name "IT - Power User Configurations" -Path ".\GPO-Backup-IT-Power-User-Config\" -Domain "company.local"

# Verify restoration
Get-GPO -Name "IT - Power User Configurations" | Format-List DisplayName, Description, GpoStatus
Method 2: Using Group Policy Management Console (GUI)
Open Group Policy Management (gpmc.msc)

Right-click Group Policy Objects in the target domain

Select Manage Backups...

Browse to this backup directory location

Select the GPO from the list and click Restore

Link the restored GPO to the IT Organizational Unit

🔍 Verification
After restoration, verify the GPO settings and application:

Policy Application Test:

powershell
# Run on an IT department workstation
gpresult /r /scope:user
# Verify "IT - Power User Configurations" appears in Applied GPOs
Settings Verification:

Log in as an IT user account

Verify Ctrl+Alt+Del menu lacks "Lock Computer" option

Check that drives are hidden in File Explorer

Confirm ability to RDP to other systems

📝 Notes
Backup Created: January 1, 2024

Target Users: Members of COMPANY\IT_Users security group

OU Structure: Linked to company.local/_COMPANY Users/IT/

Testing Recommendation: Test with non-administrator IT user accounts first

🛡️ Security Rationale
This GPO demonstrates balanced security controls:

Granted Privileges: Local and remote logon rights for system maintenance

Restricted Functions: Removal of lock/password change to prevent security bypass

Access Control: Drive hiding to protect sensitive system areas

Targeted Application: Security filtering ensures only IT staff receive these policies

⚠️ Production Considerations
In a production environment:

Consider splitting into separate GPOs for workstations vs. servers

Add WMI filtering for specific operating systems

Implement more granular security group filtering

Test thoroughly before widespread deployment

Part of the Enterprise Cyber Range Lab - https://github.com/[your-username]/enterprise-cyber-range



This README provides comprehensive documentation that shows understanding of both the technical implementation and the security rationale behind the GPO settings. It demonstrates enterprise-level thinking about privilege management and security controls.
