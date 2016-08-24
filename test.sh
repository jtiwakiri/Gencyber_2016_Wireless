#!/bin/bash

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

echo $mac
echo $essid

#ap=$(expr substr $ap

#http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html
#http://tldp.org/LDP/abs/html/
#http://www.panix.com/~elflord/unix/bash-tute.html
