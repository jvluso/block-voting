Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs');
accounts = web3.eth.accounts;
code = {
  'Voting.sol': fs.readFileSync('Voting.sol').toString(),
  'Election.sol': fs.readFileSync('Election.sol').toString(),
  'YesNoElection.sol': fs.readFileSync('YesNoElection.sol').toString(),
  'Hello.sol': fs.readFileSync('Hello.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
abiDefinition = JSON.parse(compiledCode.contracts['Voting.sol:Voting'].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts['Voting.sol:Voting'].bytecode;
deployedContract = VotingContract.new(
    {data: byteCode, from: accounts[0], gas: 4700000},
    function (err,contract){
      if(!err){
        if(!contract.address){
          console.log(contract.transactionHash);
        }else{
          contract.testEvent(function (err, response) {
            console.log("testEvent");
          });
          contract.giveRightToVote(accounts[1],{from : accounts[0]});
          contract.giveRightToVote(accounts[2],{from : accounts[0]});
          contract.giveRightToVote(accounts[3],{from : accounts[0]});
          contract.giveRightToVote(accounts[4],{from : accounts[0]});
          contract.giveRightToVote(accounts[5],{from : accounts[0]});
          console.log(contract.address);
        }
      }
    });

console.log("contractInstance = VotingContract.at(deployedContract.address);");

repl=require('repl').start('> ');
require('repl.history')(repl,process.env.HOME + '/.node_history');
