
echo ""> enc2.log
for ((i=0; i<=1000000; i=i+50))
do
	today=`date -d "+$((i)) day " +%Y%m%d`
	future=`date -d "+$((i+90)) day " +%Y%m%d`
	# echo $today
	
	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		policy="H1 or (1 of (department1, department2, department3, department4, department5, department6,department7, department8, department9, department10, department11, department12, department13, department14, department15, department16,department17, department18, department19, department20, department21, department22, department23, department24, department25, department26,department27, department28, department29, department30) and (X < "$future" and X > "$today"))"			
		cpabe-enc pub_key -k diagnose2 "$policy" -o diagnose2.cpabe.$today
	done
	endtime=`date +%s%N`/1000000

	echo  "($i, $today,"$(($((endtime-starttime))/10))")" >> enc2.log

done


# cpabe-keygen -o key20211220 pub_key master_key ophthalmology 'X = 20211220'

# cpabe-dec pub_key key20211220 -k diagnose.cpabe.20211208 -o aa
