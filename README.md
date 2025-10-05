🛡️ Enterprise Cyber Range Lab
A comprehensive, isolated virtual lab environment simulating a corporate network with integrated security monitoring. Built to practice penetration testing, threat detection, and incident response in a realistic setting.

📁 Repository Structure
text
cyber-range-lab/
│
├── 📄 README.md                   # This file
├── 📁 docs/                       # Detailed documentation
│   ├── Network-Diagram.png        # Visual topology of the lab
│   ├── Attack-Scenarios.md        # Step-by-step exercises
│   └── Wazuh-Setup-Guide.md       # SIEM configuration details
│
├── 📁 scripts/                    # Automation scripts
│   ├── deploy-wazuh-agent.sh      # Linux agent installer
│   └── deploy-wazuh-agent.ps1     # Windows agent installer
│
└── 📁 configs/                    # Example configuration files
    ├── netplan/                   # Ubuntu static IP configs
    └── group-policy/              # GPO backup files
🏗️ Lab Architecture
Logical Network Diagram
(You can create this in draw.io or Lucidchart and add the image here)

text
                    🛜 (Isolated)
    ____________________________________________
    |                  Lab Network             |
    |          192.168.56.0/24                 |
    |                                          |
    |  [WinSrv-22]--------[Win10]--------[Ubuntu] |
    |    DC01        |    CLIENT01    |   WEB01   |
    |   (AD, DNS)    |                | (Apache,  |
    |      |         |                |  FTP)     |
    |      |         |                |           |
    |      -------------[SIEM]-------------      |
    |               (Wazuh)                      |
    |           192.168.56.15                    |
    |____________________________________________|
                            |
                    [Kali Linux]
                    (Attacker)
                    192.168.56.200
🔧 System Specifications
Role	OS	IP Address	CPU	RAM	Storage	Purpose
Domain Controller	Windows Server 2022	192.168.56.10	2	4 GB	40 GB	Active Directory, DNS, DHCP - Heart of the network.
Workstation	Windows 10/11	192.168.56.101	2	2-4 GB	30 GB	Domain-joined client simulating an employee workstation.
Web Server	Ubuntu Server 22.04	192.168.56.20	2	2 GB	25 GB	Runs vulnerable services (Apache, FTP, Samba) for attack practice.
SIEM Server	Ubuntu Server 22.04	192.168.56.15	2	8 GB	50 GB	Wazuh SIEM for central log collection, monitoring, and alerting.
Attacker	Kali Linux	192.168.56.200	2	4 GB	25 GB	Platform for launching penetration tests and simulated attacks.
⚙️ Core Technologies Used
Virtualization: Oracle VM VirtualBox

Network Isolation: VirtualBox Host-Only Networking (vboxnet0)

Identity Management: Microsoft Active Directory Domain Services

Security Monitoring: Wazuh SIEM (XDR)

Endpoint Operating Systems: Windows Server 2022, Windows 10/11, Ubuntu Server 22.04 LTS

Penetration Testing: Kali Linux

🚀 Getting Started
Prerequisites
Oracle VM VirtualBox

At least 16 GB of RAM (recommended), 8 GB minimum

~200 GB of free storage (SSD highly recommended for VM performance)

Windows Server 2022, Windows 10/11, Ubuntu Server 22.04, Kali Linux ISO images

Installation & Configuration
VirtualBox Network Setup: Create a Host-Only network (vboxnet0) and disable its DHCP server.

Domain Controller Setup: Install Windows Server, assign a static IP, and promote to a Domain Controller for a new forest (e.g., company.local).

Build Workstations & Servers: Create VMs, assign static IPs on the vboxnet0 network, and join Windows clients to the domain.

Deploy Wazuh SIEM: Install Ubuntu Server on the SIEM VM, then install Wazuh using the official all-in-one installer script.

Install Wazuh Agents: Deploy and register agents on all endpoints (DC01, CLIENT01, WEB01) pointing to the SIEM server (192.168.56.15).

Isolate the Lab: Disable all NAT adapters, leaving only the Host-Only network active for all VMs.

(Link to your detailed setup guide in the /docs folder here)

🧪 Practicing with the Lab
This lab is designed for practicing both offensive and defensive security skills.

🔴 Red Team (Attack) Exercises
Reconnaissance: Perform network scanning (nmap) and host discovery from the Kali box.

Initial Compromise: Attack the vulnerable web application on WEB01.

Lateral Movement: Use credential dumping and PSRemoting to move from WEB01 to CLIENT01.

Domain Privilege Escalation: Attempt to compromise the Domain Controller (DC01).

🔵 Blue Team (Defend) Exercises
Monitoring: Watch live alerts in the Wazuh dashboard during attacks.

Incident Response: Investigate alerts, trace attacker activity, and practice containment.

Hardening: Use audit findings to implement Group Policies and harden endpoints.

📸 Screenshots
(Add screenshots here later)

Wazuh Dashboard showing active agents

Attack alerts triggered by Kali Linux

Group Policy Management Editor

Active Directory Users and Computers

📝 Notes & Troubleshooting
Resource Allocation: Ensure your host machine has enough RAM. The SIEM server requires at least 8 GB to run smoothly.

Network Connectivity: The most common issue is VMs not being on the same Host-Only network. Double-check each VM's adapter settings.

Wazuh Agents: If an agent doesn't appear in the dashboard, check its ossec.conf file to ensure it's pointing to the correct SIEM IP address.

🤝 Contributing
This is a personal learning project. Feel free to fork the repository and adapt the lab to your own needs. Suggestions for improvements are always welcome.

📜 License
This project is licensed for learning and personal use.

Refer to Screenshot folder for some screenshots