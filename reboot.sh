#!/bin/bash

if ( ping 8.8.8.8 -c 10  |grep 100% ) 
then 
    d=`date +'%F %k:%M'`
    echo "$d ">> /root/reboot.txt
    /usr/bin/sync
    /usr/sbin/shutdown -r now &
    /sbin/shutdown -r now &
    sleep 30
    /sbin/reboot -f
    /usr/sbin/reboot -f
fi	


