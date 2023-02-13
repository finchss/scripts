#!/bin/bash

mbmodel=$(dmidecode  -t 2 |grep Produ |cut -f 2 -d : | sed 's/^\ //' )
mbman=$(dmidecode  -t 2 |grep Man |cut -f 2 -d : | sed 's/^\ //' )
memspeed=$(dmidecode --type 17|grep 'Configured Memory Speed:'|grep MT |grep -E -o '[0-9]{1,5}' |head -1)
memtype=$(dmidecode -t 17 |grep Part |cut -f 2 -d :|sed 's/\ //g' |head -1)
proc=$(cat /proc/cpuinfo  |grep 'model name' |head -1  |cut -f 2 -d : |sed 's/Processor//g' |sed 's/^\ //g')
tf="linux-6.2-rc7.tar"
zstd="zstd"
zv=$(${zstd} -Version | grep -o -E 'v[0-9\.]{1,6}')
howmany=10



if [ ! -f ${tf} ];  then
    curl -L https://git.kernel.org/torvalds/t/${tf}.gz   | gzip -d > ${tf}
fi
if [ ! -f res ] ; then
    for ((i=1;i<=${howmany};i++))
    do
    	cat  ${tf}  | /usr/bin/time -v ${zstd} -19 -T0 -c   >/dev/null 2> /tmp/_b.txt
    	r=$(cat /tmp/_b.txt  |grep Elapsed |awk '{print $8}')
        echo "Completed $i of ${howmany} in $r"
    	echo $r >> res
    	rm -f /tmp/_b.txt
    done
fi


rm -f /tmp/_b.txt
for l in `cat res`; do 
    m=`echo $l|cut -f 1 -d : `;s=`echo $l|cut -f 2 -d : |cut -f 1 -d . `;ms=`echo $l|cut -f 2 -d : |cut -f 2 -d . `;
    let t=$(expr $m + 0)*60*100+$(expr $s + 0)*100+$(expr $ms + 0) 
    echo $t >> /tmp/_b.txt
done 

s=0
for d in `cat /tmp/_b.txt |grep '[0-9]'|sort -n |tail -9 |head -8` ;do
   let s=$s+$d
done
let s=$s/8
echo \"$(hostname)\",\"$s\",\"$zv\",\"${proc}\",\"${memtype}\",\"${memspeed}\",\"${mbman}\",\"${mbmodel}\"




