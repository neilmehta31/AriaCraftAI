// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "./MusicalNft.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// listItem: Creates a listing for an NFT owned by the caller, specifies the price, and emits a ItemListed event.
// updateListing: Allows the seller to modify the price of an existing listing without canceling it.
// cancelListing: Lets the seller remove a listing from the marketplace.
// buyItem: Buys an NFT from the marketplace, transferring ownership to the buyer and sending the purchased amount to the seller.
// getItemDetails: Retrieves detailed information about a specific NFT listing, including price, seller, and additional metadata.

// Below all functionalities should be handled by the emit functionality using a DB.
// fetchMarketItems: Returns a list of currently active listings, filtered by criteria such as category, price range, or seller.
// getSellerProceeds: Calculates and retrieves the earnings accrued by a given seller across all their listed NFTs.
// getTotalSupplyOfListedAssets: Counts the total number of NFTs listed on the marketplace.
// getNumberOfListingsForSeller: Queries the number of listings created by a specified seller.
// getNumberOfListingsWithPriceRange: Finds the count of listings falling within a given price range.
// getNumberOfListingsByCategory: Determines the number of listings belonging to a specific category.
// getHighestBidsOnNFT: Identifies the highest bids placed on a particular NFT.
// getLowestPriceAvailable: Locates the lowest price among all listed NFTs.
// getTopSellers: Discovers the top sellers ranked by their cumulative earnings.

contract AriaCraftMarketPlace is ReentrancyGuard {
    address payable marketplaceOwneraddr;
    uint256 public itemCount;
    uint256 private _platformFee;

    struct MarketplaceItem {
        uint itemId;
        IERC721 _nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    mapping(uint => MarketplaceItem) public marketplaceItems;

    event PriceUpdated(
        uint itemId,
        IERC721 _nft,
        uint tokenId,
        uint updatedPrice,
        address payable seller
    );

    event Offered(
        uint itemId,
        IERC721 _nft,
        uint tokenId,
        uint price,
        address payable seller
    );

    event Purchased(
        uint itemId,
        IERC721 _nft,
        uint tokenId,
        uint price,
        address payable buyer
    );

    event ItemUnlisted(uint itemId, IERC721 _nft, uint tokenId);

    constructor(uint256 platformFee) {
        marketplaceOwneraddr = payable(msg.sender);
        _platformFee = platformFee;
    }

    function registerNFT(
        uint256 _tokenId,
        IERC721 _nft,
        uint256 _price
    ) external payable nonReentrant {
        // Need approval from the msg.sender for transfering the
        // NFT ownership to the marketplace\

        require(_price > 0, "NFT price must be greater than zero");

        // Registering the NFT to the marketplace requires the seller
        // to pay 0.1 ethers to the owner of the marketplace
        require(
            msg.value >= 0.01 ether,
            "msg.value should be greater than 0.01 ethers"
        );
        require(
            msg.sender.balance >= 0.01 ether,
            "msg.sender.balance should be greater than 0.01 ethers"
        );
        itemCount++;
        _nft.transferFrom(msg.sender, address(this), _tokenId);

        payable(address(this)).transfer(0.01 ether);
        marketplaceItems[itemCount] = MarketplaceItem(
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );

        emit Offered(itemCount, _nft, _tokenId, _price, payable(msg.sender));
    }

    function buyItem(uint _itemId) external payable nonReentrant {
        MarketplaceItem storage item = marketplaceItems[_itemId];
        uint _totalPrice = getTotalPrice(_itemId);
        require(item.itemId != 0, "Item is unlisted from the marketplace");
        require(
            msg.value >= _totalPrice,
            "msg.value should be greater than the _totalPrice"
        );
        require(
            _itemId > 0 && _itemId < itemCount,
            "The token does not exists"
        );
        require(!item.sold, "Item is already sold");
        item.seller.transfer(item.price);
        marketplaceOwneraddr.transfer(_totalPrice - item.price);

        item.sold = true;
        item._nft.transferFrom(address(this), msg.sender, item.tokenId);

        emit Purchased(
            _itemId,
            item._nft,
            item.tokenId,
            item.price,
            payable(msg.sender)
        );
    }

    function updatePricing(uint256 _itemId, uint256 updatedPrice) external {
        require(
            _itemId > 0 && _itemId < itemCount,
            "The token does not exists"
        );
        require(updatedPrice > 0, "only non zero pricing allowed");
        MarketplaceItem storage item = marketplaceItems[_itemId];
        require(!item.sold, "Item is already sold");
        require(item.itemId != 0, "Item is unlisted from the marketplace");
        require(
            item.seller == msg.sender,
            "Only the seller of this item can update the listing price"
        );
        marketplaceItems[_itemId].price = updatedPrice;
        emit PriceUpdated(
            _itemId,
            item._nft,
            item.tokenId,
            updatedPrice,
            payable(msg.sender)
        );
    }

    function cancleListing(uint256 _itemId) external {
        require(
            _itemId > 0 && _itemId < itemCount,
            "The token does not exists"
        );
        MarketplaceItem storage item = marketplaceItems[_itemId];
        item.itemId = 0;
        emit ItemUnlisted(_itemId, item._nft, item.tokenId);
    }

    // getAllActiveItems should be controlled by the events emitted while creating and unliting the items
    // This should be better than to iterate on the mapping in EVM. This gives error of memory and storage
    // function getAllActiveListingOfMarketplace()
    //     external
    //     view
    //     returns (uint256[] memory)
    // {
    //     uint256[] memory activeListingItemIds;
    //     for (uint _itemId = 0; _itemId <= itemCount; _itemId++) {
    //         MarketplaceItem storage item = marketplaceItems[_itemId];
    //         if (item.price != 0 && item.itemId != 0 && !item.sold) {
    //             activeListingItemIds.push(_itemId);
    //         }
    //     }
    //     return activeListingItemIds;
    // }

    function getUpdatedDataForItem(
        uint256 _itemId
    ) external view returns (MarketplaceItem memory) {
        return marketplaceItems[_itemId];
    }

    function getTotalPrice(uint _itemId) public view returns (uint) {
        return ((marketplaceItems[_itemId].price * (100 + _platformFee)) / 100);
    }

    receive() external payable {
        // emit EtherRecieved(msg.sender, msg.value);
        console.log(
            "Marketplace contract: %s Ether recieved from sender(%s) to owner(%s)",
            msg.value,
            msg.sender
        );
        // withdraw();
    }
}
