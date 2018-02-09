pragma solidity ^0.4.16;
import "owned.sol";

/// @title Election interface for Voting
contract Election {
  Ballot[] public ballots;
  mapping(address => uint) public weights;
  event BallotCreated(address ballot, address owner, uint index);
  function getBallot() public {
    Ballot b = new Ballot();
    addBallot(b);
  }
  function addBallot(Ballot b) internal {
    b.transferOwnership(msg.sender);
    ballots.push(b);
    weights[b]=1;
    BallotCreated(b,msg.sender,ballots.length-1);
  }
  function getWinner() public view returns (bytes32);
}

contract Ballot is owned {
  bool public voted;
  address public election;
  function Ballot() public {
    voted = false;
    election = msg.sender;
  }
}
