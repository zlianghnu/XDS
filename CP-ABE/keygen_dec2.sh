echo ""> keygen2.log
echo ""> dec2.log
for ((i=0; i<=1000000; i=i+50))
do
	today=`date -d "+$((i)) day " +%Y%m%d`
	future=`date -d "+$((i+30)) day " +%Y%m%d`
	
	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		cpabe-keygen -o key2$future pub_key master_key department1 'X = '$future
	done
	endtime=`date +%s%N`/1000000

	echo  "($today,"$(($((endtime-starttime))/10))")" >> keygen2.log

	starttime=`date +%s%N`/1000000
	for ((n=1; n<=10; n=n+1))
	do		
		cpabe-dec pub_key key2$future -k diagnose2.cpabe.$today -o bb
	done
	endtime=`date +%s%N`/1000000

	echo  "($today,"$(($((endtime-starttime))/10))")" >> dec2.log
	



done