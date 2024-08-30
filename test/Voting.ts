import { expect } from "chai";
import hre from "hardhat";

describe("Voting", function () {
  it("Should mint and vote", async function () {
    const Voting = await hre.ethers.getContractFactory("VotingSystem");
    const voting = await Voting.deploy();
    await voting.waitForDeployment();

    const [owner, Aziz, notVoter] = await hre.ethers.getSigners();

    await voting.mint(owner.address, 100);
    await voting.mint(Aziz.address, 100);

    await voting.connect(owner).createProposal("Proposal 1");
    await voting.connect(Aziz).createProposal("Proposal 2");

    await voting.connect(owner).vote(0, true);
    await voting.connect(Aziz).vote(1, false);

    const proposal1 = await voting.proposals(0);
    const proposal2 = await voting.proposals(1);

    expect(proposal1.yesVotes).to.equal(1);
    expect(proposal1.noVotes).to.equal(0);
    expect(proposal2.yesVotes).to.equal(0);
    expect(proposal2.noVotes).to.equal(1);
  });


  it("Should not vote without tokens", async function () {
    const Voting = await hre.ethers.getContractFactory("VotingSystem");
    const voting = await Voting.deploy();
    await voting.waitForDeployment();

    const [owner, notVoter] = await hre.ethers.getSigners();

    await voting.mint(owner.address, 100);

    await voting.connect(owner).createProposal("Proposal 1");

    await expect(voting.connect(notVoter).vote(0, true)).to.be.revertedWith("You Don't have Tokens");
  });


  it("Should increment proposalCount when creating one", async function () {
    const Voting = await hre.ethers.getContractFactory("VotingSystem");
    const voting = await Voting.deploy();
    await voting.waitForDeployment();

    const [owner] = await hre.ethers.getSigners();

    expect(await voting.proposalCount()).to.equal(0);

    await voting.connect(owner).createProposal("Proposal 1");
    expect(await voting.proposalCount()).to.equal(1);

    await voting.connect(owner).createProposal("Proposal 2");
    expect(await voting.proposalCount()).to.equal(2);
  });


  it("Should initialize a proposal with correct initial state", async function () {
    const Voting = await hre.ethers.getContractFactory("VotingSystem");
    const voting = await Voting.deploy();
    await voting.waitForDeployment();
  
    const [owner] = await hre.ethers.getSigners();
  
    await voting.connect(owner).createProposal("Proposal 1");
  
    const proposal = await voting.proposals(0);
  
    expect(proposal.yesVotes).to.equal(0);
    expect(proposal.noVotes).to.equal(0);
    expect(proposal.isApproved).to.equal(false);
  });


  it("Should allow only the owners to mint tokens", async function () {
    const Voting = await hre.ethers.getContractFactory("VotingSystem");
    const voting = await Voting.deploy();
    await voting.waitForDeployment();
  
    const [owner, notOwner] = await hre.ethers.getSigners();
  
    await expect(voting.connect(notOwner).mint(notOwner.address, 100)).to.be.reverted;
  });
});
