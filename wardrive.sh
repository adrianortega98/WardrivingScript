#!/bin/bash


#pkill gpsd
pkill kismet

ifconfig wlan1 down
ifconfig wlan2 down
gpsd -n /dev/ttyACM0
sleep 1
gpspipe -w | grep -qm 1 '"mode":3'
UTCDATE=$(gpspipe -w | grep -m 1 "TPV" | sed -r 's/.*"time":"([^"]*)".*/\1/' | 
sed -e 's/^\(.\{10\}\)T\(.\{8\}\).*/\1\2/')

date -u -s "$UTCDATE"

iwconfig wlan1 mode Monitor 
iwconfig wlan2 mode Monitor
kismet -p /home/kali/wardriving -t wardrive --override wardrive -c wlan1 -c wlan2  
#/usr/bin/kismet_server
