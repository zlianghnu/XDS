import os,time,json


os.system('ps -ef | grep -E "test.py" | awk \'{print $2}\'| xargs kill -9')
open("res.txt",'w').write("{}")
from web3 import Web3
from web3.middleware import geth_poa_middleware
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)  

for threads in range(12,16,5):
	# os.system("cd /home/ubuntu/xds/XDS/chain && bash reset.sh  && nohup bash bc.sh &")
	# time.sleep(5)
	# j=370 {'code': -32000, 'message': 'oversized data'}
	for j in range(10, 361, 50):
		startBlock=w3.eth.get_block('latest')['number']
		print("batch"+ str(j)+ " start")	
		for i in range(0,threads):
			cmd='nohup python3 -u test.py '+str(i)+' '+ str(j)+' '+str(startBlock) + ' '+ str(threads) +' &	'
			print(cmd)
			os.system(cmd)
		# time.sleep(5*60)
		
		while True:
			path="../16nodes/thread"+str(threads)+".txt"
			if not os.path.exists(path):
			   open(path,"w+").write("{}")
			res=json.loads(open(path,"r").read())
			if str(j) in res:
				time.sleep(10)
				os.system('ps -ef | grep -E "test.py" | awk \'{print $2}\'| xargs kill -9')
				time.sleep(5)
				break
			time.sleep(1)


