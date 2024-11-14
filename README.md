# Netdata Monitoring Dashboard

  

## Project Overview

This project provides a guided step-by-step approach to setting up a monitoring dashboard using Netdata. It allows you to monitor the health and performance of Azure VM instance in real-time via a dashboard. This project is designed to help you understand the fundamentals of monitoring, from installation to setting up custom metrics and alerts.

The project is broken down into two parts: a manual setup and a automatic one, using shell scripts. Furthermore, this guide will present a way to conduct a stress test on the server, thus validating that everything works as intended. Lastly it will provide guidance on how to clean up the system once all is done.

## Objectives

- Install and configure Netdata on a Linux system.
- Monitor basic system metrics (CPU, memory usage, disk I/O).
- Access and customize the Netdata dashboard.
- Set up an alert for a specific metric (e.g., CPU usage above 80%).
- Automate the setup with shell scripts.
 

## Project Requirements

- Linux system (e.g., Ubuntu).
- Basic knowledge of shell scripting.
- Web browser to access the Netdata dashboard.

  

## Steps

1. Install Netdata manually.
2. Configure Netdata to monitor key metrics.
3. Customize one aspect of the dashboard.
4. Set up an alert for a specific metric.
5. Automate the setup and testing with shell scripts.

  

# Method 1 - Manual Setup

### Step 1 - Install and configure NetData

1. Create a Azure VM with public SSH key and copy public server IP.

<br>

2. Connect to the VM via:

```bash
ssh -i <your-ssh-hey.pub> <username@your-vm-public-IP>

```

3. Update your system packages:
```bash
sudo apd update && sudo apt upgrade -y

```

4. Install NetData:
```bash
bash "curl -Ss https://my-netdata.io/kickstart.sh"
```

5. Start NetData:
```bash
sudo systemctl start netdata
```

6. Check NetData status:
```bash
sudo systemctl status netdata
```

7. Allow traffic to Netdata:

- **Default port** (19999) in Azure's Network Security Group (NSG).
- **Type:** TCP
- **Source**: Your IP address (for security reasons)

8. Test Netdata dashboard on your web browser:

```bash
http://your-azure-vm-ip:19999

```

(**Note**: You might need to "Sign In" to see the Dashboard)

9. Customize the dashboard by editing the config file:

```bash
sudo nano /etc/netdata/netdata.conf
```

Add these basic configurations:

```bash
[global]

# Increase history (default is 3600 seconds)
history = 7200

[web]
# Allow connections from any IP
bind to = 0.0.0.0
```

10. Set up a RAM-usage alert by creating new alert configuration:
```bash
sudo nano /etc/netdata/health.d/ram-usage.conf
```

Add the following to the file and save it (`ctrl+x & Y`)

```bash
# Alarm för RAM-användning over 80%
alarm: ram_usage
    on: system.ram
    lookup: average -1m percentage of used -15s
    units: %
    every: 1m
    warn: $this > 80
    crit: $this > 90
    info: The percentage of RAM being used by the system.
    to: sysadmin
 ```

10. Set up a CPU-usage alert by creating new alert configuration:

```bash
sudo nano /etc/netdata/health.d/cpu-usage.conf
```

Add the following to the file and save it (`ctrl+x & Y`)

```bash
alarm: cpu_usage
on: system.cpu
lookup: average -1m unaligned of user,system,softirq,irq,guest
every: 1m
warn: $this > 80
crit: $this > 90
info: CPU utilization over 80%
```

### Step 2 - Stress test your server

1. Install stress-ng tool to test the server
```bash
sudo apt install stress-ng -y
```

2. Test CPU Load:
```bash
sudo stress-ng --cpu 2 --vm-bytes 90% --vm-hang 0 --timeout 60s
```

3. Test RAM Load:
```bash
sudo stress-ng --vm 1 --vm-bytes 90% --vm-hang 0 --timeout 60s
```
3. Test Disk I/O Load:

```bash
# Create a temporary directory for I/O testing
mkdir ~/io-test
cd ~/io-test

# Generate disk I/O with 2 workers for 60 seconds
stress-ng --io 2 --timeout 60
```
4. Test Network Load:
```bash
# Install iperf3 tool for testing network
sudo yum install iperf3 -y

# Run iperf3 server
iperf3 -s

# In another terminal, run client test
iperf3 -c localhost
```

5. Combined load test:
```bash
stress-ng --cpu 2 --vm 1 --vm-bytes 512M --io 2 --timeout 120
```
### Step 3 - Cleanup System and Remove Netdata

1. Stop the Netdata service:
```bash
sudo systemctl stop netdata
```

2. Remove Netdata from the system:
```bash
sudo apt remove netdata -y
```

3. Remove Netdata related files, data and cache:

```bash
# Remove Netdata binaries from common installation locations
sudo rm -rf /usr/sbin/netdata

# Remove Netdata configuration files
sudo rm -rf /etc/netdata

# Remove Netdata web interface and plugin files
sudo rm -rf /usr/share/netdata

# Remove log and database files
sudo rm -rf /var/log/netdata
sudo rm -rf /var/lib/netdata

# Remove temporary files and cache
sudo rm -rf /var/cache/netdata

# Remove user-specific configuration files
sudo rm -rf ~/netdata-config

# Provide confirmation to the user
echo "Netdata has been removed from the system. Manually check for any remaining residues."

```

4. Remove stress testing tools:

```bash

sudo apt remove stress-ng iperf3 -y

```

5. Remove test files and directories:

```bash

# Remove the I/O test directory we created
rm -rf ~/io-test


# Remove any temporary files
rm -f /tmp/testfile
sudo rm -f /tmp/netdata-kickstart.sh

```

6. Clean package cache:
```bash
sudo apt clean all
```
7. Verify cleanup:
```bash
# Check if Netdata service exists
systemctl status netdata

# Check for any remaining Netdata processes
ps aux | grep netdata

# Check for remaining directories
ls -la /etc/netdata
ls -la /var/cache/netdata
ls -la /var/lib/netdata
ls -la /var/log/netdata
```
# Method 2 - Using Shell scripts

### Script 1 - Setup Netdata (setup.sh)

## Shell Scripts

- `setup.sh`: Installs Netdata on a new system.
- `test_dashboard.sh`: Generates system load to test the dashboard.
- `cleanup.sh`: Removes the Netdata agent from the system.

This project aims to help you get hands-on with monitoring tools, automation, and DevOps practices.


---

[Link to Roadmap.sh](https://roadmap.sh/projects/simple-monitoring-dashboard)