
echo ""> enc.log
for ((i=0; i<=1000000; i=i+50))
do
	today=`date -d "+$((i)) day " +%Y%m%d`
	future=`date -d "+$((i+90)) day " +%Y%m%d`
	# echo $today
	
	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		policy="H1 or (ophthalmology and (X < "$future" and X > "$today"))"			
		cpabe-enc pub_key -k diagnose "$policy" -o diagnose.cpabe.$today
	done
	endtime=`date +%s%N`/1000000

	echo  "($i, $today,"$(($((endtime-starttime))/10))")" >> enc.log

done


# cpabe-keygen -o key20211220 pub_key master_key ophthalmology 'X = 20211220'

# cpabe-dec pub_key key20211220 -k diagnose.cpabe.20211208 -o aa
