// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract VotingSystem is ERC20, Ownable {
    uint256 public proposalCount;

    constructor() ERC20("VoteToken", "VTK") Ownable(msg.sender) {}

    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        mapping (address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;

}
