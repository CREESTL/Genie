# Basic README.md

    If you are using Windows, we strongly recommend you use Windows Subsystem for Linux (also known as WSL 2). You can use Hardhat without it, but it will work better if you use it.

To install Node.js using WSL 2, please read this <a href="https://docs.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl">guide</a>
#
## First run
There are a few technical requirements before we start. Please install the following:

* <a href="https://nodejs.org/en/">Node.js v10+ LTS and npm</a> (comes with Node)
* <a href="https://git-scm.com/">Git</a>

Once we have those installed, you need to create an npm project by going to an empty folder, running npm init, and following its instructions to install Hardhat. Once your project is ready, you should run:

```shell
npm install --save-dev hardhat
```

```shell
npm install --save-dev @nomicfoundation/hardhat-toolbox @nomicfoundation/hardhat-network-helpers @nomicfoundation/hardhat-chai-matchers @nomiclabs/hardhat-ethers @nomiclabs/hardhat-etherscan chai ethers hardhat-gas-reporter solidity-coverage @typechain/hardhat typechain @typechain/ethers-v5 @ethersproject/abi @ethersproject/providers 
```
#

## Setting up the contract

* Go to ```hardhat.config.js```
* Update the ```hardhat-config``` with matic-network-credentials
* Create ```.env``` file in the root to store your private key
* Add Polygonscan API key to ```.env``` file to verify the contract on Polygonscan. You can generate an API key by <a href="https://polygonscan.com/register">creating an account</a>

**Example:** 
```
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  defaultNetwork: "matic",
  networks: {
    hardhat: {
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY
  },
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}
```
#
## Testing the Contract

To run tests with Hardhat, you just need to type the following:

```
npx hardhat test
```

And this is an expected output:

```
Token contract
    ✓ Test example (654ms)

1 passing (663ms)
```
#
## Deploying on Matic Network
Run this command in root of the project directory:

```
npx hardhat run scripts/deploy.js --network matic
```

The contract will be deployed on Matic's Mumbai Testnet, and you can check the deployment status here: https://mumbai.polygonscan.com/

If you want to change the network, you have to change the ```--network``` settings

#
Run the following commands to quickly verify your contract on Polygonscan. This makes it easy for anyone to see the source code of your deployed contract. For contracts that have a constructor with a complex argument list, <a href="https://hardhat.org/hardhat-runner/plugins/nomiclabs-hardhat-etherscan">see here</a>
```
npm install --save-dev @nomiclabs/hardhat-etherscan
npx hardhat verify --network matic 0x4b75233D4FacbAa94264930aC26f9983e50C11AF
```
#

## DOCUMENTATION:
* ### <a href="https://hardhat.org/docs">Hardhat documantation</a>
* ### <a href="https://docs.polygon.technology/docs/develop/hardhat">Polygon Wiki</a>


