pragma solidity ^0.4.16;

/// @title Election interface for Voting
contract Election{
  function isValidBallot(Ballot b) public returns (bool);
  function getWinner(BallotList l) public returns (Winner);
}

interface Ballot{}
interface BallotList{
  function ittLength() public returns (uint);
  function getBallot(uint i) public returns (Ballot);
  function getWeight(uint i) public returns (uint);
  function addBallot(Ballot b, uint w) public;
}
interface Winner{}
