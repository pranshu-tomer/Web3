// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; // Solidity Version always on the top

// >=0.8.26 <0.9.0 (for range version)

contract SimpleStorage {
    // boolean, uint, int, address, bytes
    uint256 public favNumber;

    // the default visibilty is internal

    // for a function need to be overridable it needs to be virtual
    function store(uint256 _favNumber) public virtual {
        favNumber = _favNumber;
    }

    // View Funtion
    function retrieve() public view returns (uint256) {
        return favNumber;
    }

    function add() public pure returns (uint256) {
        return (1 + 1);
    }

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People public person = People({favoriteNumber: 2, name: "Pranshu"});
    // Array
    People[] public people;

    function addPeople(string memory _name, uint256 _favNumber) public {
        people.push(People(_favNumber, _name));
        // After mapping
        nameToFavNumber[_name] = _favNumber;
    }

    // Calldata, memory means this data only exists temprarily

    mapping(string => uint256) public nameToFavNumber;
}
