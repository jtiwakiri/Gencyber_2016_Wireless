#!/bin/bash

# Record traffic
name=$(date)
name=${name//" "/"_"}
name="/home/pi/Desktop/$name"

sudo tcpdump -vv -i $1 -w $name
