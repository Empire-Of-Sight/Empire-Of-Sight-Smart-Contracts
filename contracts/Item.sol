/// SPDX-License-Identifier: Unveiled Tech License

/// 2023 Unveiled Tech. All rights reserved.

/// This smart contract and any part thereof, including but not limited to the source code,
/// documentation, and any associated artifacts, may not be used, copied, modified,
/// sublicensed, or distributed, in whole or in part, without the express written
/// permission of Unveiled Tech.

/// ██    ██ ███    ██ ██    ██ ███████ ██ ██      ███████ ██████      ████████ ███████  ██████ ██   ██
/// ██    ██ ████   ██ ██    ██ ██      ██ ██      ██      ██   ██        ██    ██      ██      ██   ██
/// ██    ██ ██ ██  ██ ██    ██ █████   ██ ██      █████   ██   ██        ██    █████   ██      ███████
/// ██    ██ ██  ██ ██  ██  ██  ██      ██ ██      ██      ██   ██        ██    ██      ██      ██   ██
///  ██████  ██   ████   ████   ███████ ██ ███████ ███████ ██████         ██    ███████  ██████ ██   ██

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title Empire of Sight Item Contract
/// @dev Extends ERC-1155 basic standard multi-token implementation with various features for the highest safety
/// and the best gaming experience.
/// @notice Play https://empireofsight.com
/// @author leeevi, Unveiled Tech
contract Item is ERC1155, Ownable, ReentrancyGuard {
    /// Solidity's arithmetic operations with added overflow checks.
    using SafeMath for uint256;
    using Strings for uint256;

    /// All the attributes of an item
    struct ItemInfo {
        uint256 minted;
        uint256 totalSupply;
        uint256 priceUsd; // (USD value in Wei)
        bool paused;
    }

    /// Pack contains multiple types of items for batch transactions.
    struct PackInfo {
        uint256[] itemIds;
        uint256[] itemAmounts;
        uint256 priceUsd; // (USD value in Wei)
        bool paused;
    }

    /// ERC-20 token and its price oracle.
    struct ERC20TokenInfo {
        IERC20 tokenContract;
        AggregatorV3Interface priceOracle;
        bool paused;
    }

    /// Tracking the item IDs.
    uint256 public itemIds;

    /// Cost of Mayne Transmuting items.
    uint256 public transmuteFee;

    /// Cost of batch Mayne Transmuting items.
    uint256 public transmuteFeeBatch;

    /// Sum of received transmuting fees counts from the last withdrawal.
    uint256 public transmuteFeeSum;

    // Limit of the ERC-20 token withdrawal amount in one transaction.
    uint256 internal _ERC20WithdrawalLimit = 5;

    /// Pause for minting.
    bool public pausedMint;

    /// Pause for Mayne Transmuting.
    bool public pausedMayneTransmute;

    /// Pause for burning.
    bool public pausedBurn;

    /// Minter role.
    mapping(address => bool) internal minters;

    /// Items (item ID => {item minted, item total supply, item price, item pause}).
    mapping(uint256 => ItemInfo) public items;

    /// Pack for a batch transaction (pack ID => {item IDs, item amounts, pack price, pack pause}).
    mapping(uint256 => PackInfo) public packs;

    /// ERC-20 tokens for payment (token ID => {token contract, price oracle, token pause}).
    mapping(uint256 => ERC20TokenInfo) public ERC20Tokens;

    /// Chainlink Data Feed of blockchain's native currency.
    AggregatorV3Interface internal _priceOracle;

    /// Minted item(s).
    event Minted(
        address player,
        uint256 id,
        uint256 amount,
        bool isTransmuting
    );

    /// Batch minted items.
    event MintedBatch(
        address player,
        uint256[] ids,
        uint256[] amounts,
        bool isTransmuting
    );

    /// Batch minted pack(s).
    event MintedPack(address player, uint256 packId, uint256 amount);

    /// Mayne Transmuted item(s).
    event Transmuted(
        address player,
        uint256 id,
        uint256[] amounts,
        uint256[] slots
    );

    /// Batch Mayne Transmuted items.
    event TransmutedBatch(
        address player,
        uint256[] ids,
        uint256[] amounts,
        uint256[] slots
    );

    /// Burnt item(s).
    event Burnt(
        address player,
        uint256 id,
        uint256 amount,
        bool isVirtualizing,
        bool isBridging
    );

    /// Burnt items in a batch transaction.
    event BurntBatch(
        address player,
        uint256[] id,
        uint256[] amount,
        bool isVirtualizing,
        bool isBridging
    );

    ///-------------------------------------------------------------------------
    /// CONSTRUCTOR ////////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Initializes the contract with default values and item types.
    constructor()
        ERC1155("https://empireofsight.com/metadata/items/{id}.json")
    {
        _priceOracle = AggregatorV3Interface(
            0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
        );
        address minter = 0x947E0Cc54fB2a758Ab605da79aa6317D26A8A355;
        minters[minter] = true;
        transmuteFee = 0 ether;
        transmuteFeeBatch = 0 ether;
        transmuteFeeSum = 0;
        pausedMint = false;
        pausedMayneTransmute = false;
        pausedBurn = false;

        // Initialize items
        items[0] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 5.99 ether, /// $5.99
            paused: false
        });

        items[1] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 5.99 ether, /// $5.99
            paused: false
        });

        items[2] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 3.99 ether, /// $3.99
            paused: false
        });

        items[3] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 4.99 ether, /// $4.99
            paused: false
        });

        items[4] = ItemInfo({
            minted: 0,
            totalSupply: 10000,
            priceUsd: 3.99 ether, /// $3.99
            paused: false
        });

        // Initialize other items with default values
        for (uint16 i = 5; i <= 39; ++i) {
            items[i] = ItemInfo({
                minted: 0,
                totalSupply: 10000,
                priceUsd: 0,
                paused: true
            });
        }

        itemIds = 39;
    }

    function uri(
        uint256 _tokenid
    ) public pure override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://empireofsight.com/metadata/items/",
                    Strings.toString(_tokenid),
                    ".json"
                )
            );
    }

    ///-------------------------------------------------------------------------
    /// MODIFIER /////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Modifier to restrict access to only minter.
    modifier onlyWithRole() {
        require(minters[msg.sender] || owner() == msg.sender, "not minter");
        _;
    }

    ///-------------------------------------------------------------------------
    /// VIEW FUNCTIONS /////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Returns the latest price of the native currency.
    /// @return The latest price of the native currency.
    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = _priceOracle.latestRoundData();
        require(price > 0, "price not available");

        return uint256(price);
    }

    /// @dev Returns the latest price of an ERC20 token.
    /// @param tokenId The ID of the ERC20 token.
    /// @return The latest price of the token.
    function getLatestTokenPrice(
        uint256 tokenId
    ) public view returns (uint256) {
        require(
            ERC20Tokens[tokenId].tokenContract != IERC20(address(0)),
            "token not set"
        );

        AggregatorV3Interface priceOracle = ERC20Tokens[tokenId].priceOracle;
        (, int256 price, , , ) = priceOracle.latestRoundData();
        require(price > 0, "price not available");

        return uint256(price);
    }

    /// @dev Returns the price in native currency to purchase a specific item.
    /// @param id The ID of the item.
    /// @param amount The number of items to purchase.
    /// @return The price in native currency.
    function getItemsNativePrice(
        uint256 id,
        uint256 amount
    ) public view returns (uint256) {
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");

        uint256 nativeCurrencyPrice = getLatestPrice();
        return
            items[id].priceUsd.mul(10 ** 8).div(nativeCurrencyPrice).mul(
                amount
            );
    }

    /// @dev Returns the price in native currency to purchase a pack.
    /// @param packId The ID of the pack.
    /// @param amount The number of packs to purchase.
    /// @return The price in native currency.
    function getPacksNativePrice(
        uint256 packId,
        uint256 amount
    ) public view returns (uint256) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount can't be zero");

        uint256 nativeCurrencyPrice = getLatestPrice();
        return
            packs[packId].priceUsd.mul(10 ** 8).div(nativeCurrencyPrice).mul(
                amount
            );
    }

    /// @dev Returns the price in ERC20 tokens to purchase a specific item.
    /// @param id The ID of the item.
    /// @param amount The number of items to purchase.
    /// @param tokenId The ID of the ERC20 token used for pricing.
    /// @return The price in ERC20 tokens.
    function getItemsTokenPrice(
        uint256 id,
        uint256 amount,
        uint256 tokenId
    ) public view returns (uint256) {
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            ERC20Tokens[tokenId].tokenContract != IERC20(address(0)),
            "token not set"
        );

        uint256 tokenPrice = getLatestTokenPrice(tokenId);
        return items[id].priceUsd.mul(10 ** 8).div(tokenPrice).mul(amount);
    }

    /// @dev Returns the price in ERC20 tokens to purchase a pack.
    /// @param packId The ID of the pack.
    /// @param amount The number of packs to purchase.
    /// @param tokenId The ID of the ERC20 token used for pricing.
    /// @return The price in ERC20 tokens.
    function getPacksTokenPrice(
        uint256 packId,
        uint256 amount,
        uint256 tokenId
    ) public view returns (uint256) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            ERC20Tokens[tokenId].tokenContract != IERC20(address(0)),
            "token not set"
        );

        uint256 tokenPrice = getLatestTokenPrice(tokenId);
        return packs[packId].priceUsd.mul(10 ** 8).div(tokenPrice).mul(amount);
    }

    /// @dev Returns the item IDs in a pack.
    /// @param packId The ID of the pack.
    /// @return An array of item IDs in the pack.
    function getItemsInPack(
        uint256 packId
    ) public view returns (uint256[] memory) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");

        return packs[packId].itemIds;
    }

    /// @dev Returns the amounts of items in a pack.
    /// @param packId The ID of the pack.
    /// @return An array of item amounts in the pack.
    function getAmountsInPack(
        uint256 packId
    ) public view returns (uint256[] memory) {
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");

        return packs[packId].itemAmounts;
    }

    ///-------------------------------------------------------------------------
    /// SET FUNCTIONS //////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Sets the base URI for token metadata.
    /// @param newuri The new base URI to be set.
    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    /// @dev Toggles the pause status for the mayneTransmute function.
    function setPauseMayneTransmute() external onlyOwner {
        pausedMayneTransmute = !pausedMayneTransmute;
    }

    /// @dev Toggles the pause status for the burn function.
    function setPauseBurn() external onlyOwner {
        pausedBurn = !pausedBurn;
    }

    /// @dev Toggles the pause status for all functions in the contract.
    function setPauseMint() external onlyOwner {
        pausedMint = !pausedMint;
    }

    /// @dev Sets the details of multiple packs.
    /// @notice The `priceUsd` must be in Wei.
    /// @param packIds The IDs of the packs.
    /// @param packInfoList The list of pack details including price and items.
    function setPacks(
        uint256[] memory packIds,
        PackInfo[] calldata packInfoList
    ) external onlyOwner {
        require(
            packIds.length > 0 && packIds.length == packInfoList.length,
            "invalid arrays"
        );

        for (uint256 i = 0; i < packIds.length; ++i) {
            PackInfo storage pack = packs[packIds[i]];
            PackInfo memory packInfo = packInfoList[i];

            require(
                packInfo.itemIds.length <= itemIds + 1,
                "pack contains an item that doesn't exist"
            );
            require(
                packInfo.itemIds.length == packInfo.itemAmounts.length,
                "item IDs and amounts must have the same length"
            );

            pack.priceUsd = packInfo.priceUsd;
            pack.itemIds = packInfo.itemIds;
            pack.itemAmounts = packInfo.itemAmounts;
            pack.paused = packInfo.paused;
        }
    }

    /// @dev Sets the transmute fee for transmuting a single item.
    /// @notice `fee` must be in Wei!
    /// @param fee The new transmute fee.
    function setTransmuteFee(uint256 fee) external onlyOwner {
        transmuteFee = fee;
    }

    /// @dev Sets the transmute fee for transmuting multiple items in a batch.
    /// @notice `fee` must be in Wei!
    /// @param fee The new transmute fee.
    function setTransmuteFeeBatch(uint256 fee) external onlyOwner {
        transmuteFeeBatch = fee;
    }

    /// @dev Sets the ERC20 token and price oracle for a given token ID.
    /// @param tokenId The ID of the ERC20 token.
    /// @param ERC20TokenAddress The address of the ERC20 token contract.
    /// @param priceOracleAddress The address of the price oracle contract.
    function setERC20Token(
        uint256 tokenId,
        address ERC20TokenAddress,
        address priceOracleAddress,
        bool paused
    ) external onlyOwner {
        require(
            ERC20TokenAddress != address(0),
            "token address can't be null address"
        );
        require(
            priceOracleAddress != address(0),
            "price oracle address can't be null address"
        );

        IERC20 tokenContract = IERC20(ERC20TokenAddress);
        require(tokenContract.totalSupply() > 0, "token contract is not valid");

        AggregatorV3Interface priceOracle = AggregatorV3Interface(
            priceOracleAddress
        );
        (, int256 price, , , ) = priceOracle.latestRoundData();
        require(price > 0, "price oracle contract is not valid");

        ERC20Tokens[tokenId] = ERC20TokenInfo(
            tokenContract,
            priceOracle,
            paused
        );
    }

    /// @dev Sets the price oracle address for the native currency.
    /// @param priceOracleAddress The address of the price oracle contract.
    function setNativePriceOracle(
        address priceOracleAddress
    ) external onlyOwner {
        require(
            priceOracleAddress != address(0),
            "price oracle address can't be null address"
        );

        _priceOracle = AggregatorV3Interface(priceOracleAddress);
    }

    ///-------------------------------------------------------------------------
    /// PLAYER FUNCTIONS ///////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Mints items using native currency (Ether) as payment.
    /// @param id The ID of the item to mint.
    /// @param amount The number of items to mint.
    function mint(uint256 id, uint256 amount) external payable nonReentrant {
        require(!pausedMint, "minting is paused for all items");
        require(!items[id].paused, "minting is paused for this item");
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            msg.value >= getItemsNativePrice(id, amount),
            "sent value not enough"
        );
        require(
            items[id].minted + amount <= items[id].totalSupply,
            "amount exceeds total supply"
        );
        require(msg.sender != address(0), "sender can't be null address");

        _mint(msg.sender, id, amount, "");
        items[id].minted += amount;

        emit Minted(msg.sender, id, amount, false);
    }

    /// @dev Mints items using ERC-20 tokens as payment.
    /// @param id The ID of the item to mint.
    /// @param amount The number of items to mint.
    /// @param ERC20TokenId The ID of the ERC-20 token used for payment.
    /// @param value The value of the ERC-20 tokens sent for payment.
    function mintWithERC20(
        uint256 id,
        uint256 amount,
        uint256 ERC20TokenId,
        uint256 value
    ) external nonReentrant {
        require(
            !pausedMint &&
                !items[id].paused &&
                !ERC20Tokens[ERC20TokenId].paused,
            "minting or paying is paused"
        );
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            items[id].minted + amount <= items[id].totalSupply,
            "amount exceeds total supply"
        );
        require(
            ERC20Tokens[ERC20TokenId].tokenContract != IERC20(address(0)),
            "token not set"
        );
        require(
            value >= getItemsTokenPrice(id, amount, ERC20TokenId),
            "sent value not enough"
        );
        require(msg.sender != address(0), "sender can't be null address");

        IERC20 tokenContract = ERC20Tokens[ERC20TokenId].tokenContract;
        tokenContract.transferFrom(msg.sender, address(this), value);

        _mint(msg.sender, id, amount, "");
        items[id].minted += amount;

        emit Minted(msg.sender, id, amount, false);
    }

    /// @dev Checks if the specified items can be minted in the given amounts.
    /// @param itemIdsArray An array containing the IDs of the items to check.
    /// @param itemAmounts An array containing the amounts of items to check.
    /// @param amount The multiplier for the item amounts.
    function requireItemsMintable(
        uint256[] memory itemIdsArray,
        uint256[] memory itemAmounts,
        uint256 amount
    ) internal view {
        for (uint256 i = 0; i < itemIdsArray.length; ++i) {
            ItemInfo storage item = items[itemIdsArray[i]];
            require(
                item.minted + itemAmounts[i] * amount <= item.totalSupply,
                "amount exceeds total supply"
            );
        }
    }

    /// @dev Mints a pack of items using native currency as payment.
    /// @param packId The ID of the pack to mint.
    /// @param amount The number of packs to mint.
    function mintPack(
        uint256 packId,
        uint256 amount
    ) external payable nonReentrant {
        require(
            !pausedMint && !packs[packId].paused,
            "minting or pack is paused"
        );
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount can't be zero");
        require(
            msg.value >= getPacksNativePrice(packId, amount),
            "sent value not enough"
        );
        require(msg.sender != address(0), "sender can't be null address");

        PackInfo storage pack = packs[packId];

        requireItemsMintable(pack.itemIds, pack.itemAmounts, amount);

        uint256[] memory finalItemAmounts = new uint256[](
            pack.itemAmounts.length
        );

        for (uint256 i = 0; i < pack.itemIds.length; ++i) {
            ItemInfo storage item = items[pack.itemIds[i]];
            item.minted += pack.itemAmounts[i] * amount;
            finalItemAmounts[i] = pack.itemAmounts[i] * amount;
        }

        _mintBatch(msg.sender, pack.itemIds, finalItemAmounts, "");

        emit MintedPack(msg.sender, packId, amount);
    }

    /// @dev Mints a pack of items using ERC-20 tokens as payment.
    /// @param packId The ID of the pack to mint.
    /// @param amount The number of packs to mint.
    /// @param ERC20TokenId The ID of the ERC-20 token used for payment.
    /// @param value The value of the ERC-20 tokens sent for payment.
    function mintPackWithERC20(
        uint256 packId,
        uint256 amount,
        uint256 ERC20TokenId,
        uint256 value
    ) external nonReentrant {
        require(
            !pausedMint &&
                !packs[packId].paused &&
                !ERC20Tokens[ERC20TokenId].paused,
            "minting or paying is paused"
        );
        require(packs[packId].itemIds.length > 0, "pack doesn't exist");
        require(amount > 0, "amount must be at least 1");
        require(
            value >= getPacksTokenPrice(packId, amount, ERC20TokenId),
            "sent value is not enough"
        );
        require(msg.sender != address(0), "sender can't be null address");

        PackInfo storage pack = packs[packId];
        ERC20TokenInfo storage erc20Token = ERC20Tokens[ERC20TokenId];

        requireItemsMintable(pack.itemIds, pack.itemAmounts, amount);

        IERC20 tokenContract = erc20Token.tokenContract;
        tokenContract.transferFrom(msg.sender, address(this), value);

        uint256[] memory finalItemAmounts = new uint256[](
            pack.itemAmounts.length
        );

        for (uint256 i = 0; i < pack.itemIds.length; ++i) {
            ItemInfo storage item = items[pack.itemIds[i]];
            item.minted += pack.itemAmounts[i] * amount;
            finalItemAmounts[i] = pack.itemAmounts[i] * amount;
        }

        _mintBatch(msg.sender, pack.itemIds, finalItemAmounts, "");

        emit MintedPack(msg.sender, packId, amount);
    }

    /// @dev Performs a transmutation of items.
    /// The function transmutes the specified amounts of the item with the given ID into new items in the designated slots.
    /// After performing the transmutation, the function updates the transmuteFeeSum and emits a Transmuted event.
    /// @param id The ID of the item to transmute.
    /// @param amounts An array containing the amounts of items to transmute.
    /// @param slots An array containing the slots where the transmuted items will be placed.
    function mayneTransmute(
        uint256 id,
        uint256[] memory amounts,
        uint256[] memory slots
    ) external payable nonReentrant {
        require(pausedMayneTransmute == false, "mayne transmute paused");
        require(id <= itemIds, "item doesn't exist");
        require(amounts.length == slots.length, "arrays length mismatch");
        require(msg.sender != address(0), "sender can't be null address");
        require(msg.value >= transmuteFee, "sent value not enough");

        uint256 totalFee = transmuteFee;
        for (uint256 i = 0; i < amounts.length; ++i) {
            require(amounts[i] > 0, "amount can't be zero");
            require(
                items[id].minted + amounts[i] <= items[id].totalSupply,
                "amount exceeds total supply"
            );
        }

        transmuteFeeSum += totalFee;

        emit Transmuted(msg.sender, id, amounts, slots);
    }

    /// @dev Performs a batch transmutation of items.
    /// The function transmutes the specified amounts of items with the given IDs into new items in the designated slots.
    /// The transmutation process may involve additional checks or operations specific to each iteration.
    /// After performing the transmutation, the function updates the transmuteFeeSum and emits a TransmutedBatch event.
    /// @param ids An array containing the IDs of the items to transmute.
    /// @param amounts An array containing the amounts of items to transmute.
    /// @param slots An array containing the slots where the transmuted items will be placed.
    function mayneTransmuteBatch(
        uint256[] memory ids,
        uint256[] memory amounts,
        uint256[] memory slots
    ) external payable nonReentrant {
        require(pausedMayneTransmute == false, "mayne transmute paused");
        require(
            ids.length == amounts.length && ids.length == slots.length,
            "arrays length mismatch"
        );
        require(msg.sender != address(0), "sender can't be null address");

        uint256 totalFee = transmuteFeeBatch;
        require(msg.value >= totalFee, "sent value not enough");

        for (uint256 i = 0; i < ids.length; ++i) {
            require(
                ids[i] <= itemIds,
                "ids contains an item that doesn't exist"
            );
            require(amounts[i] > 0, "amount can't be zero");
            require(
                items[ids[i]].minted + amounts[i] <= items[ids[i]].totalSupply,
                "amount exceeds the total supply"
            );
        }

        transmuteFeeSum += totalFee;

        emit TransmutedBatch(msg.sender, ids, amounts, slots);
    }

    /// @dev Burns a specified amount of an item from the sender's account.
    /// The function burns the specified amount of the item with the given ID from the sender's account.
    /// The isTransmuting and isBridging flags indicate the purpose of the burn operation.
    /// After burning the item, the function emits a Burnt event.
    /// @param id The ID of the item to burn.
    /// @param amount The amount of the item to burn.
    /// @param isVirtualizing A flag indicating whether the burn is for virtualizing.
    /// @param isBridging A flag indicating whether the burn is for bridging.
    function burn(
        uint256 id,
        uint256 amount,
        bool isVirtualizing,
        bool isBridging
    ) external nonReentrant {
        require(pausedBurn == false, "burning paused");
        require(id <= itemIds, "item doesn't exist");
        require(
            balanceOf(msg.sender, id) >= amount,
            "not enough items to burn"
        );
        require(amount > 0, "amount can't be zero");

        _burn(msg.sender, id, amount);
        items[id].minted -= amount;

        emit Burnt(msg.sender, id, amount, isVirtualizing, isBridging);
    }

    /// @dev Burns a batch of items from the sender's account.
    /// The function burns the specified amounts of items with the given IDs from the sender's account.
    /// The isTransmuting and isBridging flags indicate the purpose of the burn operation.
    /// After burning the items, the function emits a BurntBatch event.
    /// @param ids An array containing the IDs of the items to burn.
    /// @param amounts An array containing the amounts of items to burn.
    /// @param isVirtualizing A flag indicating whether the burn is for virtualizing.
    /// @param isBridging A flag indicating whether the burn is for bridging.
    function burnBatch(
        uint256[] memory ids,
        uint256[] memory amounts,
        bool isVirtualizing,
        bool isBridging
    ) external nonReentrant {
        require(pausedBurn == false, "burning paused");
        require(
            ids.length <= itemIds + 1,
            "ids contain an item that doesn't exist"
        );
        require(
            ids.length == amounts.length,
            "ids and amounts must have the same length"
        );

        for (uint256 i = 0; i < amounts.length; ++i) {
            uint256 itemId = ids[i];
            uint256 amount = amounts[i];

            require(amount > 0, "amount can't be zero");
            require(
                balanceOf(msg.sender, itemId) >= amount,
                "account doesn't have enough items to burn"
            );

            items[itemId].minted -= amount;
        }

        _burnBatch(msg.sender, ids, amounts);

        emit BurntBatch(msg.sender, ids, amounts, isVirtualizing, isBridging);
    }

    ///-------------------------------------------------------------------------
    /// ADMIN FUNCTIONS ////////////////////////////////////////////////////////
    ///-------------------------------------------------------------------------

    /// @dev Function to add an address to the minter role.
    function addMinter(address minterAddress) external onlyOwner {
        minters[minterAddress] = true;
    }

    /// @dev Function to remove an address from the minter role.
    function removeMinter(address minterAddress) external onlyOwner {
        minters[minterAddress] = false;
    }

    /// @dev Adds new items to the contract.
    /// Each item is defined by its total supply and price in USD.
    /// The function adds the new items to the contract by assigning them unique IDs.
    /// The minted amount for each item is initialized to 0, and the paused flag is set to false.
    /// @param totalSupplies An array containing the total supplies of the new items.
    /// @param priceUsds An array containing the prices of the new items in USD.
    function addItems(
        uint256[] memory totalSupplies,
        uint256[] memory priceUsds,
        bool[] memory paused
    ) external onlyOwner {
        require(
            totalSupplies.length > 0 &&
                totalSupplies.length == priceUsds.length &&
                totalSupplies.length == paused.length,
            "invalid input arrays"
        );

        uint256 firstId = itemIds + 1;
        for (uint256 i = 0; i < totalSupplies.length; ++i) {
            uint256 itemId = firstId + i;
            itemIds++;
            ItemInfo storage item = items[itemId];
            item.minted = 0;
            item.totalSupply = totalSupplies[i];
            item.priceUsd = priceUsds[i];
            item.paused = paused[i];
        }
    }

    /// @dev Updates item information.
    /// @param ids The IDs of the items.
    /// @param totalSupplies The total supplies of the items.
    /// @param priceUsds The USD prices of the items in Wei.
    /// @param paused The pause status of the items.
    function updateItems(
        uint256[] memory ids,
        uint256[] memory totalSupplies,
        uint256[] memory priceUsds,
        bool[] memory paused
    ) external onlyOwner {
        require(
            ids.length > 0 &&
                ids.length == totalSupplies.length &&
                ids.length == priceUsds.length &&
                ids.length == paused.length,
            "invalid input arrays"
        );

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 itemId = ids[i];
            ItemInfo storage item = items[itemId];
            item.totalSupply = totalSupplies[i];
            item.priceUsd = priceUsds[i];
            item.paused = paused[i];
        }
    }

    /// @dev Mints a specified amount of an item and assigns it to a specified player.
    /// The item to be minted is specified by its ID.
    /// The player address indicates the recipient of the minted item.
    /// The function mints the specified amount of the item, assigns it to the player,
    /// and updates the minted amount of the item.
    /// @param id The ID of the item to be minted.
    /// @param amount The amount of the item to be minted.
    /// @param player The address to which the minted item will be assigned.
    /// @param isTransmuting A boolean indicating whether the minting is part of a transmutation process.
    function mintWithRole(
        uint256 id,
        uint256 amount,
        address player,
        bool isTransmuting
    ) external onlyWithRole {
        require(id <= itemIds, "item doesn't exist");
        require(amount > 0, "amount can't be zero");

        ItemInfo storage item = items[id];
        require(
            item.minted + amount <= item.totalSupply,
            "amount exceeds total supply"
        );

        require(player != address(0), "player can't be null address");

        _mint(player, id, amount, "");
        item.minted += amount;

        emit Minted(player, id, amount, isTransmuting);
    }

    /// @dev Mints a batch of items and assigns them to a specified player.
    /// The items to be minted are specified by their IDs and corresponding amounts.
    /// The player address indicates the recipient of the minted items.
    /// The function mints the specified amounts of items, assigns them to the player,
    /// and updates the minted amounts of the items.
    /// @param ids The IDs of the items to be minted.
    /// @param amounts The corresponding amounts of the items to be minted.
    /// @param player The address to which the minted items will be assigned.
    /// @param isTransmuting A boolean indicating whether the minting is part of a transmutation process.
    function mintBatchWithRole(
        uint256[] memory ids,
        uint256[] memory amounts,
        address player,
        bool isTransmuting
    ) external onlyWithRole {
        require(
            ids.length == amounts.length,
            "ids and amounts must have the same length"
        );

        for (uint256 i = 0; i < ids.length; ++i) {
            require(
                ids[i] <= itemIds,
                "ids contain an item that doesn't exist"
            );

            ItemInfo storage item = items[ids[i]];
            require(amounts[i] > 0, "amount can't be zero");
            require(
                item.minted + amounts[i] <= item.totalSupply,
                "amount exceeds the total supply"
            );

            item.minted += amounts[i];
        }

        require(player != address(0), "player can't be null address");

        _mintBatch(player, ids, amounts, "");

        emit MintedBatch(player, ids, amounts, isTransmuting);
    }

    /// @dev Withdraws the contract's native currency balance to designated addresses.
    /// The designated addresses are as follows:
    /// - Founder 1: 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3
    /// - Founder 2: 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d
    /// - Dev: 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D
    /// The function transfers the appropriate amounts of native currency to the designated addresses.
    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "balance can't be zero");

        uint256 founderAmount = contractBalance.mul(4).div(10);
        uint256 devAmount = contractBalance.mul(2).div(10);

        address[] memory founders = new address[](2);
        founders[0] = 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3;
        founders[1] = 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d;
        address dev = 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D;

        for (uint256 i = 0; i < founders.length; ++i) {
            require(
                payable(founders[i]).send(founderAmount),
                "transfer to founder failed"
            );
        }

        require(payable(dev).send(devAmount), "transfer to dev failed");

        transmuteFeeSum = 0;
    }

    /// @dev Withdraws ERC-20 token balances of token types specified in `tokenIds` from this contract's balance
    /// to designated addresses.
    /// The designated addresses are hardcoded as follows:
    /// - founder1: 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3
    /// - founder2: 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d
    /// - dev: 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D
    /// The function transfers the appropriate amounts of tokens to the designated addresses.
    /// @param tokenIds An array of token IDs representing the token types to withdraw.
    function withdrawERC20(uint256[] memory tokenIds) external onlyOwner {
        require(
            tokenIds.length <= _ERC20WithdrawalLimit,
            "you can't withdraw more than five token types"
        );
        require(tokenIds.length > 0, "tokenIds cannot be empty");

        address founder1 = 0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3;
        address founder2 = 0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d;
        address dev = 0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D;

        for (uint256 i = 0; i < tokenIds.length; ++i) {
            IERC20 tokenContract = ERC20Tokens[tokenIds[i]].tokenContract;
            require(address(tokenContract) != address(0), "token not set");

            uint256 balance = tokenContract.balanceOf(address(this));
            require(balance > 0, "balance can't be zero");

            uint256 founderAmount = balance.mul(4).div(10);
            uint256 devAmount = balance.mul(2).div(10);

            tokenContract.transfer(founder1, founderAmount);
            tokenContract.transfer(founder2, founderAmount);
            tokenContract.transfer(dev, devAmount);
        }
    }
}
