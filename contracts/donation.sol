// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICharityVerify {
    function verifyCharity(address, string memory) external view returns (bool);
}

interface IMilestone {
    function contributeFunds(string memory _charity, uint _amount) external;
}

interface IRoles {
    function getMyRole() external view returns (string memory);

}
contract DonationContract {


    address verifyContractAdd;
    address milestoneAdd;
    address roleContractAdd;


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
    constructor(address _verify, address _milestone, address _roleContract) {
        verifyContractAdd = address(_verify);
        milestoneAdd = address(_milestone);
        roleContractAdd = address(_roleContract);
        
    }

    modifier isDonor() {
        string memory role = IRoles(roleContractAdd).getMyRole();
        require(keccak256(abi.encodePacked(role)) == keccak256(abi.encodePacked("donor")),"Not a valid donor");
        _;
    }

    modifier isCharity() {
        string memory role = IRoles(roleContractAdd).getMyRole();
        require(keccak256(abi.encodePacked(role)) ==keccak256(abi.encodePacked("charity")), "Not a valid charity");
        _;
    }


    function donate(string memory _charity, address charityAdd, address donorAdd, uint _donationAmount) public {
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

    function getDonationsByAddress(address _charityAddress) public view returns (Donation[] memory) {
        uint count = 0;

        // Count how many donations that charity has
        for (uint i = 1; i <= donationCount; i++) {
            if (donations[i].charityAdd == _charityAddress) {
                count++;
            }
        }

        // Create array to hold just that charities donations
        Donation[] memory donationsArray = new Donation[](count);
        uint index = 0;

        // Populate that array
        for (uint i = 1; i <= donationCount; ++i) {
            if (donations[i].charityAdd == _charityAddress) {
                donationsArray[index] = donations[i];
                index++;
            }
        }

        return donationsArray;
    }

    

    function getAllDonations() public view returns (Donation[] memory) {
        // Create array to hold donations
        Donation[] memory donationsArray = new Donation[](donationCount);


        // Populate that array
        for (uint i = 1; i <= donationCount; ++i) {
            donationsArray[(i-1)] = donations[i];
        }

        return donationsArray;
    }

}