import { ethers } from "hardhat";

async function main() {
   const arg1 = "MusicalNFT";
   const arg2 = "msclNFT";
   const MyContract = await ethers.getContractFactory("MusicalNFT");
   const myContract = await MyContract.deploy(arg1, arg2);

   await myContract.waitForDeployment();

   console.log(`VLX Token deployed to ${myContract.getAddress}`);
}

main().catch((error) => {
   console.error(error);
   process.exitCode = 1;
});
