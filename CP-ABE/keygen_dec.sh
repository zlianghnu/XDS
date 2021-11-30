echo ""> keygen.log
echo ""> dec.log
for ((i=0; i<=1000000; i=i+50))
do
	today=`date -d "+$((i)) day " +%Y%m%d`
	future=`date -d "+$((i+30)) day " +%Y%m%d`
	
	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		cpabe-keygen -o key$future pub_key master_key ophthalmology 'X = '$future
	done
	endtime=`date +%s%N`/1000000

	echo  "($today,"$(($((endtime-starttime))/10))")" >> keygen.log

	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		cpabe-dec pub_key key$future -k diagnose.cpabe.$today -o aa
	done
	endtime=`date +%s%N`/1000000

	echo  "($today,"$(($((endtime-starttime))/10))")" >> dec.log
	



done