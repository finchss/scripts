#!/bin/bash

IFS='
'

if [ $# -ne 0 ] ; then
	cd $1
fi

for l in `lsblk  |grep disk|cut -f 1 -d " " `; do 
    smartctl -a /dev/$l|ts '%Y-%m-%d %H:%M' >> $l
done
