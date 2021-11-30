echo "">nohup.out
curl http://localhost:8544/api/clearHistoryBlocks 
# ps -ef | grep -E "truffle|updateDB.js" | awk '{print $2}' | xargs kill -9
ps -ef | grep -E "test.py" | awk '{print $2}' | xargs kill -9
for ((i=0; i<20; i=i+1))
do
	PYTHONUNBUFFERED=TRUE
	nohup python3 -u test.py $((i)) &	
done

