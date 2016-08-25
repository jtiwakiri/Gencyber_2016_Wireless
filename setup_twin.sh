#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get install hostapd bridge-utils aircrack-ng

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
sudo chmod 755 run_twin.sh
sudo mv run_twin.sh /etc/init.d/run_twin.sh
sudo update-rc.d -f lightdm remove
sudo update-rc.d run_twin.sh defaults

# Reboot the pi
sudo reboot
