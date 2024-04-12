// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
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

    event MusicalMEtaData(MusicalNFTMetadata metadata, uint256 tokenId);

    function mintMusicalNFT(
        string memory artistName,
        string memory genre,
        string memory linkToMusic
    ) public payable returns (uint256) {
        require(
            msg.sender.balance >= 0.01 ether,
            "Owner balance must be at least 0.01 ether"
        );
        require(
            msg.value >= 0.01 ether,
            "msg.value must be greater than 0.01 ethers"
        );
        // Minting the musicalNFT will require 0.001 ether to be sent to the owner as a fee/royalty!
        require(msg.value >= 0.01 ether, "Insufficient Ether sent");
        console.log("Payment init msg.value: ", msg.value);
        payable(address(this)).transfer(0.01 ether);
        console.log("Payment done");

        uint256 newTokenId = _counter;
        _mint(msg.sender, newTokenId);
        MusicalNFTMetadata memory metadata = MusicalNFTMetadata(
            artistName,
            genre,
            linkToMusic
        );
        _musicMetadata[newTokenId] = metadata;
        emit MusicalMEtaData(metadata, newTokenId);
        _counter += 1;
        return newTokenId;
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
        console.log(
            "msg.sender : %s  current owner : %s  New Owner : %s ",
            msg.sender,
            owner,
            newContractOwner
        );
        owner = newContractOwner;
    }

    receive() external payable {
        // emit EtherRecieved(msg.sender, msg.value);
        // console.log(
        //     "%s Ether recieved from sender(%s) to owner(%s)",
        //     msg.value,
        //     msg.sender,
        //     owner
        // );
        // withdraw();
    }

    function withdraw() public {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}
