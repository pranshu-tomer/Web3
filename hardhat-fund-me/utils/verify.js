const { run } = require("hardhat");

const verify = async (contractAddress, args) => {
    console.log(`Verifying contract at address: ${contractAddress} with args: ${args}`);
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args
        });
    }catch (e){
        if(e.message.includes("already verified")){
            console.log("Contract source code already verified");
        }else{
            console.log("Failed to verify contract source code");
        }
    }
}

module.exports = {verify};

