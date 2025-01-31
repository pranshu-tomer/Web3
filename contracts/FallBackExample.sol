// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FallBackExample{
    uint256 public result;

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}

// Ehther is sent to contract
// is msg.data empty?
// yes - if receive() there
//     - yes receive()
//     - no fallback()
// no - fallback()