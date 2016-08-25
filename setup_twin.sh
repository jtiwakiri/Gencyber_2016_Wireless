#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get install -y hostapd bridge-utils aircrack-ng tcpdump

# Disable automatic network configuration 
sudo mv /etc/network/interfaces /etc/network/interfaces2

{
  sudo echo "auto lo"
  sudo echo "iface lo inet loopback"
  sudo echo "iface eth0 inet manual"
  sudo echo "allow-hotplug wlan0"
  sudo echo "iface wlan0 inet manual"
  sudo echo "    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf"
  sudo echo "iface wlan1 inet manual"
} > /etc/network/interfaces

# Set the run_twin script to run at boot
sudo chmod +x run_twin.sh
sudo chmod +x run_deauth.sh
sudo chmod +x run_tcpdump.sh
sudo chmod +x start_twin
sudo cp start_twin /etc/init.d/start_twin
sudo update-rc.d start_twin defaults

# Reboot the pi
sudo reboot
