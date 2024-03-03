// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "./MusicalNft.sol";

// listItem: Creates a listing for an NFT owned by the caller, specifies the price, and emits a ItemListed event.
// updateListing: Allows the seller to modify the price of an existing listing without canceling it.
// cancelListing: Lets the seller remove a listing from the marketplace.
// buyItem: Buys an NFT from the marketplace, transferring ownership to the buyer and sending the purchased amount to the seller.
// fetchMarketItems: Returns a list of currently active listings, filtered by criteria such as category, price range, or seller.
// getItemDetails: Retrieves detailed information about a specific NFT listing, including price, seller, and additional metadata.
// getSellerProceeds: Calculates and retrieves the earnings accrued by a given seller across all their listed NFTs.
// getTotalSupplyOfListedAssets: Counts the total number of NFTs listed on the marketplace.
// getNumberOfListingsForSeller: Queries the number of listings created by a specified seller.
// getNumberOfListingsWithPriceRange: Finds the count of listings falling within a given price range.
// getNumberOfListingsByCategory: Determines the number of listings belonging to a specific category.
// getHighestBidsOnNFT: Identifies the highest bids placed on a particular NFT.
// getLowestPriceAvailable: Locates the lowest price among all listed NFTs.
// getTopSellers: Discovers the top sellers ranked by their cumulative earnings.

contract AriaCraftMarketPlace {
    // Mapping from tokenId to its prices
    mapping(uint256 => uint256) private _listing;

    MusicalNFT private _musicalNFT;

    event PriceUpdated(uint256 token, uint256 price);

    constructor(address _musicalNFTaddr) {
        _musicalNFT = MusicalNFT(payable(_musicalNFTaddr));
    }

    function registerMusic(
        string memory artistName,
        string memory genre,
        string memory deployedMusicUrl,
        uint256 price
    ) public returns (uint256) {
        console.log(
            "Your NFT at the url : %s is being minted. Owner of this NFT is : %s",
            deployedMusicUrl,
            msg.sender
        );
        uint256 musicalNFTreferenceId = _musicalNFT.mintMusicalNFT(
            artistName,
            genre,
            deployedMusicUrl
        );
        _updateListItem(musicalNFTreferenceId, price);
        console.log(
            "Your musical NFT has been minted. Here's your unique Id requested %s",
            musicalNFTreferenceId
        );
        return musicalNFTreferenceId;
    }

    function updateListing(uint256 tokenId, uint256 updatedPrice) public {
        _updateListItem(tokenId, updatedPrice);
    }

    function cancleListing(uint256 tokenId) public {
        require(msg.sender == _musicalNFT.ownerOf(tokenId));
        delete _listing[tokenId];
        emit PriceUpdated(tokenId, 0);
    }

    function _updateListItem(uint256 tokenId, uint256 price) private {
        _listing[tokenId] = price;
        emit PriceUpdated(tokenId, price);
        console.log("Your musical NFT price has been listed for %s", price);
    }

    function buyMusicalNFT(uint256 tokenId) public {
        require(msg.sender != _musicalNFT.ownerOf(tokenId));
        require(msg.sender.balance >= _listing[tokenId]);

        payable(_musicalNFT.ownerOf(tokenId)).transfer(_listing[tokenId]);
        console.log(
            "listing price %s transfered to owner %s of the NFT",
            _listing[tokenId],
            _musicalNFT.ownerOf(tokenId)
        );
        _musicalNFT.transferMusicalNFT(
            tokenId,
            _musicalNFT.ownerOf(tokenId),
            msg.sender
        );
    }

    function fetchActiveMarketItems() public view returns (uint256[] memory) {
        // /Currently supporting only 100 listings.
        uint256[] memory activeListings = new uint256[](100);
        for (uint i = 0; i < 100; i++) {
            if (_listing[i] != 0) {
                activeListings[i] = _listing[i];
            }
        }
        return activeListings;
    }

    receive() external payable {}
}
