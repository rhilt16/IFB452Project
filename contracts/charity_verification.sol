// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CharityVerificationContract {
    
    function verifyCharity(address charityAddress, string memory name) external pure returns (bool success) {
        
        string[3] memory registeredCharities = [
            "C1", 
            "C2", 
            "C3"
        ];

        address[3] memory registeredAddresses = [
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
            0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
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