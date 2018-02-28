Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
fs = require('fs');
accounts = web3.eth.accounts;
code = {
  'Election.sol': fs.readFileSync('Election.sol').toString(),
  'ApprovalElection.sol': fs.readFileSync('ApprovalElection.sol').toString(),
  'Reference.sol': fs.readFileSync('Reference.sol').toString()
};
solc = require('solc');
compiledCode = solc.compile({sources: code}, 1);
if('errors' in compiledCode){
  for(i=0;i<compiledCode.errors.length;i++){
    console.log(compiledCode.errors[i]);
  }
}
ReferenceAbi = JSON.parse(compiledCode.contracts['Reference.sol:Reference'].interface);
ReferenceContract = web3.eth.contract(ReferenceAbi);
ReferenceInstance = ReferenceContract.at('0x1b26a4ed054c8ca4252008f7b9cdfc077a06216e');
libraryAbi = JSON.parse(compiledCode.contracts['ApprovalElection.sol:ApprovalBallot'].interface);
LibraryContract = web3.eth.contract(libraryAbi);
contractAbi = JSON.parse(compiledCode.contracts['ApprovalElection.sol:ApprovalElection'].interface);
TestContract = web3.eth.contract(contractAbi);
libraryByteCode = compiledCode.contracts['ApprovalElection.sol:ApprovalBallot'].bytecode;
var testContract;
deployedLibrary = LibraryContract.new(
    {data: libraryByteCode, from: accounts[0], gas: 4700000},
    function (err,contract){
      if(!err){
        if(!contract.address){
          console.log(contract.transactionHash);
        }else{
          byteCode = compiledCode.contracts['ApprovalElection.sol:ApprovalElection'].bytecode;
          console.log(byteCode)
          testByteCode = byteCode.replace(/_+ApprovalElection.sol:ApprovalBallot_+/g,contract.address.replace("0x",""));
          console.log("bytecode")
          console.log(testByteCode);
          deployedContract = TestContract.new(3,
              {data: testByteCode, from: accounts[0], gas: 47000000},
              function (err,contract){
                if(!err){
                  if(!contract.address){
                    console.log(contract.transactionHash);
                  }else{
                    testContract=TestContract.at(deployedContract.address);
                    console.log("deployed")
                    console.log(contract.address);

                    ReferenceInstance.setRecentElection(contract.address,{from:accounts[0],gas:4700000});
                    contract.setName("who",{from: accounts[0],gas: 4700000});
                    contract.addVoter(accounts[0],{from: accounts[0],gas: 4700000});
                    contract.addVoter(accounts[1],{from: accounts[0],gas: 4700000});
                    contract.addVoter(accounts[2],{from: accounts[0],gas: 4700000});
                    contract.addCandidate("Merkle",{from:accounts[0],gas:4700000});
                    contract.addCandidate("Merkel",{from:accounts[0],gas:4700000});
                    contract.addCandidate("Corbryn",{from:accounts[0],gas:4700000});
                    repl=require('repl').start('> ');
                    require('repl.history')(repl,process.env.HOME + '/.node_history');
                  }
                }
              });
          console.log(contract.address);
        }
      }
    });
