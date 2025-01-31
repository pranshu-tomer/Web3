// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "./PriceConverter.sol";

// 771479 gas
// this transaction cost we need to deploy this
// Now lets make it little gas efficient

error NotOwner();

contract FundMe1{
    using PriceConverter for uint256;

    // uint256 public minimumUSD = 50 * 1e18;
    uint256 public constant minimumUSD = 50 * 1e18;
    // 1. because this never gonna change Now lets compile
    // 751553 See its less than before
    // remember constant variable have diffrent naming convention (make minimumUSD in all caps)

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // address public owner;
    address public immutable i_owner;
    // initialise only one time inside constructor (i_ is naming convention)
    // 2. now transaction cost is 728329 , you can see its decresing

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How to send ETH to this contract

        require(msg.value.getConversionRate() >= minimumUSD, "Didn't Send Enough"); // 1e18 == 1 * 10 ** 18, money math is in wei
        // Check is the condition is true otherwise revert
        // What is Reverting??
        // undo any action before, and send remaining gas back
        funders.push(msg.sender);
        // Address of who is calling this function
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //reset array
        funders = new address[](0);
        // withraw fund from this contract

        // 1) transfer
        // typecasting msg.sender from address type to payable address type
        // payable(msg.sender).transfer(address(this).balance);
        // transfer automatically revert
        // issues with this

        // 2) send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        // it not revert it gives boolean value, now you decide

        // 3) call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner {
        // 3. require(msg.sender == i_owner, "Sender is not owner");
        // for gas optimisation
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    // what happens if someone sends this contract ETH without calling the fund function
    // receive()
    // fallbak()

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

// Stack Exchange ETH