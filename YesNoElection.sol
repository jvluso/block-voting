pragma solidity ^0.4.16;
import "owned.sol";

/// @title Election interface for Voting
contract YesNoElection {
  YesNoBallot[] public ballots;
  mapping(address => uint) public weights;
  event BallotCreated(address ballot, address owner, uint index);
  function getBallot() public {
    YesNoBallot b = new YesNoBallot();
    b.transferOwnership(msg.sender);
    ballots.push(b);
    weights[b]=1;
    BallotCreated(b,msg.sender,ballots.length);
  }
  function getWinner() public view returns (bool){
    uint yes = 0;
    uint no = 0;
    for(uint i=0;i<ballots.length;i++){
      if(ballots[i].voted()){
        if(ballots[i].vote()){
          yes += weights[ballots[i]];
        }else{
          no += weights[ballots[i]];
        }
      }
    }
    return yes > no;
  }
}

contract YesNoBallot is owned {
  bool public voted;
  bool public vote;
  function YesNoBallot() public {
    voted = false;
    vote = false;
  }
  function changeVote(bool v) public onlyOwner {
    voted = true;
    vote = v;
  }
}
