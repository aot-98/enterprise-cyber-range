

# Netplan Configuration Files

This directory contains network configuration files for Ubuntu servers in the cyber range lab.

## Files

- `00-installer-config-wazuh.yaml`: Static IP configuration for Wazuh SIEM server (192.168.56.15)
- `00-installer-config-web01.yaml`: Static IP configuration for WEB01 server (192.168.56.20)

## Usage

1. Copy the appropriate file to your Ubuntu server:

sudo cp 00-installer-config-wazuh.yaml /etc/netplan/00-installer-config.yaml

2.Apply the configuration:


sudo netplan apply

3.Verify the IP address:


ip addr show

Important Notes

Interface names may vary (ens18, ens160, eth0, etc.). Adjust the ens18 value in the config file to match your system's interface name.

Use ip link show or ip addr show to identify the correct network interface name.

The DNS server is set to the Domain Controller (192.168.56.10) for proper domain name resolution.



## How to Use These Files

1. **On your Ubuntu VM**, identify the correct network interface name:
   ```bash
   ip link show
   # Look for the interface that isn't 'lo' (loopback)

2.Edit the config file to match your interface name if different from ens18.

3.Apply the configuration after placing the file:

sudo cp /path/to/config.yaml /etc/netplan/00-installer-config.yaml
sudo netplan apply


Verify the configuration:

ip addr show
ping 192.168.56.10  # Test connectivity to DC01
These configuration files ensure that your Ubuntu servers maintain consistent IP addresses on your lab network, which is essential for reliable communication between all components of your cyber range.