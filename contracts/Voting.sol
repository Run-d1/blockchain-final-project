// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VotingSystem is ERC20, Ownable {
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    event proposalApproved(uint256 proposalId, string description, uint256 yesVotes, uint256 noVotes);

    constructor() ERC20("VoteToken", "VTK") Ownable(msg.sender) {}

    struct Proposal {
        uint256 id;
        address proposer;
        string description;

        uint256 yesVotes;
        uint256 noVotes;

        bool isApproved;
        mapping (address => bool) hasVoted;
    }


    // create submit proposal function, the proposal is incremented everytime by one

    function createProposal(string memory description) public {
        Proposal storage proposal = proposals[proposalCount];

        proposal.id = proposalCount;
        proposal.proposer = msg.sender;
        proposal.description = description;

        proposalCount++;
    }


    // 2- mint
    // only owner can mint

    function mint(address to, uint amount) public onlyOwner {  // onlyOwner from "Ownable"
        _mint(to, amount * 10**18);  // _mint from "ERC20"
    }


    // 3- vote
    // check if the voter has a token check if the balance is greater than 0
    // check if the voter has voted
    // the function takes a proposal id and a boolean value to check if the vote is yes or no
    // use balanceOf(address) -->  balanceOf() from "ERC20"

    function vote(uint256 proposalId, bool isYes) public {
        Proposal storage proposal = proposals[proposalId];

        require(balanceOf(msg.sender) > 0, "You Don't have Tokens");
        require(proposal.hasVoted[msg.sender] == false, "You've already voted");
        proposal.hasVoted[msg.sender] = true;

        if (isYes) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
    }


    function getProposal(uint256 proposalId) public view returns(uint id, string memory description, uint yesVotes, uint noVotes, address proposer) {
        Proposal storage proposal = proposals[proposalId];
        return (proposal.id, proposal.description, proposal.yesVotes, proposal.noVotes, proposal.proposer);
    }
}
