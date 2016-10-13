#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get install -y hostapd bridge-utils aircrack-ng tcpdump

# Disable automatic network configuration 
sudo mv /etc/network/interfaces /etc/network/interfaces2

{
  sudo echo "source-directory /etc/network/interfaces.d"
  sudo echo "auto lo"
  sudo echo "iface lo inet loopback"
  sudo echo "iface eth0 inet manual"
  sudo echo "allow-hotplug wlan0"
  sudo echo "iface wlan0 inet manual"
  sudo echo "    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf"
  sudo echo "iface wlan1 inet manual"
} > /etc/network/interfaces

# Make the scripts executable
sudo chmod +x run_twin.sh
sudo chmod +x run_deauth.sh
sudo chmod +x run_tcpdump.sh
sudo chmod +x evil_twin

# Set evil twin to run at boot
sudo cp evil_twin /etc/init.d/evil_twin
#sudo update-rc.d evil_twin defaults

# Set ssh server to run on boot
sudo update-rc.d /etc/init.d/ssh defaults

#Move the files to the desktop
mkdir /home/pi/Desktop/Evil_Twin
mkdir /home/pi/Desktop/Evil_Twin/Capture_Files
cp twin.sh /home/pi/Desktop/Evil_Twin/twin.sh
cp deauth.sh /home/pi/Desktop/Evil_Twin/deauth.sh
cp tcpdump.sh /home/pi/Desktop/Evil_Twin/tcpdump.sh

# Reboot the pi
sudo reboot
