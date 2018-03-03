pragma solidity ^0.4.16;

// Election interface for Voting - this is the base interface that all election types will implement
// Some functions will be moved out to the implementations eventually.
contract Election {
  bytes32 public electionName; // a name for the individual election - this should be human readable
  bytes32 public ballotType;   // the ballot type for the election - the following ballot types exist
                                  //Approval
                                  //Plurality


  bytes32[] public candidates;  // the list of possible winners
  uint public size;          // the maximum number of winners



  mapping(address => uint) public weights; // the list of weights of the voters - this may eventually be moved to a minime token
  address[] public addressList; // an itterable list of voters



  // adds the candidate to the election before voting begins.
  function addCandidate(bytes32 name) public {
    require(candidates.length<size);
    candidates.push(name);
  }

  // in this implementation, voters can only be added before voting begins
  // each voter has equal weight
  function addVoter(address v) public {
    require(candidates.length<size);
    weights[v] = 1;
    addressList.push(v);
  }

  // sets the name of the election
  function setName(bytes32 n) public {
    require(candidates.length<size);
    electionName = n;
  }

  // single winner elections can return the winner at any time. the winner can change as voters vote
  function getWinner() public view returns (bytes32);

  // this is a utility function for the ui to use.
  function getCandidate(uint num) public view returns (bytes32,uint){
    return (candidates[num],num);
  }
}
