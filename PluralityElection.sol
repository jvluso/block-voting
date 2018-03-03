pragma solidity ^0.4.16;
import "Election.sol";

// The most well known election type - each person gets one vote, and whoever gets the most votes wins
contract PluralityElection is Election {
  using PluralityBallot for PluralityBallot.ballot;
  mapping(address => PluralityBallot.ballot) public ballots;

  //vote for candidate v
  function vote(uint v) public {
    require(weights[msg.sender] > 0 && v<size);
    ballots[msg.sender].changeVote(v);
  }

  function PluralityElection(uint s) public {
    size = s;
    ballotType = "Plurality";
  }

  // gets the current winner
  function getWinner() public view returns (bytes32){
    uint[] memory counts = new uint[](size);
    for(uint i=0;i<addressList.length;i++){
      if(ballots[addressList[i]].voted){
        counts[ballots[addressList[i]].vote] += weights[addressList[i]];
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

library PluralityBallot {
  struct ballot{  // keeping track of if they voted or not is important for making sure that candidate 0
    bool voted;   // doesn't get all of the abstain votes
    uint vote;
  }
  function changeVote(ballot storage self,uint v) public {
    self.voted = true;
    self.vote = v;
  }
}
