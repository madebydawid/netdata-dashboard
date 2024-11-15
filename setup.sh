#!/bin/bash

##################################################
# Author: Dawid Kuzbiel                         ##
# Date: 14-11-2024                              ##
#                                               ##
# Version: v1                                   ##
#                                               ##
# Netdata Installation and Configuration Script ##
#                                               ##
# This script installs and configures Netdata   ##
# for monitoring system health and setting up   ##
# alerts for RAM and CPU usage.                 ##
##################################################

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Netdata
echo "Installing Netdata..."
bash curl -sSL https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sudo bash /tmp/netdata-kickstart.sh

# Start and enable Netdata service
echo "Starting and enabling Netdata service..."
sudo systemctl start netdata
sudo systemctl enable netdata

# Allow inbound traffic on port 19999 in the firewall
if sudo ufw status | grep -q "inactive"; then
    echo "Firewall is inactive, skipping reload."
else
    sudo ufw allow 19999/tcp
    sudo ufw reload
fi

# Configure Netdata for external access
echo "Configuring Netdata settings..."
sudo mkdir -p /etc/netdata
sudo bash -c "cat <<EOF > /etc/netdata/netdata.conf
[global]
history = 7200
[web]
bind to = 0.0.0.0
EOF"

# Set up RAM usage alert
echo "Setting up RAM usage alert..."
sudo mkdir -p /etc/netdata/health.d
sudo bash -c "cat <<EOF > /etc/netdata/health.d/ram-usage.conf
alarm: ram_usage
    on: system.ram
    lookup: average -1m percentage of used -15s
    units: %
    every: 1m
    warn: \$this > 80
    crit: \$this > 90
    info: The percentage of RAM being used by the system.
    to: sysadmin
EOF"

# Set up CPU usage alert
echo "Setting up CPU usage alert..."
sudo bash -c "cat <<EOF > /etc/netdata/health.d/cpu-usage.conf
alarm: cpu_usage
    on: system.cpu
    lookup: average -1m unaligned of user,system,softirq,irq,guest
    every: 1m
    warn: \$this > 80
    crit: \$this > 90
    info: CPU utilization over 80%
EOF"

# Restart Netdata service to apply changes
echo "Restarting Netdata service to apply the changes..."
sudo systemctl restart netdata

# Completion message
echo "Netdata setup complete. You can access the dashboard at http://<your-vm-public-ip>:19999"