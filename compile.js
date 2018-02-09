Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8500"));
fs = require('fs');
accounts = web3.eth.accounts;
code = {
  'owned.sol': fs.readFileSync('owned.sol').toString(),
  'Election.sol': fs.readFileSync('Election.sol').toString(),
  'PluralityElection.sol': fs.readFileSync('PluralityElection.sol').toString(),
  'Voting.sol': fs.readFileSync('Voting.sol').toString(),
  'YesNoElection.sol': fs.readFileSync('YesNoElection.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
if('errors' in compiledCode){
  for(i=0;i<compiledCode.errors.length;i++){
    console.log(compiledCode.errors[i]);
  }
}
PluralityElectionAbi = JSON.parse(compiledCode.contracts['PluralityElection.sol:PluralityElection'].interface);
VotingContract = web3.eth.contract(PluralityElectionAbi);
PluralityBallotAbi = JSON.parse(compiledCode.contracts['PluralityElection.sol:PluralityBallot'].interface);
BallotContract = web3.eth.contract(PluralityBallotAbi);
ballots = {};
byteCode = compiledCode.contracts['PluralityElection.sol:PluralityElection'].bytecode;
deployedContract = VotingContract.new(3,
    {data: byteCode, from: accounts[0], gas: 4700000},
    function (err,contract){
      if(!err){
        if(!contract.address){
          console.log(contract.transactionHash);
        }else{
          contract.BallotCreated(function (err, response) {
            console.log(response);
            ballots[response.args.index] = BallotContract.at(response.args.ballot);
          });
          console.log(contract.address);
        }
      }
    });

console.log("contractInstance = VotingContract.at(deployedContract.address);");

repl=require('repl').start('> ');
require('repl.history')(repl,process.env.HOME + '/.node_history');
