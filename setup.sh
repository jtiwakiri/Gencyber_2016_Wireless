#!/bin/bash

sudo apt-get update
sudo apt-get install hostapd bridge-utils aircrack-ng

sudo mv /etc/network/interfaces /etc/network/interfaces2
sudo echo "auto lo\niface lo inet loopback\niface eth0 inet manual\niface wlan0 inet manual" > /etc/network/interfaces
sudo echo "interface=wlan1\ndriver=nl80211\nssid=test\nchannel=6" > /etc/hostapd/hostapd.conf

sudo reboot