// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicalNFT is ERC721 {
    address payable public owner;

    constructor() ERC721("MusicalNFT", "msclNFT") {}

    uint256 private _tokenId;
    
    function mintMusicalNFT(address artist) public {
        _tokenId += 1;
        _safeMint(artist, _tokenId);
    }

    function transferOwnerShipTo(address payable newOwner) public {
        owner = newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
