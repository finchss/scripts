#bld="/dev/shm/mtor"
bld="/var/lib/mtor"


mkdir ${bld} >/dev/null 2>/dev/null

export DEBIAN_FRONTEND=noninteractive
if [ ! -f  /usr/sbin/tor ] 
then 
    echo "Update.."
    apt-get update >/dev/null 2>/dev/null
    echo "Install.."
    apt-get install -y tor tor-geoipdb psmisc libcurl3 2>/dev/null >/dev/null
fi
if [ ! -f /usr/bin/killall ]
then
    apt-get update >/dev/null 2>/dev/null
    apt-get install -y psmisc
fi
killall -9 tor >/dev/null






echo -n "Starting $1 tor servers, please wait "
for ((i=1;i<=$1;i++))
do
	echo -n '*'
	if [ ! -d $bld/tor$i ] 
	then
	    mkdir $bld/tor$i
	fi

    
	if [ ! -d /var/run/tor$i ] 
	then 
	    mkdir /var/run/tor$i
	fi

	chown debian-tor.debian-tor $bld/tor$i
	chown debian-tor.debian-tor /var/run/tor$i

	chmod 0700 $bld/tor$i/
	chmod 0700 /var/run/tor$i/


	cat > $bld/tor-service-defaults-torrc$i  <<EOF
DataDirectory $bld/tor$i
PidFile /var/run/tor$i/tor.pid
RunAsDaemon 0
User debian-tor
ControlSocket /var/run/tor$i/control
ControlSocketsGroupWritable 1
CookieAuthentication 1
CookieAuthFileGroupReadable 1
CookieAuthFile /var/run/tor$i/control.authcookie

EOF

	let "port=9050+$i"
	echo "SOCKSPort $port" > $bld/torrc$i
	if [ -z ${tcountry} ]
	then 
	    true; 
	else 
	    echo "EntryNodes ${tcountry}" >> $bld/torrc$i

	fi


	/usr/bin/tor --defaults-torrc $bld/tor-service-defaults-torrc$i -f $bld/torrc$i --RunAsDaemon 1 >/dev/null 2>/dev/null
	echo -n -e '\b'.
done
echo " Done !"
count=`ps axf|grep tor |grep -v grep |wc -l`
echo $count tor servers running 


