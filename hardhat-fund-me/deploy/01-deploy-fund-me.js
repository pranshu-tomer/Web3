const { network } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
const {networkConfig} = require("../helper-hardhat-config").networkConfig;
const {verify} = require("../utils/verify");

module.exports = async (hre) => {
    const {deployments, getNamedAccounts} = hre;
    const {deploy,log} = deployments;
    const {deployer} = await getNamedAccounts();

    const chainId = await network.config.chainId;
    let ethUsdPriceFeedAddress
    if(developmentChains.includes(network.name)){
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    }else{
        ethUsdPriceFeedAddress = networkConfig[chainId].ethUsdPriceFeed
    }
    // when going for localhost or hardhat network, we want to use a mock
    // if the contract doesn't exist, we deploy a minimal version of it for our local testing
    const args = [ethUsdPriceFeedAddress] 
    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmation || 1
    })

    if(!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY){
        await verify(fundMe.address, args)
    }
    log("-------------------------------------------")
}

module.exports.tags = ["all", "fund-me"]