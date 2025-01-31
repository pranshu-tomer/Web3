// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256) {
        // ABI of the contract
        // Address of the contract - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        (,int price,,,) = priceFeed.latestRoundData();
        // ETH in terms of USD
        return uint256(price*1e10);
    }

    function getConversionRate(uint256 ethAmount,AggregatorV3Interface priceFeed) internal view returns(uint256){
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUSD = (ethPrice*ethAmount)/1e18;
        return ethAmountInUSD;
    }
}