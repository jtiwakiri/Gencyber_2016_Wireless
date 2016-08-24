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

#http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html
#http://tldp.org/LDP/abs/html/
#http://www.panix.com/~elflord/unix/bash-tute.html
