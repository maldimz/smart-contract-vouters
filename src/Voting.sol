// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address owner;
    mapping(address => bool) public voters;

    uint256 public startVote;
    uint256 public endVote;

    constructor(string[] memory _candidatesNames, uint256 _duration) {
        for (uint256 i = 0; i < _candidatesNames.length; i++) {
            candidates.push(
                Candidate({name: _candidatesNames[i], voteCount: 0})
            );
        }

        owner = msg.sender;
        startVote = block.timestamp;
        endVote = startVote + (_duration * 1 minutes);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({name: _name, voteCount: 0}));
    }

    function vote(uint256 _candidateIndex) public {
        require(
            block.timestamp >= startVote && block.timestamp <= endVote,
            "Voting is not allowed at this time"
        );
        require(voters[msg.sender] == false, "You have already voted");
        require(
            _candidateIndex < candidates.length,
            "Candidate with this index does not exist"
        );

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }

    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getVotingStatus() public view returns (bool) {
        return block.timestamp >= startVote && block.timestamp <= endVote;
    }

    function getRemainingTime() public view returns (uint256) {
        if (block.timestamp >= endVote) {
            return 0;
        }
        return endVote - block.timestamp;
    }
}
