<?php

	$s="http://192.168.0.18";



	while(1) {
		$ch=curl_init($s."/eSCL/ScanJobs");
		curl_setopt($ch,CURLOPT_POST,1);
		curl_setopt($ch,CURLOPT_VERBOSE,1);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:'));
		curl_setopt($ch,CURLOPT_POSTFIELDS,'<?xml version="1.0" encoding="UTF-8"?><scan:ScanSettings xmlns:scan="http://schemas.hp.com/imaging/escl/2011/05/03" xmlns:pwg="http://www.pwg.org/schemas/2010/12/sm"><pwg:Version>2.0</pwg:Version><scan:Intent>Photo</scan:Intent><pwg:ScanRegions><pwg:ScanRegion><pwg:Height>3508</pwg:Height><pwg:ContentRegionUnits>escl:ThreeHundredthsOfInches</pwg:ContentRegionUnits><pwg:Width>2550</pwg:Width><pwg:XOffset>0</pwg:XOffset><pwg:YOffset>0</pwg:YOffset></pwg:ScanRegion></pwg:ScanRegions><pwg:ContentType>Photo</pwg:ContentType><pwg:InputSource>Platen</pwg:InputSource><scan:XResolution>200</scan:XResolution><scan:YResolution>200</scan:YResolution><scan:ColorMode>RGB24</scan:ColorMode><scan:Duplex>false</scan:Duplex><MultipickDetection>false</MultipickDetection><ShowMultipickResolveDialog>false</ShowMultipickResolveDialog><MultipickExclusionLength>0</MultipickExclusionLength><AutoCrop>true</AutoCrop></scan:ScanSettings>');
		//curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLINFO_HEADER_OUT, true);
		curl_setopt($ch, CURLOPT_HEADER, true);
		$x=curl_exec($ch);


		$info=curl_getinfo($ch,CURLINFO_HTTP_CODE);
		if ($info==201) {
			list($inHeaders, $content) = explode("\r\n\r\n", $x, 2);

			$headers=explode("\r\n",$inHeaders);
			var_dump($headers);
			foreach($headers as $k=>$v) {
				if(strstr($v,"Location:")) {
					list($none,$Job)=explode(" ",$v);
					echo "Job is ";
					var_dump($Job);
					while(1) {
						curl_setopt($ch,CURLINFO_HEADER_OUT, false);
						curl_setopt($ch,CURLOPT_HEADER, false);
						curl_setopt($ch,CURLOPT_VERBOSE,1);
						curl_setopt($ch,CURLOPT_POST,0);
						curl_setopt($ch,CURLOPT_URL,$Job."/NextDocument");
						$r=curl_exec($ch);
						$info=curl_getinfo($ch,CURLINFO_HTTP_CODE);
						if($info==200) {
							file_put_contents($argv[1],$r);
							die();
						}
						else 
							usleep(500000);
					}
				}
			}
		}
		else {
			echo "Code is $info\n";
			sleep(5);
		}
	}
		


?>