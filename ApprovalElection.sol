pragma solidity ^0.4.16;
import "Election.sol";

// In an Approval election, you can vote for or against as many candidates as you want
// The candidate with the most votes wins
contract ApprovalElection is Election {
  using ApprovalBallot for ApprovalBallot.ballot;
  mapping(address => ApprovalBallot.ballot) public ballots;


  // sets the sender's vote for candidate c to be in favor if v, or against if not
  function changeVote(uint c, bool v) public {
    require(weights[msg.sender] > 0 && c<size);
    ballots[msg.sender].changeVote(c,v);
  }

  // activates the sender's ballot - this is included so that you can submit all your votes
  // and then activate your ballot after all votes have been submitted
  function activateVote() public {
    require(weights[msg.sender] > 0);
    ballots[msg.sender].activateVote();
  }

  function ApprovalElection(uint s) public {
    size = s;
    ballotType = "Approval";
  }


  function getWinner() public view returns (bytes32){
    uint[] memory counts = new uint[](size);      // the number of votes for each candidate
    for(uint i=0;i<addressList.length;i++){       // for each voter
      if(ballots[addressList[i]].voted){          // if they have voted
        for(uint j=0;j<size;j++){                 // look at their ballot
          if(ballots[addressList[i]].vote[j]){    // and if they voted for the candidate
            counts[j] += weights[addressList[i]]; // add their weight to that candidates score
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
