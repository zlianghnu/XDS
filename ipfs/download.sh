cat cids | while read line
do
    start=$(($(date +%s%N)/1000000))	
	ipfs get $line
	end=$(($(date +%s%N)/1000000))
	echo "time cost: $((end -start))"
done

