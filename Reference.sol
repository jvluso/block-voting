pragma solidity ^0.4.16;

contract Reference{

    address[] public elections;
    uint public size;
    function setRecentElection(address election) public {
      elections.push(election);
      size++;
    }

}
