const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AriaCraftMarketPlace", function () {
    let marketplaceContract;
    let musicalNft;
    let owner;
    let addr1;
    let addr2;
    let addr3;
    let newNft;
    let MarketplaceContract;
    let MusicalNFT;

    beforeEach(async () => {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();
        console.log("owner : ", owner.address, "\naddr1 : ",  addr1.address,"\naddr2 : ", addr2.address,"\naddr3 : ", addr3.address)
        MarketplaceContract = await ethers.getContractFactory("AriaCraftMarketPlace");
        MusicalNFT = await ethers.getContractFactory("MusicalNFT");
        musicalNft = await MusicalNFT.deploy("MusicalNFT", "MNFT");
        marketplaceContract = await MarketplaceContract.deploy(1); // Pass platform fee as 1 for testing
        newNft = await musicalNft
            .mintMusicalNFT("Neil", "soothing song", "ipfsFile://", { value: ethers.parseEther("0.1") });
    });

    it("check for the name and the symbol of the NFT", async () => {
        const nftName = "MusicalNFT";
        const nftSymbol = "MNFT";
        expect(await musicalNft.name()).to.equal(nftName);
        expect(await musicalNft.symbol()).to.equal(nftSymbol);
    });

    it("register a musicalNFT", async () => {
        const tx = await musicalNft
            .mintMusicalNFT("Neil", "soothing song", "ipfsFile://", { value: ethers.parseEther("0.1") });
        const rc = await tx.wait();
        const event = rc.logs?.find(event => event.fragment?.name === 'MusicalMEtaData');
        // console.log(event.args);
        expect(event.args[0]).to.deep.equal(["Neil", "soothing song", "ipfsFile://"])
        expect(event.args[1]).to.equal(1);

        const tx2 = await musicalNft
            .mintMusicalNFT("Yash", "another", "ipfsFile://hosted", { value: ethers.parseEther("0.1") });
        const rc2 = await tx2.wait();
        const event2 = rc2.logs?.find(event => event.fragment?.name === 'MusicalMEtaData');
        // console.log(event2.args);
        expect(event2.args[0]).to.deep.equal(["Yash", "another", "ipfsFile://hosted"]);
        expect(event2.args[1]).to.equal(2);
    });

    it("should register an NFT and emit Offered event", async function () {
        const tokenId = await marketplaceContract.itemCount(); // Example token ID
        const price = ethers.parseEther("4.57"); // Example price in Ether
        await musicalNft.setApprovalForAll(marketplaceContract.target, true)
        console.log("\n---------------------------------\n");
        const itemId = await marketplaceContract
            .registerNFT(tokenId, musicalNft, price, { value: ethers.parseEther("0.5") });
        console.log("\n---------------------------------\n");
    
        // console.log("-----------------------------------\nitemId:",itemId, "-----------------------------------\n");
        // const item = await marketplaceContract.getUpdatedDataForItem(itemId);
        // console.log("-----------------------------------\nitem: ",item,"-----------------------------------\n")
        // expect(item.itemId).to.equal(1);
        // expect(item._nft).to.equal(newNft1.address);
        // expect(item.tokenId).to.equal(tokenId);
        // expect(item.price).to.equal(price);
        // expect(item.seller).to.equal(addr1.address);
        // expect(item.sold).to.be.false;
    });

    it("should update pricing of an NFT and emit PriceUpdated event", async function () {
        const tokenId = 1; // Example token ID
        const updatedPrice = ethers.parseEther("2"); // Updated price in Ether

        await marketplaceContract.registerNFT(tokenId, owner.address, ethers.parseEther("1"));
        await marketplaceContract.updatePricing(1, updatedPrice);
        const item = await marketplaceContract.getUpdatedDataForItem(1);

        expect(item.price).to.equal(updatedPrice);

        // Add more assertions as needed
    });
})