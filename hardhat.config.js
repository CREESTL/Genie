// SPDX-License-Identifier: MIT

require('dotenv').config()
const { ethers } = require("ethers");
require("@nomicfoundation/hardhat-toolbox");

// Add some .env individual variables
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;
const INFURA_API_KEY = process.env.INFURA_API_KEY


module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    // a.k.a localhost
    hardhat: {
      gas: 2100000,
      gasPrice: 8000000000,
    },
    // Polygon Mumbai testnet
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    },
    // Polygon mainnet
    polygon: {
      url: "https://rpc-mainnet.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    },
    // Ethereum Rinkeby testnet
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    },
    // Ethereum mainnet
    ethereum: {
      url: `https://mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  // API keys used for automated verification of contracts on EVM comptatible chains
  etherscan: {
    apiKey: {
      polygon: process.env.POLYGONSCAN_API_KEY,
      polygonMumbai: process.env.POLYGONSCAN_API_KEY,
      ethereum: process.env.ETHERSCAN_API_KEY,
      rinkeby: process.env.ETHERSCAN_API_KEY,
    }
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000000000
  }
}
