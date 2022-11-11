IFS='
'
options=(Ciphers PubkeyAcceptedKeyTypes HostbasedKeyTypes HostKeyAlgorithms KexAlgorithms MACs PubkeyAcceptedKeyTypes )
for o in ${options[@]} ;do
	dt=""
	for l in `ssh -Q $o` ; do
		dt=$dt$l,
	done
	echo $o $dt
done




