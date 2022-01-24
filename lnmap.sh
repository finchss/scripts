#!/bin/bash

old=`pwd`
cd /dev/shm

iver=$(/usr/local/nmap/bin/nmap -version  2>/dev/null  |grep 'Nmap version' | grep -E "([0-9]{1,}\.)+[0-9]{1,}"  -o)
echo "Installed version is $iver "
ncpu=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
url=`curl https://nmap.org/download.html 2>/dev/null |grep 'https://nmap.org/dist/nmap-[0-9\.]\{1,10\}.tar.bz2' -o`


cver=$(echo $url|grep -E "([0-9]{1,}\.)+[0-9]{1,}"  -o)
echo "Current version is $cver"


if [[ "$cver" == "$iver" ]] ; then
	echo "Exiting"
	exit 0
fi


curl $url > nmap.tar.bz2
d=`echo $url |grep -o 'nmap\-[0-9]\{1,2\}\.[0-9]\{1,2\}'`
tar -xvjf nmap.tar.bz2
rm -f nmap.tar.bz2
if [ ! -d $d ] ; then
    echo "Blah"
    exit
fi
x1=`pwd`
cd $d
x2=`pwd`
if [[ "$x1" == "$x2" ]] ; then
		echo "Something wrong with the dir"
		exit 1
	fi


sudo rm -rf /usr/local/nmap
./configure --prefix=/usr/local/nmap
make -j ${ncpu}
sudo make install
for l in `ls /usr/local/nmap/bin`; do 
	sudo ln -s /usr/local/nmap/bin/$l /usr/local/bin/$l; 
done

cd ..
rm -rf $d


cd $old
