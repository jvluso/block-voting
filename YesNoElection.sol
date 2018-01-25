pragma solidity ^0.4.16;
import "owned.sol";
import "Election.sol";

/// @title choose yes or no in an election
contract YesNoElection is Election {

  function getBallot() public {
    Ballot b = new YesNoBallot();
    Election.addBallot(b);
  }
  function getWinner() public view returns (bytes32){
    uint yes = 0;
    uint no = 0;
    for(uint i=0;i<ballots.length;i++){
      if(ballots[i].voted()){
        if(YesNoBallot(ballots[i]).vote()){
          yes += weights[ballots[i]];
        }else{
          no += weights[ballots[i]];
        }
      }
    }
    if(yes > no){
      return 'yes';
    }
    return 'no';
  }
}

contract YesNoBallot is owned,Ballot {
  bool public vote;
  function YesNoBallot() public {
    vote = false;
  }
  function changeVote(bool v) public onlyOwner {
    voted = true;
    vote = v;
  }
}
