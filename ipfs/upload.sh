
for ((i=1; i<=100; i=i+5))
do	
	# rm testfile$i	
	random=$(($(date +%s%N)/1000000))
	for ((j=0; j<1024*i; j=j+1))
	do	
		echo "$((random))51111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111">> testfile$i
	done
	echo "start,$i"
	start=$(($(date +%s%N)/1000000))	
	ipfs add testfile$i
	end=$(($(date +%s%N)/1000000))
	echo "time cost: $((end -start))"
	sleep 5s
	rm testfile$i
done