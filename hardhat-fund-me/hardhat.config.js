require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");

// import from .env file

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // solidity: "0.8.28",
  solidity: {
    compilers:[
      {version: "0.8.28"},
      {version: "0.8.0"},
    ]
  },
  networks: {
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: SEPOLIA_PRIVATE_KEY,
      chainId: 11155111,
      blockConfirmation: 6,
    }
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    name: {
      default: 1,
    }
  },
};
