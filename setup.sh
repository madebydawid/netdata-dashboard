#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Netdata
echo "Installing Netdata..."
bash curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh

# Start and enable Netdata
echo "Starting Netdata service..."
sudo systemctl start netdata
sudo systemctl enable netdata

# Allow inbound traffic on port 19999 in the firewall
echo "Configuring firewall for Netdata..."
sudo ufw allow 19999/tcp
sudo ufw reload

# Configure Netdata for external access
echo "Configuring Netdata settings..."
sudo mkdir -p /etc/netdata
sudo touch /etc/netdata/netdata.conf
sudo bash -c "cat <<EOF > /etc/netdata/netdata.conf
[global]
history = 7200
[web]
bind to = 0.0.0.0
EOF"

# Set up a RAM usage alert
echo "Setting up RAM usage alert..."
sudo mkdir -p /etc/netdata/health.d
sudo touch /etc/netdata/health.d/ram-usage.conf
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

# Set up a CPU usage alert
echo "Setting up CPU usage alert..."
sudo touch /etc/netdata/health.d/cpu-usage.conf
sudo bash -c "cat <<EOF > /etc/netdata/health.d/cpu-usage.conf
alarm: cpu_usage
    on: system.cpu
    lookup: average -1m unaligned of user,system,softirq,irq,guest
    every: 1m
    warn: \$this > 80
    crit: \$this > 90
    info: CPU utilization over 80%
EOF"

# Restart Netdata to apply changes
echo "Restarting Netdata service..."
sudo systemctl restart netdata

echo "Netdata setup complete. Access the dashboard at http://<your-vm-public-ip>:19999"
