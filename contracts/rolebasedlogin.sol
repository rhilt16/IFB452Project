// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleBasedLogin {
    
    // Define roles for users
    enum Role { None, Donor, Charity }

    // Structure to hold user information
    struct User {
        string username;    // The username of the user
        Role role;          // User's role: Donor or Collector
        bool isRegistered;  // Flag to check if the user is registered
    }

    // Mapping to store users based on their wallet address
    mapping(address => User) private users;

    // Events to log when users register or login
    event UserRegistered(address indexed user, string username, Role role);
    event UserLoggedIn(address indexed user, Role role);

    /**
     * Register a new user with a username and a role.
     * - `_username`: display name for the user.
     * - `_role`: must be either "donor" or "collector".
     */
    function register(string memory _username, string memory _role) public {
        require(!users[msg.sender].isRegistered, "Already registered");

        // Convert the role string to a Role enum value
        Role selectedRole = getRoleFromString(_role);
        require(selectedRole != Role.None, "Invalid role");

        // Save user data
        users[msg.sender] = User(_username, selectedRole, true);

        // Emit an event for successful registration
        emit UserRegistered(msg.sender, _username, selectedRole);
    }

    /**
     * Simulates login.
     * - Returns `true` and the user's role if registered.
     */
    function login() public view returns (bool success, string memory role) {
        require(users[msg.sender].isRegistered, "User not registered");

        // Convert role enum back to string
        string memory userRole = getRoleAsString(users[msg.sender].role);

        return (true, userRole);
    }

    // If the user has been registered, then reset the senders value in the user mapping
    function logout() public returns (bool success) {
        // If they are not registered, then return false
        if(!users[msg.sender].isRegistered){
            return false;
        }
        users[msg.sender] = User("", Role.None, false);
        users[msg.sender].isRegistered = false;
        
        // Emit an event for successful logout
        emit UserLoggedIn(msg.sender, users[msg.sender].role);
        return true;
    }

    /**
     * INTERNAL: Converts a string to a Role enum.
     * - Accepts only "donor" or "collector".
     */
    function getRoleFromString(string memory _role) internal pure returns (Role) {
        bytes32 roleHash = keccak256(abi.encodePacked(_role));

        if (roleHash == keccak256(abi.encodePacked("donor"))) return Role.Donor;
        if (roleHash == keccak256(abi.encodePacked("charity"))) return Role.Charity;

    return Role.None;
}


    /**
     * INTERNAL: Converts a Role enum to a readable string.
     */
    function getRoleAsString(Role _role) internal pure returns (string memory) {
        if (_role == Role.Donor) return "donor";
        if (_role == Role.Charity) return "charity";
        return "none";
    }

    /**
     * PUBLIC: Returns the role of the calling user in string form.
     */
    function getMyRole() public view returns (string memory) {
        require(users[msg.sender].isRegistered, "Not registered");
        return getRoleAsString(users[msg.sender].role);
    }

    function getMyDetails() public view returns (User memory) {
        require(users[msg.sender].isRegistered, "Not logged in");
        return users[msg.sender];
    }
}
