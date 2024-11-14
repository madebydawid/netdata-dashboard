#!/bin/bash

# Install stress-ng and iperf3 for testing
echo "Installing stress-ng and iperf3..."
sudo apt install stress-ng iperf3 -y

# CPU stress test
echo "Starting CPU load test..."
stress-ng --cpu 2 --timeout 60s

# RAM stress test
echo "Starting RAM load test..."
stress-ng --vm 1 --vm-bytes 90% --timeout 60s

# Disk I/O stress test
echo "Starting disk I/O load test..."
mkdir -p ~/io-test
cd ~/io-test
stress-ng --io 2 --timeout 60

# Network load test
echo "Starting network load test..."
iperf3 -s > /dev/null 2>&1 &
iperf3 -c localhost

# Clean up test directory
cd ~
rm -rf ~/io-test

echo "Stress tests complete. Check the Netdata dashboard for system metrics."

