pragma solidity ^0.4.16;
import "owned.sol";
import "Election.sol";

/// @title choose a result by plurality vote
contract PluralityElection is Election {
  bytes32[] public results;  //the list of possible winners
  uint public size;          //the maximum number of winners
  uint public added;         //the number of winners that have been added
  function PluralityElection(uint s) public {
    size = s;
    added = 0;
  }
  function addWinner(bytes32 name) public {
    require(added<size);
    added++;
    results.push(name);
  }
  function getBallot() public {
    Ballot b = new PluralityBallot();
    Election.addBallot(b);
  }
  function getWinner() public view returns (bytes32){
    uint[] memory counts = new uint[](size);
    for(uint i=0;i<ballots.length;i++){
      if(ballots[i].voted()){
        counts[PluralityBallot(ballots[i]).vote()] += weights[ballots[i]];
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
    return results[winner];
  }
}

contract PluralityBallot is owned,Ballot {
  uint public vote;
  function PluralityBallot() public {
    vote = 0;
  }
  function changeVote(uint v) public onlyOwner {
    voted = true;
    vote = v;
  }
}
