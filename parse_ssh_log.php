<?php
	if($argc==1) 
		$fp=fopen("php://stdin","r");
	else 
		$fp=fopen($argv[1],"r");
	if(!$fp)
		die("Cannot open input strean");
	
	while(!feof($fp)) {
		$s=fgets($fp);
		//echo $s."\n";
		if(!strstr($s,"password")) continue;
		$x=explode(" from ",$s);
		$y=explode(" ",$x[0]);
		$user=$y[count($y)-1];
		//echo $x[1]."\n";
		list($none,$x)=explode("password: ",$x[1]);
		$x=substr($x,0,strlen($x)-2);
		echo"$user:$x\n";
	//	echo $user."\n";
	}

?>