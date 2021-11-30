/**
 * Should be called to get hex representation (prefixed by 0x) of ascii string
 *
 * @method asciiToHex
 * @param {String} str
 * @returns {String} hex representation of input string
 */
const asciiToHex = function (str) {
    if (!str)
        return "0x00";
    var hex = "";
    for (var i = 0; i < str.length; i++) {
        var code = str.charCodeAt(i);
        var n = code.toString(16);
        hex += n.length < 2 ? '0' + n : n;
    }

    return "0x" + hex;
};

/**
 * Should be called to get hex representation (prefixed by 0x) of decimal number string
 *
 * @method decToHex
 * @param {String} str
 * @returns {String} hex representation of input string
 */
const decToHex = function (str) {
    var dec = str.toString().split(''), sum = [], hex = ["0x"], i, s
    while (dec.length) {
        s = 1 * dec.shift()
        for (i = 0; s || i < sum.length; i++) {
            s += (sum[i] || 0) * 10
            sum[i] = s % 16
            s = (s - sum[i]) / 16
        }
    }
    while (sum.length) {
        hex.push(sum.pop().toString(16))
    }
    return hex.join('')
}

var EC = require('elliptic').ec;
var curve = new EC('secp256k1');

/**
 * Should be called to get public key associated with input private key using 'Secp256k1' elliptic curve
 *
 * @method pri2pub
 * @param {String} prikey input private key
 * @returns {String} hex representation of pubkey.x + pubkey.y
 */
const pri2pub = function(prikey) {
    if(prikey.startsWith('0x')){
        prikey = prikey.slice(2);
    }
    var key = curve.keyFromPrivate(prikey)

    var pubPoint = key.getPublic();
    var x = pubPoint.getX().toString('hex').padStart(64, '0');
    var y = pubPoint.getY().toString('hex').padStart(64, '0');

    return "0x" + x + y;
};
// const publicKeyToAddress = require('ethereum-public-key-to-address')
const privateKeyToAddress = require('ethereum-private-key-to-address')

 
/**
 * Should be called to create an account according to input private key using input web3 instance,
 * this will add the new created account into current network
 *
 * @method createAccount
 * @param {Web3} prikey input web3 instance
 * @param {String} prikey input private key
 * @returns {Promise} result is an object of account
 */
async function createAccount(web3, prikey) {
    const pw = "123"
    const accounts = await web3.eth.getAccounts();
    // console.log(prikey,accounts,privateKeyToAddress(prikey));
    let address = privateKeyToAddress(prikey)
    var found=false;
    for (var i = 0; i < accounts.length; i++) {
        if(address.toLowerCase() == accounts[i].toLowerCase()){            
            found=true;
            break;        
        }
    }
    if(found==false){
        address = await web3.eth.personal.importRawKey(prikey, pw);        
        await web3.eth.sendTransaction({
            from: accounts[0],
            to: address,
            value: web3.utils.toWei("1", "ether")
        });    
    }
    await web3.eth.personal.unlockAccount(address, pw, 600);         
    
    
    const balance = await web3.eth.getBalance(address);
    return Promise.resolve({
        pubkey: pri2pub(prikey),
        address,
        prikey,
        balance
    })
}


const path = require('path');
/**
 * Should be called to get file name without extension
 * 
 * @method scriptName
 * @param {String} name __filename
 * @returns {String} filename
 */
const scriptName = function (name) {
    return path.basename(name).split(".")[0];
} 

const account_prikeys = [
    "6e2b3ce976879164a439e2fb5dea9bc57a6487f0ff8f7ac9c9e69f9754605637",
    "fbfe724302dacccef8bda969dd702ea8c0ea2a73bb7f82dcd25821835361acd0",
    "f2692ca6047951f7167a007bf4ce557c23f8f0f0617dbe88ea0dac3e5503ea55",
    "90f95f032899476b192656c4d54c906b3c78351537e03b75a8960490c8828921",
    "06635ba3cbca9dc01cffee2e5745ea93c1fb4ba7ecea7bca43d8b819618ffc03",
    "0d057fbb82fb9152d9c42eaaf543021acfe539912da7f9de785ef7643a50cca4",
    "4465cb73185cf5f0c51907fe3a0685239ecbe43a9344ba37ac6602bfe6ce6371",
    "7accfce45e618087730e58f48e2c94b41caf5fc6a43fcf31eea6acc999306a6f",
    "6cba3850633b8d2baa157c28d17aa55f370b9a7c31df2e84ae3c84fb8870ac8c",
]

module.exports = {
    prikeys: account_prikeys,
    testData: {
        doctorIndex: 2,
        patientIndex: 3,
        userIndex: 4,
        uint256_msg: 666,
        device: {
            uint32_id: 2,
            string_name: "gtx3090",
            uint32_price: 15000
        }
    },
    pri2pubhex: pri2pub,
    dec2hex: decToHex,
    str2bytes: asciiToHex,
    createAccount,
    scriptName
};