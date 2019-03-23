export DEBIAN_FRONTEND=noninteractive
killall -9 tor

if [ ! -f /usr/bin/tor ]
then
	apt-get update
	apt-get install -y tor tor-geoipdb
fi

if [ ! -f /usr/share/tor/geoip ]
then
	apt-get update
	apt-get install -y  tor-geoipdb
fi


echo "SOCKSPort 9050" > /etc/tor/torrc
echo 'EntryNodes {RO}' >> /etc/tor/torrc
echo "Log debug file /dev/null " >>  /etc/tor/torrc
echo "Log notice file /dev/null" >> /etc/tor/torrc

service tor restart


echo -n "Starting $1 tor servers, please wait "
for ((i=1;i<=$1;i++))
do
	echo -n '*'
	if [ ! -d /var/lib/tor$i ] 
	then
	    mkdir /var/lib/tor$i
	fi

    
	if [ ! -d /var/run/tor$i ] 
	then 
	    mkdir /var/run/tor$i
	fi

	chown debian-tor.debian-tor /var/lib/tor$i
	chown debian-tor.debian-tor /var/run/tor$i

	chmod 0700 /var/lib/tor$i/
	chmod 2755 /var/run/tor$i/


	cat > /usr/share/tor/tor-service-defaults-torrc$i  <<EOF
DataDirectory /var/lib/tor$i
PidFile /var/run/tor$i/tor.pid
RunAsDaemon 0
User debian-tor
ControlSocket /var/run/tor$i/control
ControlSocketsGroupWritable 1
CookieAuthentication 1
CookieAuthFileGroupReadable 1
CookieAuthFile /var/run/tor$i/control.authcookie
Log notice file /dev/null

EOF


	let "port=9050+$i"
	echo "SOCKSPort $port" > /etc/tor/torrc$i
	echo 'EntryNodes {RO}' >> /etc/tor/torrc$i
	echo "Log debug file /dev/null " >>  /etc/tor/torrc$i
	echo "Log notice file /dev/null" >> /etc/tor/torrc$i

	/usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc$i -f /etc/tor/torrc$i --RunAsDaemon 1 >/dev/null 2>/dev/null
	echo -n -e '\b'.
done
echo " Done !"
count=`ps axf|grep tor |grep -v grep |wc -l`
echo $count tor servers running 

