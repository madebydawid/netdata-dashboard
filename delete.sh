#!/bin/bash

# Stop the Netdata service
echo "Stopping Netdata service..."
sudo systemctl stop netdata

# Remove Netdata and its files
echo "Removing Netdata..."
sudo apt remove netdata -y
sudo rm -rf /etc/netdata /usr/sbin/netdata /usr/share/netdata /var/log/netdata /var/lib/netdata /var/cache/netdata ~/netdata-config

# Uninstall stress-ng and iperf3
echo "Removing stress-ng and iperf3..."
sudo apt remove stress-ng iperf3 -y

# Clean package cache
echo "Cleaning package cache..."
sudo apt clean all

echo "Netdata and stress tools have been removed. Please verify manually if needed."

