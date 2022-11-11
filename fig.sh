#!/bin/bash

IFS='
'

cd /home/steve
for l in `ls figlet-fonts/*.flf`; do echo $1  | figlet -f "$l"; done |more
