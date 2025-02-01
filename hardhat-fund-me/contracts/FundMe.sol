// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import "./PriceConverter.sol";

// 771479 gas
// this transaction cost we need to deploy this
// Now lets make it little gas efficient

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    // uint256 public minimumUSD = 50 * 1e18;
    uint256 public constant minimumUSD = 50 * 1e18;
    // 1. because this never gonna change Now lets compile
    // 751553 See its less than before
    // remember constant variable have diffrent naming convention (make minimumUSD in all caps)

    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;

    // address public owner;
    address public immutable i_owner;
    // initialise only one time inside constructor (i_ is naming convention)
    // 2. now transaction cost is 728329 , you can see its decresing

    AggregatorV3Interface public priceFeed;
    // this is also storage variable s_priceFeed
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How to send ETH to this contract

        require(msg.value.getConversionRate(priceFeed) >= minimumUSD, "Didn't Send Enough"); // 1e18 == 1 * 10 ** 18, money math is in wei
        // Check is the condition is true otherwise revert
        // What is Reverting??
        // undo any action before, and send remaining gas back
        s_funders.push(msg.sender);
        // Address of who is calling this function
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        //reset array
        s_funders = new address[](0);
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

    // cheaper withdraw function
    function cheaperWithdraw() public onlyOwner{

        // instead of reading from for loop we read it and store it in memory
        // then we read from memory
        address[] memory funders = s_funders;
        // rememer mappings can't be in memory, Sorry!

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // withraw fund from this contract
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

    // make variables private and add getter functions
}

// Stack Exchange ETH