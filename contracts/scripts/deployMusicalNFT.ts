import { artifacts, ethers } from "hardhat";

async function main() {
   const [deployer] = await ethers.getSigners();
   console.log("Deploying contracts with the account:", deployer.address);
   const MusicalNFT = await ethers.getContractFactory("MusicalNFT");
   const musicalNFT = await MusicalNFT.deploy("MusicalNFT", "msclNFT");

   await musicalNFT.waitForDeployment();
   const musicalNFTDeployedAddress = await musicalNFT.getAddress();
   console.log(`musicalNFT contract deployed to ${musicalNFTDeployedAddress}`);

   const MarketplaceContract = await ethers.getContractFactory("AriaCraftMarketPlace");
   const marketplaceContract = await MarketplaceContract.deploy(musicalNFTDeployedAddress);
   await marketplaceContract.waitForDeployment();
   console.log(`Marketplace contract deployed to ${await marketplaceContract.getAddress()}`);
   saveFrontendFiles(musicalNFT, "MusicalNFT");
   saveFrontendFiles(marketplaceContract, "AriaCraftMarketPlace");
}

function saveFrontendFiles(contract, name) {
   const fs = require("fs");
  const contractsDir = __dirname + "/../out/abi/";
 
   if (!fs.existsSync(contractsDir)) {
     fs.mkdirSync(contractsDir);
   }
 
   fs.writeFileSync(
     contractsDir + `/${name}-address.json`,
     JSON.stringify({ address: contract.target }, undefined, 2)
   );
 
  const contractArtifact = artifacts.readArtifactSync(name)
 
   fs.writeFileSync(
     contractsDir + `/${name}.json`,
     JSON.stringify(contractArtifact, null, 2)
   );
 }

main().catch((error) => {
   console.error(error);
   process.exitCode = 1;
});