## 🎯 GPO Overview

### 1. COMPANY - Global Baseline Policy
- **Purpose:** Foundational security settings applied to all users and computers
- **Scope:** Domain-wide (linked to domain root)
- **Security Filtering:** Authenticated Users
- **Key Settings:** Lock screen enforcement, security warning messages

### 2. IT - Power User Configurations
- **Purpose:** Enhanced access with controlled restrictions for IT staff
- **Scope:** IT Organizational Unit
- **Security Filtering:** COMPANY\IT_Users
- **Key Settings:** Local logon rights, RDP access, UI restrictions

### 3. HR - Highly Restrictive Policy
- **Purpose:** Maximum security lockdown for sensitive HR workstations
- **Scope:** HR Organizational Unit
- **Security Filtering:** COMPANY\HR_Users
- **Key Settings:** Command prompt disabled, registry tools blocked, network drives restricted

## 🛠️ Backup Information

- **Backup Method:** PowerShell `Backup-GPO` cmdlet
- **Backup Date:** January 1, 2024
- **Domain:** company.local
- **Domain Functional Level:** Windows Server 2016
- **Domain Controller:** DC01.company.local

## 🚀 Restoration Guide

### Prerequisites
- Windows Server with Active Directory Domain Services
- Group Policy Management Console installed
- Appropriate permissions (Domain Admin recommended)

### Restoration Methods

**PowerShell Method (Recommended):**
```powershell
Import-Module GroupPolicy

# Restore all GPOs from their respective directories
Get-ChildItem -Directory | ForEach-Object {
    $gpoName = $_.Name -replace 'GPO-Backup-', '' -replace '-', ' '
    Restore-GPO -Name $gpoName -Path $_.FullName -Domain "company.local"
}
GUI Method:

Open Group Policy Management Console (gpmc.msc)

Right-click "Group Policy Objects"

Select "Manage Backups..."

Browse to the desired GPO backup directory

Select the GPO and click "Restore"

Post-Restoration Tasks
Link GPOs to appropriate OUs

Verify security filtering settings

Run gpupdate /force on test workstations

Verify policy application with gpresult /r

📊 GPO Links and Enforcement
GPO Name	Link Location	Enforcement	Status
COMPANY - Global Baseline Policy	Domain Root	No	Enabled
IT - Power User Configurations	IT OU	No	Enabled
HR - Highly Restrictive Policy	HR OU	Yes	Enabled
🔍 Verification Commands
Check GPO Restoration:

powershell
Get-GPO -All | Format-Table DisplayName, GpoStatus, ModificationTime
Verify GPO Settings:

powershell
# Check specific GPO settings
Get-GPOReport -Name "COMPANY - Global Baseline Policy" -ReportType Xml
Test Policy Application:

powershell
# On client workstation
gpresult /h gpreport.html
⚠️ Important Notes
Testing Environment: Always test GPO restoration in a non-production environment first

Permissions: Ensure you have appropriate permissions to restore GPOs

Version Compatibility: These backups are from Windows Server 2016 functional level

Customization: Review and modify settings as needed for your environment

Documentation: Each GPO directory contains detailed README with specific settings

🛡️ Security Considerations
These GPOs implement role-based access control principles

The HR policy represents an extreme security lockdown scenario

The IT policy demonstrates balanced privilege management

The global baseline establishes minimum security standards

📚 Related Documentation
Microsoft GPO Backup/Restore Documentation

Group Policy Management Console Guide

Part of the Enterprise Cyber Range Lab - https://github.com/[your-username]/enterprise-cyber-range

text

This main README file serves as an index and overview for all your GPO backups, providing users with a clear roadmap of what's available and how to use the backup files. It demonstrates professional-level documentation and understanding of enterprise Group Policy management.