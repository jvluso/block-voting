Web3 = require('web3');
repl=require('repl');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs')
code = {
  'Election.sol': fs.readFileSync('Election.sol').toString(),
  'YesNoElection.sol': fs.readFileSync('YesNoElection.sol').toString(),
  'Hello.sol': fs.readFileSync('Hello.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
console.log(compiledCode.errors);
abiDefinition = JSON.parse(compiledCode.contracts['Hello.sol:Hello'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts['Hello.sol:Hello'].bytecode;
deployedContract = VotingContract.new('hello',
    {data: byteCode, from: web3.eth.accounts[0], gas: 4700000},
    function (err,contract){
      if(!err){
        if(!contract.address){
          console.log(contract.transactionHash);
        }else{
          contract.testEvent(function (err, response) {
            console.log("testEvent");
          });
            console.log(contract.address);
          repl.start(prompt='> ',stream=process.stdin);
        }
      }
    });

console.log("contractInstance = VotingContract.at(deployedContract.address);");
