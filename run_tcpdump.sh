#!/bin/bash

# Record traffic
name=$(date)
name=${name//" "/"_"}
name="/home/pi/Desktop/Evil_Twin/Capture_Files/$name"

sudo tcpdump -vv -i $1 -w $name
