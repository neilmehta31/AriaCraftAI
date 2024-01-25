// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicalNFT is ERC721 {
    address payable public owner;

    error ERC721WrongContractOwner(address owner); 

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        name = name;
        symbol = symbol;
    }

    uint256 private _nextTokenId;
    
    function mintMusicalNFT(address user) public returns (uint256){
        uint256 tokenId = _nextTokenId++;
        _safeMint(user, tokenId, "data");
        return tokenId;
    }

    function transferMusicalNFT(uint256 tokenId, address from, address to) public {
        safeTransferFrom(from, to, tokenId);
    }

    function transferContractOwnershipTo(address payable newContractOwner) public {
        if( msg.sender != owner){
            console.log("msg.sender : %s  current owner : %s  newProbableOwner : %s ", msg.sender, owner, newContractOwner);
            revert ERC721WrongContractOwner(msg.sender);
        }
        owner = newContractOwner;
    }

    function getContractOwner() public view returns (address) {
        return owner;
    }


}
