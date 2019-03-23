export DEBIAN_FRONTEND=noninteractive

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

for ((i=1;i<=$1;i++))
do


	mkdir /var/lib/tor$i
	chown debian-tor.debian-tor /var/lib/tor$i

	mkdir /var/run/tor$i
	chown debian-tor.debian-tor /var/run/tor$i
	chmod 2750 /var/run/tor$i/
	#mkdir /var/log/tor$i
	#chown debian-tor.adm /var/log/tor$i


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
#Log notice file /var/log/tor$i/log
Log notice file /dev/null

EOF


	let "port=9050+$i"
	echo "SOCKSPort $port" > /etc/tor/torrc$i
	echo 'EntryNodes {RO}' >> /etc/tor/torrc$i
	echo "Log debug file /dev/null " >>  /etc/tor/torrc$i
	echo "Log notice file /dev/null" >> /etc/tor/torrc$i
	echo "Log debug file /dev/null" >>  /etc/tor/torrc$i

	/usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc$i -f /etc/tor/torrc$i --RunAsDaemon 1
done

