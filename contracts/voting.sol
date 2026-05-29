// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Voting
 * @dev A simple smart contract for a decentralized voting system.
 * The owner can add candidates and authorize voters.
 */
contract Voting {
    /**
     * @notice Represents a single candidate in the election.
     * @dev Each candidate has a unique ID, a name, and a count of votes received.
     */
    struct Candidate {
        uint id;          // Unique identifier for the candidate, starting from 1.
        string name;      // The candidate's name.
        uint voteCount;   // The total number of votes this candidate has received.
    }

    /**
     * @notice Represents a voter's status in the election.
     * @dev Tracks whether a voter is authorized and if they have already voted.
     */
    struct Voter {
        bool authorized;  // True if the voter is whitelisted by the owner.
        bool voted;       // True if the voter has already cast their ballot.
    }

    address public owner;

    /**
     * @notice A mapping from a voter's address to their voter status.
     * @dev This allows for efficient lookups to check if a user is authorized and has voted.
     */
    mapping(address => Voter) public voters;

    /**
     * @notice A mapping from a candidate ID to the Candidate struct.
     * @dev This allows for efficient retrieval of candidate data using their unique ID.
     */
    mapping(uint => Candidate) public candidates;
	
    /**
     * @notice The total number of candidates in the election.
     * @dev Also used to generate unique IDs for new candidates.
     */
    uint public candidatesCount;

    // The contract's functions will be implemented here in the next tasks.
}