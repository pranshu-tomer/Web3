// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "./SimpleStorage.sol";

contract StorageFactory{
    
    SimpleStorage[] public simpleStorage;
    function createSimpleStorage() public {
        SimpleStorage simple = new SimpleStorage();
        simpleStorage.push(simple);
        // this contact diploays this contract
    }

    function sfStore(uint256 _simpleIndex,uint256 _simpleNumber) public{
        // In order to interact with any contract we need two things
        // Address
        // ABI - Application Binary Interface
        SimpleStorage simple = simpleStorage[_simpleIndex];
        simple.store(_simpleNumber);
    }

    function sfGet(uint _simpleIndex) public view returns(uint256){
        return simpleStorage[_simpleIndex].retrieve();
    }
}