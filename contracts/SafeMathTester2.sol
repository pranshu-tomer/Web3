// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// SafeMath is github repo

contract SafeMathTester2{

    uint8 public bigNumber = 255;
    function add() public {
        bigNumber = bigNumber+1;
        // It becomes zero
        // If you add big number than its limit than its just wrap around and starts with zero
        // versions before 6 now in 8 its checked by solidity
        unchecked {bigNumber = bigNumber+1;}
        // it helps in writing gas efficient contract 
    }
}