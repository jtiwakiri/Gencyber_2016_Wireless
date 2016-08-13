#!/bin/bash

sudo ip addr flush dev eth0
sudo iw dev wlan1 set 4addr on
sudo brctl addbr br0
sudo brctl addif br0 eth0 wlan1
sudo ifconfig br0 down
sudo ifconfig br0 up

sudo hostapd /etc/hostapd/hostapd.conf