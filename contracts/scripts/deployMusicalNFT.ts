import { ethers } from "hardhat";

async function main() {
   const arg1 = "MusicalNFT";
   const arg2 = "msclNFT";
   const MusicalNFT = await ethers.getContractFactory("MusicalNFT");
   const musicalNFT = await MusicalNFT.deploy(arg1, arg2);

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