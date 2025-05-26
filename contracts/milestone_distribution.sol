// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DistributionContract {
    uint256 public charityCount;
    address public roleContractAdd;

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

    

    function addCharity(
        string memory _name,
        address _charityAddress,
        string memory _milestoneDescription
    ) public {
        // Only users with role 'charity' can add a charity
        
        
        charityCount++;

        charities[charityCount] = CharityDetails(
            _name,
            _charityAddress,
            0,
            100 ether, // 100 ETH target
            true,
            _milestoneDescription,
            false
        );

        emit CharityCreated(
            charityCount,
            _name,
            _charityAddress,
            0,
            100 ether,
            true
        );
    }

    function contributeFunds(string memory _charity, uint256 _amount) external {
        int256 index = charityExists(_charity);
        require(index != -1, "Charity does not exist");
        CharityDetails storage charity = charities[uint256(index)];
        charity.totalRaised += _amount;

        if (charity.totalRaised >= charity.targetDonation) {
            charity.fundsLocked = false;
        }
    }

    function markMilestoneComplete(uint256 charityID) public {
        require(
            msg.sender == charities[charityID].charityAddress,
            "Only the charity can mark milestone complete"
        );
        charities[charityID].isMilestoneComplete = true;
    }

    function updateMilestone(uint256 charityID, string memory newDescription) public {
        require(
            msg.sender == charities[charityID].charityAddress,
            "Not authorized"
        );
        charities[charityID].milestoneDescription = newDescription;
    }

    function getCharityById(uint256 id)
        public
        view
        returns (
            string memory name,
            address charityAddress,
            uint256 totalRaised,
            uint256 targetDonation,
            bool fundsLocked,
            string memory milestoneDescription,
            bool isMilestoneComplete
        )
    {
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
