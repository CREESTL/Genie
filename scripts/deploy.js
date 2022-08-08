// SPDX-License-Identifier: MIT 
const { ethers, network } = require("hardhat");
const fs = require("fs");
const path = require("path");
const delay = require("delay");


let contractName = "CyberGenie";

// JSON file to keep information about previous deployments
const OUTPUT_DEPLOY = require("./deployOutput.json");
async function main() {

  console.log(`[${contractName}]: Start of Deployment...`);
  // Get the contract and deploy it
  _genie = await ethers.getContractFactory(contractName);
  genieTx = await _genie.deploy();
  let genie = await genieTx.deployed();

  console.log(`[${contractName}]: Deployment Finished!`);
  console.log(`[${contractName}]: Start of Verification...`);
  
  // Sleep for 90 seconds, otherwise block explorer will fail
  await delay(90000);
  
  // Verify the contract
  // Provides all contract's dependencies as separate files
  try { 
    await hre.run("verify:verify", {
      address: genie.address,
    });
  } catch (error) {
    console.error(error);
  }

  console.log(`[${contractName}]: Verification Finished!`);
  console.log(`See Results in "${__dirname + '/deployOutput.json'}" File`);

  // Write output to the JSON file
  OUTPUT_DEPLOY.networks[network.name].address = genie.address;
  OUTPUT_DEPLOY.networks[network.name].verification =
    "https://mumbai.polygonscan.com/address/" + genie.address + "#code";
  fs.writeFileSync(
    path.resolve(__dirname, "./deployOutput.json"),
    JSON.stringify(OUTPUT_DEPLOY, null, "  ")
  );
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
