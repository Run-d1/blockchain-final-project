// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VotingSystem is ERC20, Ownable {
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    constructor() ERC20("VoteToken", "VTK") Ownable(msg.sender) {}

    struct Proposal {
        uint256 id;
        address proposer;
        string description;

        uint256 yesVotes;
        uint256 noVotes;
        mapping (address => bool) hasVoted;
    }

    // create submit proposal function, the proposal is incremented everytime by one

    // function createProposal(string memory description) public {
    //     Proposal memory proposal = Proposal(msg.sender, description, proposalCount);
    //     proposals[msg.sender] = proposal;
    //     proposalCount++;
    // }

    function createProposal(string memory description) public {
        Proposal storage proposal = proposals[proposalCount];

        proposal.id = proposalCount;
        proposal.proposer = msg.sender;
        proposal.description = description;

        proposalCount++;
    }

    // function getProposal() {

    // }

    // function getProposal() public view returns (Proposal memory) {
    //     return proposals[msg.sender];
    // }

    // 2- mint
    // only owner can mint

    function mint(address to, uint amount) public onlyOwner {  // onlyOwner from "Ownable"
        _mint(to, amount * 10**18);  // _mint from "ERC20"
    }

    // 3- vote
    // check if the voter has a token check if the balance is greater than 0
    // check if the voter has voted
    // the function takes a proposal id and a boolean value to check if the vote is yes or no


    // function vote(uint256 proposalId, bool isYes) public {
    // // use balanceOf(address)
    // }


    function vote(uint256 proposalId, bool isYes) public {
        Proposal storage proposal = proposals[proposalId];

        require(balanceOf(msg.sender) > 0, "You Don't have Tokens");
        require(proposal.hasVoted[msg.sender] == false, "You've already voted");

        if (isYes) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }

        proposal.hasVoted[msg.sender] = true;
    }
}
