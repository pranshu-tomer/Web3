const { getNamedAccounts,ethers } = require("hardhat");

async function main(){
    const deployer = await getNamedAccounts();
    const fundMe = await ethers.getContract("FundMe", deployer);
    console.log(`Funding with ${fundMe.address}`);
    const transaction = await fundMe.fund({value: ethers.utils.parseEther("0.1")});
    await transaction.wait(1);
    console.log("Funded");
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});