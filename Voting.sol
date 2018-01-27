pragma solidity ^0.4.16;
import "./Election.sol";
import "./YesNoElection.sol";
import "./PluralityElection.sol";
import "./owned.sol";

/// @title Voting with erc20 compliant liquid tokens.
contract Voting is owned{

    event ElectionCreated(address election);

    mapping(address => uint) public voters;
    address[] public votersList;
    struct electionData{
      Election election;
      mapping(address => uint) unclaimedWeight;
    }
    mapping(address => electionData) allElections;



    // Give voter the right to vote on this ballot.
    // May only be called by chairperson.
    function giveRightToVote(address voter) public onlyOwner {
        require(voters[voter] == 0);

        voters[voter] = 1;
        votersList.push(voter);
    }


    enum validElection{
      YesNoElection,
      PluralityElection
    }
    function createElection(validElection electionType) public {
      require(voters[msg.sender] > 0);
      Election e;
      if(electionType==validElection.YesNoElection){
        e=new YesNoElection();
      }else if(electionType==validElection.PluralityElection){
        e=new PluralityElection(3);
      }else{
        revert();
      }
      allElections[e].election=e;
      for(uint i=0;i<votersList.length;i++){
        allElections[e].unclaimedWeight[votersList[i]]=voters[votersList[i]];
      }

    }



}
