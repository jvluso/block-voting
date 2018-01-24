pragma solidity ^0.4.16;

// An owned contract is owned by another contract.
// The owner may transfer ownership to another contract.
contract owned {

    function owned() public {
        owner = msg.sender;
    }
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) public onlyOwner{
        owner = newOwner;
    }
}
