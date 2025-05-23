// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRoles {
    function getMyRole() external view returns (string memory);

}

contract DistributionContract {
 
    uint256 public charityCount;

    
    address roleContractAdd;

   
    struct CharityDetails {
        string name;
        address charityAddress;
        uint totalRaised; // Amount of money raised by the charity
        uint targetDonation;// Target amount of money to reach
        bool fundsLocked;
    }

  
    mapping (uint256 => CharityDetails) public charities;
    event CharityCreated(uint charityID, string name, address charityAddress, uint totalRaised, uint targetDonation, bool fundsLocked);

    function charityExists(string memory _charity) public view returns (int){
        for (uint i = 1; i < (charityCount+1); i++) {
            if(keccak256(abi.encodePacked(charities[i].name)) == keccak256(abi.encodePacked(_charity))){
                int x = int(i);
                return x;        
            }
        }

        return -1;
    }

    function contributeFunds(string memory _charity, uint _amount) external  {
        int _charityIndex = charityExists(_charity);
        if(_charityIndex == -1){
            
            revert();
        } else {
            CharityDetails storage targetCharity = charities[uint(_charityIndex)];
            
            targetCharity.totalRaised += _amount;

            if(targetCharity.totalRaised >= targetCharity.targetDonation){
                targetCharity.fundsLocked = false;
            }
        }
        
    } 

    function addCharity(string memory _name, address _charityAddress) public {
        // Increment contractCount to generate a unique contract ID
        charityCount++;

        // Create a new quality contract and store it in the qualityContracts mapping
        charities[charityCount] = CharityDetails(_name, _charityAddress , 0, 10000, true);

        // Emit an event to signify the creation of a new quality contract
        emit CharityCreated(charityCount, _name, _charityAddress, 0, 10000, true);
    }
    
}