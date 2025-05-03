// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharityVerify {
    function verifyCharity(address, string memory) external view returns (bool);
}

interface IMilestone {
    function contributeFunds(string memory _charity, uint _amount) external;
}

contract DonationContract {

    // The contract owner's address
    address public owner;
    address verifyContractAdd;
    address milestoneAdd;


    struct Donation {
        string charity; // Name of the charity donated to
        address charityAdd; // Address of the charity donated to
        address donorAdd; // Address of the donor
        uint donationAmount;// Amount of money donated by a single donor
        
    }
  
    mapping (uint256 => Donation) public donations;
    // Counter to keep track of the total number of quality contracts
    uint256 public donationCount; 
    
    // Event triggered when a new donation is completed
    event DonationCreated(uint256 donationID, string charity, address charityAdd, address donorAdd, uint donationAmount);

    // Contract constructor, set addresses of other contracts
    constructor() {
       
        verifyContractAdd = address(0xcD6a42782d230D7c13A74ddec5dD140e55499Df9);
        milestoneAdd = address(0xb5465ED8EcD4F79dD4BE10A7C8e7a50664e5eeEB);
    }    

    function donate(string memory _charity, address charityAdd, address donorAdd, uint _donationAmount) public payable  {
        if(!(ICharityVerify(verifyContractAdd).verifyCharity(charityAdd, _charity))){
            revert("not valid");
        }

        IMilestone(milestoneAdd).contributeFunds(_charity, _donationAmount);
        
        // Increment contractCount to generate a unique contract ID
        donationCount++;

        // Create a new quality contract and store it in the qualityContracts mapping
        donations[donationCount] = Donation(_charity, charityAdd, donorAdd, _donationAmount);

        // Emit an event to signify the creation of a new quality contract
        emit DonationCreated(donationCount, _charity, charityAdd, donorAdd, _donationAmount);
    }

    function getDonationsByName(string memory _charity) public view returns (Donation[] memory) {
        uint count = 0;

        // Count how many donations that charity has
        for (uint i = 1; i <= donationCount; i++) {
            if (keccak256(abi.encodePacked(donations[i].charity)) == keccak256(abi.encodePacked(_charity))) {
                count++;
            }
        }

        // Create array to hold just that charities donations
        Donation[] memory donationsArray = new Donation[](count);
        uint index = 0;

        // Populate that array
        for (uint i = 1; i <= donationCount; ++i) {
            if (keccak256(abi.encodePacked(donations[i].charity)) == keccak256(abi.encodePacked(_charity))) {
                donationsArray[index] = donations[i];
                index++;
            }
        }

        return donationsArray;
    }

}