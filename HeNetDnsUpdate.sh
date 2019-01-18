ip=`curl -4 -k https://api.ipify.org 2>/dev/null `
lip=`host -4 $1 ns1.he.net  | grep 'has address' |awk '{print $4}'`

if [  "$ip" != "$lip" ] 
then 
    echo Updating $1
    curl -4 -k "https://$1:$2@dyn.dns.he.net/nic/update?hostname=$1"
else
    echo "Ip hasn't changed ($ip)"
fi
