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

# Method 1 - Manual Setup:

### Step 1 - Installa and configure NetData
1. Create a Azure VM with public SSH key and copy public server IP.
<br>
2. Connect to the VM via:
```bash
ssh -i <your-ssh-hey.pub> <username@your-vm-public-IP>
``` 
(*optional*: Add SSH to `~/.ssh/config for easier access [Guide on how to Configure an SSH alias](https://github.com/madebydawid/ssh-remote-server-setup?tab=readme-ov-file#5-configure-an-ssh-alias)

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



## Shell Scripts
- `setup.sh`: Installs Netdata on a new system.
- `test_dashboard.sh`: Generates system load to test the dashboard.
- `cleanup.sh`: Removes the Netdata agent from the system.

This project aims to help you get hands-on with monitoring tools, automation, and DevOps practices.

---
[Link to Roadmap.sh](https://roadmap.sh/projects/simple-monitoring-dashboard)
