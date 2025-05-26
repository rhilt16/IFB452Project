// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DistributionContract {
    // A counter for the charities
    uint256 public charityCount;

    // Structure, mapping, and events to handle new charities being created
    struct CharityDetails {
        string name;
        address charityAddress;
        uint256 totalRaised;
        uint256 targetDonation;
        bool fundsLocked;
        string milestoneDescription;
        bool isMilestoneComplete;
    }

    mapping(uint256 => CharityDetails) private charities;

    event CharityCreated(
        uint256 charityID,
        string name,
        address charityAddress,
        uint256 totalRaised,
        uint256 targetDonation,
        bool fundsLocked
    );
    // Adds new charity
    function addCharity(string memory _name, address _charityAddress, string memory _milestoneDescription) public {
        // Update the charity count, create a new charity object and add it to the charities list
        charityCount++;
        charities[charityCount] = CharityDetails(
            _name,
            _charityAddress,
            0,
            100, // 100 ETH target
            true,
            _milestoneDescription,
            false
        );

        emit CharityCreated(
            charityCount,
            _name,
            _charityAddress,
            0,
            100,
            true
        );
    }
    
    function contributeFunds(string memory _charity, uint256 _amount) external {
        // Check if the charity exists, fail if it doesn't
        int256 index = charityExists(_charity);
        require(index != -1, "Charity does not exist");

        // Otherwise, retrive the stored charity from the index, and add the donated amount to the total
        CharityDetails storage charity = charities[uint256(index)];
        charity.totalRaised += _amount;

        // If the total exceeds the target, unlocks the funds
        if (charity.totalRaised >= charity.targetDonation) {
            charity.fundsLocked = false;
        }
    }

    // Mark the milstone as complete if the total has exceeded the target
    function markMilestoneComplete(uint256 charityID) public {
        if(charities[charityID].totalRaised >= charities[charityID].targetDonation) {
            charities[charityID].isMilestoneComplete = true;
        } else {
            charities[charityID].isMilestoneComplete = false;
        }
    }

    // Update the milestone with a new description
    function updateMilestone(uint256 charityID, string memory newDescription) public {
        require(
            msg.sender == charities[charityID].charityAddress,
            "Not authorized"
        );
        charities[charityID].milestoneDescription = newDescription;
    }
    // Retrieve charity by ID
    function getCharityById(uint256 id) public view returns (string memory name, address charityAddress, uint256 totalRaised, uint256 targetDonation, bool fundsLocked, string memory milestoneDescription, bool isMilestoneComplete){
        CharityDetails memory c = charities[id];
        return (
            c.name,
            c.charityAddress,
            c.totalRaised,
            c.targetDonation,
            c.fundsLocked,
            c.milestoneDescription,
            c.isMilestoneComplete
        );
    }

    // Check if the charity exists, fail if it doesn't
    // Returns index or -1
    function charityExists(string memory _charity) public view returns (int256) {
        for (uint256 i = 1; i <= charityCount; i++) {
            if (
                keccak256(abi.encodePacked(charities[i].name)) ==
                keccak256(abi.encodePacked(_charity))
            ) {
                return int256(i);
            }
        }
        return -1;
    }
}
