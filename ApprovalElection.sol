pragma solidity ^0.4.16;
import "Election.sol";

/// @title choose a result by plurality vote
contract ApprovalElection is Election {
  using ApprovalBallot for ApprovalBallot.ballot;
  mapping(address => ApprovalBallot.ballot) public ballots;


  function changeVote(uint c, bool v) public {
    require(weights[msg.sender] > 0 && c<size);
    ballots[msg.sender].changeVote(c,v);
  }


  function activateVote() public {
    require(weights[msg.sender] > 0);
    ballots[msg.sender].activateVote();
  }


  function ApprovalElection(uint s) public {
    size = s;
    ballotType = "Approval";
  }
  function getWinner() public view returns (bytes32){
    uint[] memory counts = new uint[](size);
    for(uint i=0;i<addressList.length;i++){
      if(ballots[addressList[i]].voted){
        for(uint j=0;j<size;j++){
          if(ballots[addressList[i]].vote[j]){
            counts[j] += weights[addressList[i]];
          }
        }
      }
    }
    uint winner;
    uint winningWeight = 0;
    for(i=0;i<size;i++){
      if(counts[i]>winningWeight){
        winner=i;
        winningWeight=counts[i];
      }
    }
    return candidates[winner];
  }
}

library ApprovalBallot {
  struct ballot{
    bool voted;
    mapping(uint => bool) vote;
  }
  function changeVote(ballot storage self,uint c,bool v) public {
    self.vote[c] = v;
  }
  function activateVote(ballot storage self) public {
    self.voted = true;
  }
}
