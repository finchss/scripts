#!/usr/bin/php
<?php

    $i=$argv[1];
    $i=str_replace("nothing://","",$i);
    $a=explode("@",$i);
    //var_dump($a);
    $up=$a[0];
    for($i=1;$i<count($a)-1;$i++) {
	if($a[$i]=="")
	    $up.="@";
	else $up.="@".$a[$i];
    }
    $ipp=str_replace("/","",str_replace("\n","",$a[count($a)-1]));
    echo $up."\n";
    echo $ipp."\n";
    list($ip,$port)=explode(":",$ipp);
    list($user,$pass)=explode(":",$up);
    echo $ip."\n";
    echo $port."\n";
    echo $user."\n";
    echo $pass."\n";
    $x=mt_rand(0,9999999);

    $pass=str_replace('$','\$',$pass);
    $pass=str_replace('"','\"',$pass);
    $pass=str_replace('`','\`',$pass);

    file_put_contents("/tmp/cmd$x.sh","#!/bin/bash\n. torsocks on\nsshpass -p \"$pass\" ssh -o StrictHostKeyChecking=accept-new -v $user@$ip -p $port \n");
    chmod("/tmp/cmd$x.sh",0755);
    system("terminator -e /tmp/cmd$x.sh");
    system("rm -f /tmp/cmd$x.sh");
?>