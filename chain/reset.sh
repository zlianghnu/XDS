for ((i=1; i<20; i=i+1))
do
	datadir=data$i
	rm -rf $datadir
done
rm -rf data0/geth/*
rm -rf data0/history