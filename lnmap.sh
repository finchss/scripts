url=`curl https://nmap.org/download.html |grep 'https://nmap.org/dist/nmap-[0-9\.]\{1,10\}.tar.bz2' -o`
curl $url > nmap.tar.bz2
d=`echo $url |grep -o 'nmap\-[0-9]\{1,2\}\.[0-9]\{1,2\}'`
tar -xvjf nmap.tar.bz2
if [ ! -d $d ] 
then
    echo "Blah"
    exit
fi
cd  $d
rm -rf /usr/local/nmap
./configure --prefix=/usr/local/nmap
make -j 4
make install

