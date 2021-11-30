import sys,os
import time
import pprint
import random
import json
# from web3.providers.eth_tester import EthereumTesterProvider
from web3 import Web3
# from eth_tester import PyEVMBackend
import solcx
from solcx import compile_source,set_solc_version
from web3.middleware import geth_poa_middleware
# import _thread

solcx.install_solc('v0.5.17')
set_solc_version('v0.5.17')
# set_solc_version('v0.8.0')
# from multiprocessing import Process

def compile_source_file(file_path):
   with open(file_path, 'r') as f:
      source = f.read()

   return compile_source(source)

import psutil
def deploy_contract(w3, contract_interface):
    tx_hash = w3.eth.contract(
        abi=contract_interface['abi'],
        bytecode=contract_interface['bin']).constructor().transact({"from":w3.eth.accounts[0], 'gas': 30_000_000})

    # Greeter = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    # print(tx_receipt.contractAddress, flush=True)
    # address = w3.eth.get_transaction_receipt(tx_hash)['contractAddress']
    return tx_receipt.contractAddress
    # address


# w3 = Web3(EthereumTesterProvider(PyEVMBackend()))
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)  # 注入poa中间件

# print(sys.argv[1], "start", flush=True)

contract_source_path = './contracts/MetaData.sol'
compiled_sol = compile_source_file(contract_source_path)

contract_id, contract_interface = compiled_sol.popitem()



address = deploy_contract(w3, contract_interface)
# print(f'Deployed {contract_id} to: {address}\n', flush=True)

ctt = w3.eth.contract(address=address, abi=contract_interface["abi"])

accounts=w3.eth.accounts
# print(accounts, flush=True)
docAddr=accounts[0];
patientAddr=accounts[1];



starttime=time.time()
# print(sys.argv[1], "start transact", flush=True)
# def invokeSC():
cpuusage=0
cnt=0

batchsize=sys.argv[2]
for j in range(0,30):
   datas=[{
      "patientID":accounts[0],
      "department":"ophthalmology",
      "hash":"QmUsHKKdCquJPe7z69x5S1k5MJLhKNSjrhCYq5Dt2eLf6n",
      "size":2323,
      "status":1
   } for i in range(0,int(batchsize))]

   # gas_estimate = ctt.functions.writeMedRecordBatch(datas).estimateGas()
   # print(f'Gas estimate to transact with writeMedRecordBatch: {gas_estimate}', flush=True)
   tx_hash = ctt.functions.writeMedRecordBatch(datas).transact({"from":accounts[int(random.random())*1000%len(accounts)], 'gas': 30_000_000})
   tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
   usage=psutil.cpu_percent()
   print(sys.argv[1],sys.argv[2],"epoch",j, usage, len(str(datas)), flush=True)
   
   if j>5 and j<25:
      cpuusage=cpuusage+ usage
      cnt+=1

# starttime=time.time()
# ret = ctt.functions.queryMedRecord(accounts[0],"ophthalmology","20211125").call({"from":accounts[int(random.random())*1000%len(accounts)], 'gas': 30_000_000})
# print(ret,time.time()-starttime)
# exit()

r=int(sys.argv[1])/10
time.sleep(r)



endBlock=w3.eth.get_block('latest')['number']
tx=0
for i in range(int(sys.argv[3])+1, endBlock+1):
   block=w3.eth.getBlock(i)
   tx=tx+len(block.transactions)
# print("")
# print(sys.argv[1], "finish",time.time()-starttime," txs:",tx, "cpu usage:",cpuusage*1./cnt, flush=True)
path="../16nodes/thread"+str(sys.argv[4])+".txt"
if not os.path.exists(path):
   open(path,"w+").write("{}")

res=json.loads(open(path,"r").read())
tx2=0
if batchsize in res:
   tx2=res[batchsize]['txs']
tx=max(tx,tx2)

# if batchsize in res
costtime=time.time()-starttime-r
res[batchsize]={
   "time":costtime,
   "txs":tx,
   "cpu":cpuusage*1./cnt,
   "rps":tx*int(batchsize)/costtime
}
print(res)
open(path,"w+").write(json.dumps(res))
# for j in range(0,1):
#    # _thread.start_new_thread( invokeSC, () )
#    p = Process(target=invokeSC, args=())
#    p.start()
#    p.join()   





