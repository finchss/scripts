#!/bin/bash 


dnsh=`which tdns`
if [ -z "$dnsh" ]
then
	dnsh=`which host`
	if [ -z "$dnsh" ]
	then
		echo "host and tdns not found, please install one of them"	
		exit 1
	fi
fi


ns="ns1.he.net"


if [ -z ${PATH+x} ];then
	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
else
	PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
fi

if  [ $# -ne 2 ] && [ $# -ne 3 ] 
then
	echo "Usage:"
	echo
	echo -e "\t./HeNetDnsUpdate.sh <hostname> <password>"
	echo 
	echo -e "\t./HeNetDnsUpdate.sh <interface> <hostname> <password>"
	echo
	exit 
fi

case $# in 
	2)
		if (  which curl >/dev/null 2 >&1 ) 
		then 
			echo '"curl" is not installed'
			echo -e "On debian you can use \"apt-get install curl\" to install it"
			exit
		fi

		ip=`curl -s -4 -k https://api.ipify.org 2>/dev/null `
		lip=`${dnsh} -4 $1 ${ns}  2>/dev/null | grep 'has address' |awk '{print $4}'`
		if [  "$ip" != "$lip" ] 
		then 
			echo Updating $1
			curl -s -4 -k "https://$1:$2@dyn.dns.he.net/nic/update?hostname=$1"
		else
			echo "Ip hasn't changed ($ip)"
		fi
	;;
	3)
		iface=$1
		hname=$2
		pass=$3
		if [ $OSTYPE == "linux-gnu" ] ;then
			if ( ! cat /proc/net/dev |grep "${iface}:" >/dev/null 2>&1) ; then
				echo "No such interface "
				exit 1
			fi
		fi
		
		if [ $OSTYPE == "linux-gnu" ] ;then
			iface_ip=`ip addr show dev ${iface} |grep inet |grep brd |awk '{print $2}' |cut -f 1 -d /`
		else 
			if [[ $OSTYPE == darwin* ]]; then
				iface_ip=`ifconfig ${iface} |grep -E 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' -o |cut -f 2 -d " "`
			else
				echo "Unknown os or vsar not set"
				exit 1
				
			fi
		fi
			
		if [ -z "$iface_ip" ]
		then
			echo "Interface ${iface} has no ip configured"
			exit 1
		fi
		iip=`${dnsh} -4 ${hname} ${ns} 2>/dev/null| grep 'has address' |awk '{print $4}'`
		if [ -z "${iip}" ]
		then
			echo "Cannot resolve host ${hname}"
			exit 1
		fi 
		
		if [ "${iip}" != "${iface_ip}" ]
		then
			dynip=$(${dnsh} -4 dyn.dns.he.net| grep 'has address' |awk '{print $4}')
			echo "Host $hname resolved to $iip, updating to $iface_ip"
			curl -s -4 -k "https://${hname}:${pass}@${dynip}/nic/update?hostname=${hname}&myip=${iface_ip}" -H 'Host: dyn.dns.he.net'
			echo 
		else
			[[ -t 1 ]] && echo "Ip is the same: ${iip}"
			exit 0
		fi
		
		
	;;
esac

