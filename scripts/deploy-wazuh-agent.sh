#!/bin/bash

# deploy-wazuh-agent.sh
# Description: Automated script to install and configure Wazuh agent on Linux systems
# Usage: sudo ./deploy-wazuh-agent.sh <WAZUH_MANAGER_IP> [AGENT_NAME]

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}This script must be run as root. Use sudo.${NC}"
    exit 1
fi

# Default values
DEFAULT_MANAGER="192.168.56.15"
DEFAULT_AGENT_NAME=$(hostname)

# Get parameters or use defaults
WAZUH_MANAGER=${1:-$DEFAULT_MANAGER}
AGENT_NAME=${2:-$DEFAULT_AGENT_NAME}

# Validate IP address format
if ! [[ $WAZUH_MANAGER =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid IP address format for Wazuh manager.${NC}"
    echo "Usage: sudo $0 <WAZUH_MANAGER_IP> [AGENT_NAME]"
    exit 1
fi

echo -e "${GREEN}Starting Wazuh Agent deployment...${NC}"
echo "Target Wazuh Manager: $WAZUH_MANAGER"
echo "Agent Name: $AGENT_NAME"
echo ""

# Function to check command success
check_success() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success!${NC}"
    else
        echo -e "${RED}Failed!${NC}"
        exit 1
    fi
}

# Step 1: Add Wazuh repository
echo -e "${YELLOW}[1/5] Adding Wazuh repository...${NC}"
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring /usr/share/keyrings/wazuh.gpg --import
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
check_success

# Step 2: Update package list and install agent
echo -e "${YELLOW}[2/5] Installing Wazuh agent...${NC}"
apt update
apt install wazuh-agent -y
check_success

# Step 3: Configure agent
echo -e "${YELLOW}[3/5] Configuring agent...${NC}"
# Backup original config
cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.bak

# Update manager address in configuration
sed -i "s/<address>.*<\/address>/<address>${WAZUH_MANAGER}<\/address>/" /var/ossec/etc/ossec.conf

# Set agent name if provided
if [ "$AGENT_NAME" != "$DEFAULT_AGENT_NAME" ]; then
    sed -i "s/<ossec_config>/<ossec_config>\n  <client>\n    <config-profile>$(hostname)<\/config-profile>\n    <notify_time>10<\/notify_time>\n    <time-reconnect>60<\/time-reconnect>\n  <\/client>/" /var/ossec/etc/ossec.conf
fi
check_success

# Step 4: Enable and start service
echo -e "${YELLOW}[4/5] Starting Wazuh agent service...${NC}"
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl start wazuh-agent
check_success

# Step 5: Verify installation
echo -e "${YELLOW}[5/5] Verifying installation...${NC}"
sleep 3 # Give service time to start
if systemctl is-active --quiet wazuh-agent; then
    echo -e "${GREEN}Wazuh agent is running successfully!${NC}"
    echo ""
    echo -e "Agent status: $(systemctl is-active wazuh-agent)"
    echo -e "Manager IP: $WAZUH_MANAGER"
    echo -e "Agent name: $AGENT_NAME"
    echo ""
    echo -e "${GREEN}Deployment completed! Check the Wazuh dashboard for agent status.${NC}"
else
    echo -e "${RED}Wazuh agent is not running. Check logs: journalctl -u wazuh-agent${NC}"
    exit 1
fi

# Display log path for troubleshooting
echo ""
echo -e "${YELLOW}Log file: /var/ossec/logs/ossec.log${NC}"
echo -e "${YELLOW}To check connection status: tail -f /var/ossec/logs/ossec.log${NC}"