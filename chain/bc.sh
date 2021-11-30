# the first terminal
# bootnode -genkey bootnode.key
ps -ef | grep -E "geth|bootnode" | awk '{print $2}' | xargs kill -9

nohup bootnode -nodekey bootnode.key &
 
# the second terminal
# echo ""> bc.log
for ((i=1; i<16; i=i+1))
do
	datadir=data$i
	

	if [ "$(ls -A $datadir)" ]; then
	     echo "$datadir is not Empty"
	else
	    echo "$datadir is Empty, generate new account"
	    geth --datadir=$datadir init Genesis.json
	    geth --datadir $datadir account new --password pwd  
	fi

	key=`geth --datadir=$datadir account list|head -n1|perl -ne '/([a-f0-9]{40})/ && print $1'`
	cmd="geth -networkid 110813 -datadir $datadir --port="$((5555+i))" -http -http.api net,eth,web3,personal,admin -http.port $((8545+i)) --http --http.corsdomain "*"  --bootnodes "enode://8223674acaae67eaa7b05f40b16037f003f660a4dee5dad7115d310830d1cfcec6ed475183aae5f185a404607d0c1c8300e1b5efa7d18b8725622fcdb6dc0d52@127.0.0.1:30301" --allow-insecure-unlock --mine --miner.threads 1 --unlock=$key  --password pwd -http.addr 127.0.0.1 "
	echo $cmd
	nohup geth -networkid 110813 -datadir $datadir --port="$((5555+i))" -http -http.api net,eth,web3,personal,admin -http.port $((8545+i)) --http --http.corsdomain "*"  --bootnodes "enode://8223674acaae67eaa7b05f40b16037f003f660a4dee5dad7115d310830d1cfcec6ed475183aae5f185a404607d0c1c8300e1b5efa7d18b8725622fcdb6dc0d52@127.0.0.1:30301" --allow-insecure-unlock --mine --miner.threads 1 --unlock=$key  --password pwd -http.addr 127.0.0.1  & 
	
done


# change to PFeK wireless network
datadir=data0
if [ "$(ls -A $datadir/geth/)" ]; then
	echo "$datadir/geth is not Empty"
else	
	echo "init data0======================"
	geth --datadir $datadir init Genesis.json	
fi

i=0
key=`geth --datadir=$datadir account list|head -n1|perl -ne '/([a-f0-9]{40})/ && print $1'`
geth -networkid 110813 -datadir $datadir --port="$((5555+i))" -http -http.api net,eth,web3,personal,admin -http.port $((8545+i)) --http --http.corsdomain "*"  --bootnodes "enode://8223674acaae67eaa7b05f40b16037f003f660a4dee5dad7115d310830d1cfcec6ed475183aae5f185a404607d0c1c8300e1b5efa7d18b8725622fcdb6dc0d52@127.0.0.1:30301" --allow-insecure-unlock --mine --miner.threads 1 --unlock=$key  --password pwd -http.addr 127.0.0.1 console 2