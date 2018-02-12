pragma solidity ^0.4.16;

contract Reference{

    address public recentElection;
    function setRecentElection(address election) public {
      recentElection = election;
    }

}
