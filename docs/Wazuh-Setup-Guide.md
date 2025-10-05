Wazuh SIEM Setup Guide
This guide provides step-by-step instructions for deploying the Wazuh SIEM server and installing agents on Windows and Linux endpoints within the cyber range lab.

Table of Contents
Prerequisites

SIEM Server Installation

Windows Agent Installation

Linux Agent Installation

Verifying Agent Status

Troubleshooting

Prerequisites
Before installing Wazuh, ensure your SIEM server meets these requirements:

OS: Ubuntu Server 22.04 LTS

RAM: Minimum 8 GB (4 GB will cause instability)

Storage: 50 GB minimum

CPU: 2+ cores

Network: Static IP address configured (192.168.56.15)

SIEM Server Installation
Step 1: Configure Static IP
Set a static IP address on your Ubuntu Server VM to ensure consistent connectivity.

Edit the Netplan configuration:

sudo nano /etc/netplan/00-installer-config.yaml


Apply the following configuration (adjust the interface name as needed):

network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses: [192.168.56.15/24]
      nameservers:
        addresses: [192.168.56.10]  # Point to DC01 for DNS
      routes:
        - to: default
          via: 192.168.56.1


Apply the network configuration:

sudo netplan apply


Step 2: Install Wazuh
Use the official installation script to deploy Wazuh in all-in-one mode.

Download the installation script:

curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh


Make the script executable:

sudo chmod +x wazuh-install.sh


Run the installer:

sudo ./wazuh-install.sh --all-in-one


The installer will prompt you to set passwords for various components. Save these passwords securely as they will be needed for dashboard access and agent registration.

Once installation completes, note the dashboard URL: https://192.168.56.15

Step 3: Access the Wazuh Dashboard
From your DC01 server, open a web browser and navigate to: https://192.168.56.15

Login with username admin and the password you set during installation

Accept any SSL certificate warnings (the lab uses self-signed certificates)

Windows Agent Installation
Method 1: Using the Wazuh Dashboard (Recommended)
In the Wazuh dashboard, navigate to Management > Deployment > Agents

Click Add agent and select Windows

Choose agent group (use default for lab purposes)

Click Create agent and copy the generated installation command

On the Windows target (DC01 or CLIENT01):

Download the Windows agent installer from: https://192.168.56.15

Run the installer with the parameters provided by the dashboard

or Use the MSI command from the dashboard:

msiexec.exe /i wazuh-agent-4.7.1-1.msi /q WAZUH_MANAGER='192.168.56.15' WAZUH_AGENCY_GROUP='default'


Method 2: Manual Installation
Download the agent from the SIEM server: https://192.168.56.15

Run the installer on the Windows machine

During installation, specify the manager address: 192.168.56.15

After installation, restart the service:

net stop WazuhSvc
net start WazuhSvc


Linux Agent Installation
For WEB01 Server
Add the Wazuh repository:

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/wazuh.gpg --import
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee -a /etc/apt/sources.list.d/wazuh.list


Install the agent:

sudo apt update
sudo apt install wazuh-agent

Configure the agent to point to your SIEM server:

sudo nano /var/ossec/etc/ossec.conf


Locate the <address> tag and ensure it points to your SIEM:

<address>192.168.56.15</address>


Enable and start the service:

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

Verifying Agent Status
On the Wazuh Dashboard
Navigate to Management > Deployment > Agents

Look for your agents (dc01, client01, web01)

Verify they show Active status with green indicators

On Individual Endpoints
Windows: Check service status:

sc query WazuhSvc


Linux: Check service status:

sudo systemctl status wazuh-agent

View Agent Logs:

Windows: C:\Program Files (x86)\ossec-agent\ossec.log

Linux: /var/ossec/logs/ossec.log

Troubleshooting
Common Issues and Solutions
Agent Not Appearing in Dashboard

Verify network connectivity: ping 192.168.56.15

Check firewall rules on SIEM server: sudo ufw status

Verify Wazuh manager service is running: sudo systemctl status wazuh-manager

Agent Shows as Disconnected

Check agent logs for connection errors

Verify the manager IP in ossec.conf

Restart the agent service

Cannot Access Web Interface

Check if the Wazuh dashboard service is running: sudo systemctl status wazuh-dashboard

Verify browser accepts self-signed certificates

High Resource Usage

The SIEM server requires 8 GB RAM minimum

Consider increasing VM resources if experiencing performance issues

Useful Commands
Check Wazuh manager status: sudo systemctl status wazuh-manager

Check Wazuh indexer status: sudo systemctl status wazuh-indexer

Check Wazuh dashboard status: sudo systemctl status wazuh-dashboard

Follow Wazuh manager logs: sudo tail -f /var/ossec/logs/ossec.log

Next Steps
After successful installation:

Explore the Wazuh dashboard modules

Configure additional rules and decoders for custom applications

Set up email alerts for critical security events

Practice with the Attack Scenarios guide

For more detailed information, refer to the official Wazuh documentation.