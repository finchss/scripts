#!/usr/bin/php
<?php

 if($argc==2)
       $data=file_get_contents($argv[1]);
 else
       $data=stream_get_contents(STDIN);

    $d=chunk_split($data,2);
    $d=explode("\n",$d);
    foreach($d as $k=>$v) {
	if(strlen($v)>0)  {
    	    $y=hexdec($v);
	echo chr($y);
    }
    }
?>
