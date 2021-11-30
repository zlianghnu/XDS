const MetaData = artifacts.require("MetaData.sol");
const utils = require("../utils")

const testData = utils.testData;
contract('MetaData', (accounts) => {
    it(`writeMedRecord`, async () => {
        // prepareAccounts
        // for (var i = 0; i < utils.prikeys.length; i++) {
        //     let d=await utils.createAccount(web3, utils.prikeys[i]);      
        //     // console.log(d) ;
        // }
        const contractInstance = await MetaData.deployed();
        const docAddr=accounts[0];
        // console.log(accounts);
        // const doctor = await utils.createAccount(web3, utils.prikeys[testData.doctorIndex]);
        // await web3.eth.sendTransaction({
        //     from: accounts[0],
        //     to: docAddr,
        //     value: web3.utils.toWei("10000", "ether")
        // });    
        
        // const patient = await utils.createAccount(web3, utils.prikeys[testData.patientIndex]);

        var t1 = new Date().getTime();
        // ==============================writeMedRecordBatch
        // console.log(typeof(patient.address));
        var epoch=50;
        var batch=30;
        for (var j = 0; j < epoch; j++) {
            var datas=[];
            
            for (var i = 0; i < batch; i++) {
                
                datas.push({
                    "patientID":accounts[i%accounts.length],
                    "department":"ophthalmology"+i,
                    "hash":"QmUsHKKdCquJPe7z69x5S1k5MJLhKNSjrhCYq5Dt2eLf6n",
                    "size":585,
                    "status":1                
                });            
            }
            // console.log(datas);
            let d = await contractInstance.writeMedRecordBatch(datas,{
                "from": docAddr
            });
            var t2 = new Date().getTime();
            console.log("batch size:"+batch,"epoch:"+j,batch*(j+1)*1000/(t2-t1));
        }
        var t2 = new Date().getTime();
        console.log('epoch:'+epoch+' batch:'+batch, "cost:"+(t2-t1), batch*epoch*1000/(t2 - t1));



        // ==============================writeMedRecord        
        
        // console.log(contractInstance.methods.testGetBlockTime);
        // for (var i = 0; i < 5; i++) {
        //     data={
        //             // "patientID":accounts[i%accounts.length],
        //             // "department":"ophthalmology"+i,
        //         "hash":"QmUsHKKdCquJPe7z69x5S1k5MJLhKNSjrhCYq5Dt2eLf6n",
        //         "size":585,
        //         "status":1,
        //         "timestamp":1637210595,
        //         "docId":doctor.address,
        //     }
        //     let d = await contractInstance.writeMedRecord(patient.address, "ophthalmology", data,{
        //         "from": doctor.address
        //     });
        //     console.log(d)
        // }

        // ==============================writeMedRecord                
        // let d2 =await contractInstance.testGetBlockTime();
        // console.log(d2);
        
        // ==============================queryMedRecord                
        // let d1 =await contractInstance.queryMedRecord(patient.address, "ophthalmology","20211118");
        // console.log(d1);
        
    });

});