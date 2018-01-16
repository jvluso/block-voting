pragma solidity ^0.4.16;

/// @title Hello world
contract Hello {

    string name;
    event testEvent();

    function Hello(string proposalNames) public {
        name=proposalNames;
    }

    function triggerEvent() public {
        testEvent();
    }
}
