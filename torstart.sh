for ((i=1;i<=$1;i++))
do
	mkdir /var/run/tor$i/
	chown debian-tor.debian-tor /var/run/tor$i/
	/usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc$i -f /etc/tor/torrc$i --RunAsDaemon 1 >/dev/null 2>/dev/null
done

