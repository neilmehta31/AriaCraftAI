// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicalNFT is ERC721 {
    address payable public owner;
    uint256 private _counter;

    struct MusicalNFTMetadata {
        string artistName;
        string genre;
        string linkToMusic;
    }

    mapping(uint256 => MusicalNFTMetadata) private _musicMetadata;

    error ERC721WrongContractOwner(address owner);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = payable(msg.sender);
    }

    event EtherRecieved(address payer, uint256 amount);

    function mintMusicalNFT(
        address recipient,
        string memory artistName,
        string memory genre,
        string memory linkToMusic
    ) public payable returns (uint256) {
        require(msg.sender.balance >= 0.001 ether);

        // Minting the musicalNFT will require 0.001 ether to be sent to the owner as a fee/royalty!
        owner.transfer(0.001 ether);

        uint256 newTokenId = _counter;
        _mint(recipient, newTokenId);
        MusicalNFTMetadata memory metadata = MusicalNFTMetadata(
            artistName,
            genre,
            linkToMusic
        );
        _musicMetadata[newTokenId] = metadata;
        _counter += 1;
        return _counter;
    }

    function getMusicMetadata(
        uint256 tokenId
    )
        public
        view
        returns (
            string memory artistName,
            string memory genre,
            string memory linkToMusic
        )
    {
        return (
            _musicMetadata[tokenId].artistName,
            _musicMetadata[tokenId].genre,
            _musicMetadata[tokenId].linkToMusic
        );
    }

    function transferMusicalNFT(
        uint256 tokenId,
        address from,
        address to
    ) public {
        safeTransferFrom(from, to, tokenId);
    }

    function transferContractOwnershipTo(
        address payable newContractOwner
    ) public {
        if (msg.sender != owner) {
            console.log(
                "msg.sender : %s  current owner : %s  newProbableOwner : %s ",
                msg.sender,
                owner,
                newContractOwner
            );
            revert ERC721WrongContractOwner(msg.sender);
        }
        owner = newContractOwner;
    }

    receive() external payable {
        emit EtherRecieved(msg.sender, msg.value);
        console.log(
            "%s Ether recieved from sender(%s) to owner($s)",
            msg.value,
            msg.sender,
            owner
        );
    }
}
