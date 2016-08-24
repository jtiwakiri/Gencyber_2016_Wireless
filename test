#!/bin/bash

ap=$(iwconfig) # | grep "Access Point")
echo $ap

next="0"
point=""

for token in $ap
do
  if ["$next" == "1"]
    then
      point=$token
  fi
  if ["$token" == "Point:"]
    then
      next=1
  fi
done

echo $point


#start=$(expr index "$ap" "Access Point")

#echo $start

#ap=$(expr substr $ap
