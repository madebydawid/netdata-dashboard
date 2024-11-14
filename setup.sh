#!/bin/bash

# Update System
Echo "Updating System..."
sudo apd update && sudo apt upgrade -y

# Install Netdata
Echo "Installing Netdata..."
sudo curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh && sh /tmp/netdata-kickstart.sh

echo "Netdata Installation Complete."
