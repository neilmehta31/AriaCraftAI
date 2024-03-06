import { ethers } from "hardhat";

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
   
}

main().catch((error) => {
   console.error(error);
   process.exitCode = 1;
});