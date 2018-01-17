pragma solidity ^0.4.16;
import "./Election.sol";

/// @title Election interface for Voting
contract YesNoElection is Election{
  function isValidBallot(Ballot b) public returns (bool){
    return bool(YesNoBallot(b).isYesNoBallot);
  }
  function getWinner(BallotList l) public returns (Winner){
    return new YesNoWinner(l.getWeight(0)<l.getWeight(1));
  }
}

contract YesNoBallot is Ballot{
  bool public isYesNoBallot;
  bool public vote;
  function YesNoBallot(bool v) public{
    isYesNoBallot = true;
    vote=v;
  }
}
contract YesNoBallotList is BallotList{
  uint trueWeight;
  uint falseWeight;
  function ittLength() public returns (uint){
    return 2;
  }
  function getBallot(uint i) public returns (Ballot){
    if(i==0){
      return new YesNoBallot(false);
    }else{
      return new YesNoBallot(true);
    }
  }
  function getWeight(uint i) public returns (uint){
    if(i==0){
      return falseWeight;
    }else{
      return trueWeight;
    }
  }
  function addBallot(Ballot b, uint w) public{
    if(b.vote){
      trueWeight += w;
    }else{
      falseWeight += w;
    }
  }
}
contract YesNoWinner is Winner{
  bool vote;
  function YesNoWinner(bool v) public{
    vote=v;
  }
}
