pragma solidity ^0.4.16;
import "./Election.sol";

/// @title Voting with erc20 compliant liquid tokens.
contract Voting {

    event testEvent();


    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated
        Ballot vote;   // index of the voted proposal
    }


    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;
    address[] public votersList;

    Election election;

    /// Create a new ballot to choose one of `proposalNames`.
    function Voting() public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        election = new YesNoElection();

    }

    // Give voter the right to vote on this ballot.
    // May only be called by chairperson.
    function giveRightToVote(address voter) public {
        require((msg.sender == chairperson) &&  (voters[voter].weight == 0));

        voters[voter].weight = 1;
        votersList.push(voter);
    }

    /// Give your vote
    function vote(Ballot proposal) public {
        Voter storage sender = voters[msg.sender];
        require(election.isValidBallot(proposal));
        sender.vote = proposal;

    }

    /// Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view
            returns (Winner winningProposal)
    {
        mapping (Ballot => uint) tally;
        for(uint i=0;i<votersList.length;i++){
          Voter voter = voters[votersList[i]];
          tally[voter.vote]+=voter.weight;
        }
        return election.getWinner(tally);
    }

}
