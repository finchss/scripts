bld="/var/lib/mtor"
for ((i=0;i<=50;i++))
do
    
	if [ -f $bld/torrc$i ]
	then
	    mkdir /var/run/tor${i}/
	    chown debian-tor.debian-tor /var/run/tor${i}/
	    chmod 0700 /var/run/tor$i/
	    /usr/bin/tor --defaults-torrc $bld/tor-service-defaults-torrc$i -f $bld/torrc$i --RunAsDaemon 1 >/dev/null 2>/dev/null
	fi
done

