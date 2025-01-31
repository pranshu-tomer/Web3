const network = require("hardhat");
const {developmentChains,DECIMALS,INITIAL_PRICE} = require("../helper-hardhat-config");

module.exports = async (hre) => {
    const {deployments, getNamedAccounts} = hre;
    const {deploy,log} = deployments;
    const {deployer} = await getNamedAccounts();
    const chainId = await hre.getChainId();

    if(developmentChains.includes(network.name)){
        log("Local Network detected! Deploying mocks...");
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [DECIMALS,INITIAL_PRICE]
        })
        log("Mocks Deployed!")
        log("-----------------------------------------")
    }
}

module.exports.tags = ["all","mocks"]