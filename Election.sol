pragma solidity ^0.4.16;

/// @title Election interface for Voting
contract Election {
  bytes32[] public candidates;  //the list of possible winners
  bytes32 public electionName;
  uint public size;          //the maximum number of winners
  mapping(address => uint) public weights;
  address[] public addressList;
  bytes32 public ballotType;

  function addCandidate(bytes32 name) public {
    require(candidates.length<size);
    candidates.push(name);
  }
  function addVoter(address v) public {
    require(candidates.length<size);
    weights[v] = 1;
    addressList.push(v);
  }
  function setName(bytes32 n) public {
    require(candidates.length<size);
    electionName = n;
  }
  function getWinner() public view returns (bytes32);


  function getCandidate(uint num) public view returns (bytes32,uint){
    return (candidates[num],num);
  }
}
