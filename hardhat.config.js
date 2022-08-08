// SPDX-License-Identifier: MIT

require('dotenv').config()
const { ethers } = require("ethers");
require("@nomicfoundation/hardhat-toolbox");

// Add some .env individual variables
const POLYGON_PRIVATE_KEY = process.env.POLYGON_PRIVATE_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;


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
      accounts: [process.env.POLYGON_PRIVATE_KEY]
    },
    // Polygon mainnet
    polygon: {
      url: "https://rpc-mainnet.maticvigil.com",
      accounts: [process.env.POLYGON_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
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
