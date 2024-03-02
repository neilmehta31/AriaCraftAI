// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "./MusicalNft.sol";

contract AriaCraftMarketPlace {
    address public musicalNFT;

    constructor(address _musicalNFT) {
        musicalNFT = _musicalNFT;
    }

    function registerMusic(string memory deployedMusicUrl) public {
        console.log("Your NFT at the url : %s is being minted", deployedMusicUrl);
        uint256 musicalNFTreferenceId = MusicalNFT(musicalNFT).mintMusicalNFT(msg.sender, deployedMusicUrl);
        console.log("Your musical NFT has been minted. Here's your unique Id requested %s", musicalNFTreferenceId);
    }

    function payMarketplaceOwnerOnregistration() public {}

    function generateMusic() public {}
}
