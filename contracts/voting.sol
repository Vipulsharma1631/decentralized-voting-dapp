// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Voting
 * @dev A simple smart contract for a decentralized voting system.
 * The owner can add candidates and authorize voters.
 */
contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
    }

    address public owner;
    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    
    // FIXED: Moved 'indexed' after the data types
    event Voted(address indexed voter, uint indexed candidateId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    /**
     * @notice Adds a new candidate to the election.
     * @dev Can only be called by the contract owner.
     * @param _name The name of the new candidate.
     */
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate({
            id: candidatesCount,
            name: _name,
            voteCount: 0
        });
    }

    /**
     * @notice Authorizes an address, granting them the right to vote.
     * @dev Can only be called by the contract owner. This action is irreversible.
     * @param _voterAddress The Ethereum address of the voter to authorize.
     */
    function authorizeVoter(address _voterAddress) public onlyOwner {
        voters[_voterAddress].authorized = true;
    }

    /**
     * @notice Allows an authorized voter to cast their vote for a specific candidate.
     * @dev This function will contain checks to ensure a voter is authorized and has not
     * already voted. It also validates the candidate ID.
     * @param _candidateId The ID of the candidate to vote for.
     */
    function vote(uint _candidateId) public {
        // Checkpoint 1: Is the voter authorized?
        require(voters[msg.sender].authorized, "You are not authorized to vote.");

        // Checkpoint 2: Has the voter already cast their ballot?
        require(!voters[msg.sender].voted, "You have already cast your vote.");

        // Checkpoint 3: Is the candidate ID valid?
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        // --- Effects ---
        candidates[_candidateId].voteCount++;
        voters[msg.sender].voted = true;

        // --- Interaction ---
        emit Voted(msg.sender, _candidateId);
    }

    /**
     * @notice Gets all candidates and their current vote counts.
     * @dev This is a read-only view function that does not consume gas when called externally.
     * @return A memory array of Candidate structs.
     */
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](candidatesCount);

        for (uint i = 1; i <= candidatesCount; i++) {
            allCandidates[i - 1] = candidates[i];
        }

        return allCandidates;
    }
}