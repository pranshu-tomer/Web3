// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage{
    // It inherit All the functionality of Simple Storage
    // Just leave below code and run empty you can see this

    // Override functions
    function store(uint256 _favNumber) public override{
        favNumber = _favNumber+5;
    }
}