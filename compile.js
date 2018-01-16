Web3 = require('web3');
repl=require('repl');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs')
code = {
  'Voting.sol': fs.readFileSync('Voting.sol').toString(),
  'Hello.sol': fs.readFileSync('Hello.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
abiDefinition = JSON.parse(compiledCode.contracts['Voting.sol:Voting'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts['Voting.sol:Voting'].bytecode;
deployedContract = VotingContract.new(['hello','world'],
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
