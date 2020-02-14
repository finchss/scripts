#!/bin/bash


if [ $# -ne 2 ]
then
	echo "Usage:"
	echo
	echo "./HeNetDnsUpdate.sh <hostname> <password>"
	echo
	exit 
fi

if (  which host >/dev/null 2 >&1 ) 
then 
	echo '"host" is not installed'
	echo -e "On debian you can use \"apt-get install bind9-host\" to install it"
	exit
fi



if (  which curl >/dev/null 2 >&1 ) 
then 
	echo '"curl" is not installed'
	echo -e "On debian you can use \"apt-get install curl\" to install it"
	exit
fi

ip=`curl -4 -k https://api.ipify.org 2>/dev/null `
lip=`host -4 $1 ns1.he.net  | grep 'has address' |awk '{print $4}'`

if [  "$ip" != "$lip" ] 
then 
    echo Updating $1
    curl -4 -k "https://$1:$2@dyn.dns.he.net/nic/update?hostname=$1"
else
    echo "Ip hasn't changed ($ip)"
fi
