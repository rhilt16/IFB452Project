// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract CharityVerificationContract {

    // Based on hard coded verified charities, verify if an input is valid
    function verifyCharity(address charityAddress, string memory name) external pure returns (bool success) {
        
        string[3] memory registeredCharities  = [
            "American Red Cross", 
            "The Salvation Army Australia", 
            "Save The Children"
        ] ;

        address[3]  memory registeredAddresses = [
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
            0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
        ];

        for (uint i; i < registeredCharities.length; i++) {
            if(charityAddress == registeredAddresses[i]) {
                if(keccak256(abi.encodePacked(registeredCharities[i])) == keccak256(abi.encodePacked(name))){
                    return true;
                }
                
            }
        }

        return false; 
    }

}