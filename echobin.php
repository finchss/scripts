<?php
	if($argc==2)
		$data=file_get_contents($argv[1]);
	else 
		$data=stream_get_contents(STDIN);

	$data=gzencode($data,9);
	echo 'echo -n -e "';  
	for($i=0;$i<strlen($data);$i++) {
		echo "\x".str_pad(dechex(ord($data[$i])),2,'0',STR_PAD_LEFT);
	}
	echo '" | gzip -d > out'."\n";


?>