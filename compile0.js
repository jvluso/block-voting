Web3 = require('web3');
repl=require('repl');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs')
code = {
  'Reference.sol': fs.readFileSync('Reference.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
console.log(compiledCode.errors);
abiDefinition = JSON.parse(compiledCode.contracts['Reference.sol:Reference'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts['Reference.sol:Reference'].bytecode;
deployedContract = VotingContract.new(
    {data: byteCode, from: web3.eth.accounts[0], gas: 4700000},
    function (err,contract){
      if(!err){
        if(!contract.address){
          console.log(contract.transactionHash);
        }else{
            console.log(contract.address);
        }
      }
    });

console.log("contractInstance = VotingContract.at(deployedContract.address);");
