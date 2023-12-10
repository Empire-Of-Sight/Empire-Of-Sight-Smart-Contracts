// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract AccessPass is ERC1155, Ownable {
    using SafeMath for uint256;

    // Access Pass types
    uint256 public constant PROTOTYPE = 0;
    uint256 public constant MONTH = 1;
    uint256 public constant TWO_MONTHS = 2;
    uint256 public constant THREE_MONTHS = 3;
    uint256 public constant HALF_YEAR = 4;
    uint256 public constant YEAR = 5;
    uint256 public constant UNLIMITED = 6;

    // Access Passes can be paused together except the PROTOTYPE
    bool public paused = true;

    // amount of Access Passes minted by their IDs
    uint256[] public minted = [0, 0, 0, 0, 0, 0, 0];

    // Access Passes prices in USD (wei)
    mapping(uint256 => uint256) public pricesUSD;

    // Access Passes expiry date based off the player (format: expiryDate[playerAddr][ID][serialNum] = expiry date timestamp)
    mapping(address => mapping(uint256 => mapping(uint256 => uint256)))
        public expiryDate;

    // amount of Access Passes minted individually
    mapping(address => mapping(uint256 => uint256)) public mintedByPlayer;

    // Chainlink Data Feeds
    AggregatorV3Interface internal priceFeed;

    //-------------------------------------------------------------------------
    // CONSTRUCTOR
    //-------------------------------------------------------------------------

    constructor()
        ERC1155("https://www.empireofsight.com/metadata/accesspass/{id}.json")
    {
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        pricesUSD[0] = 499 * 10**16;
        pricesUSD[1] = 999 * 10**16;
        pricesUSD[2] = 1999 * 10**16;
        pricesUSD[3] = 2999 * 10**16;
        pricesUSD[4] = 3999 * 10**16;
        pricesUSD[5] = 4999 * 10**16;
        pricesUSD[6] = 9999 * 10**16;
    }

    //-------------------------------------------------------------------------
    // VIEW FUNCTIONS
    //------------------------------------------------------------------------

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    // converts the USD value into the blockchain's native currency
    function getAccessPassNativePrice(uint256 id)
        public
        view
        returns (uint256)
    {
        require(id <= 6, "this type of access pass doesn't exist");

        return pricesUSD[id].div(uint256(getLatestPrice())).mul(10**8);
    }

    // checks if the access pass hasn't been expired yet
    function isValid(
        address player,
        uint256 id,
        uint256 serialNum
    ) public view returns (bool) {
        require(id <= 6, "this type of access pass doesn't exist");
        require(msg.sender != address(0), "sender can't be null address");
        require(
            serialNum <= mintedByPlayer[player][id],
            "the player hasn't minted this access pass yet, serialNum is out of range"
        );

        if (expiryDate[player][id][serialNum] > block.timestamp) return true;
        else if (id == 6) return true;
        else return false;
    }

    // shows how much time left till the access pass get expired
    function timeLeft(
        address player,
        uint256 id,
        uint256 serialNum
    ) public view returns (uint256) {
        require(id <= 6, "this type of access pass doesn't exist");
        require(msg.sender != address(0), "sender can't be null address");
        require(
            serialNum <= mintedByPlayer[player][id],
            "the player hasn't minted this access pass yet, serialNum is out of range"
        );

        return (expiryDate[player][id][serialNum] - block.timestamp);
    }

    //-------------------------------------------------------------------------
    // SET FUNCTIONS
    //-------------------------------------------------------------------------

    // sets the URI of the smart contract
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    // pauses the access pass minting
    function setPause() public onlyOwner {
        paused = !paused;
    }

    // sets the access pass USD price, price input must be in wei
    function setPriceUSD(uint256 id, uint256 price) public onlyOwner {
        require(id <= 6, "this type of item doesn't exist");

        pricesUSD[id] = price;
    }

    //-------------------------------------------------------------------------
    // EXTERNAL FUNCTIONS
    //-------------------------------------------------------------------------

    // mints the access pass
    function mint(uint256 id) public payable {
        require(id <= 6, "this type of access pass doesn't exist");
        require(
            msg.value >= getAccessPassNativePrice(id),
            "the sent value is not enough"
        );
        require(msg.sender != address(0), "sender can't be null address");

        if (id > 0) {
            require(
                paused == false,
                "the main game Access Pass minting hasn't been started yet"
            );
            if (id == 1) {
                uint256 serialNum = mintedByPlayer[msg.sender][id];
                expiryDate[msg.sender][id][serialNum] =
                    block.timestamp +
                    30 days;
            } else if (id == 2) {
                uint256 serialNum = mintedByPlayer[msg.sender][id];
                expiryDate[msg.sender][id][serialNum] =
                    block.timestamp +
                    60 days;
            } else if (id == 3) {
                uint256 serialNum = mintedByPlayer[msg.sender][id];
                expiryDate[msg.sender][id][serialNum] =
                    block.timestamp +
                    90 days;
            } else if (id == 4) {
                uint256 serialNum = mintedByPlayer[msg.sender][id];
                expiryDate[msg.sender][id][serialNum] =
                    block.timestamp +
                    180 days;
            } else if (id == 5) {
                uint256 serialNum = mintedByPlayer[msg.sender][id];
                expiryDate[msg.sender][id][serialNum] =
                    block.timestamp +
                    365 days;
            }
        }

        _mint(msg.sender, id, 1, "");
        minted[id]++;
        mintedByPlayer[msg.sender][id]++;
    }

    // mints items by IDs for specific players
    function mintAdmin(
        uint256 id,
        uint256 amount,
        address player
    ) public onlyOwner {
        require(id <= 6, "this type of item doesn't exist");
        require(amount > 0, "amount must be at least 1");
        require(player != address(0), "player can't be null address");

        if (id > 0) {
            if (id == 1) {
                uint256 serialNum = mintedByPlayer[player][id];
                expiryDate[player][id][serialNum] = block.timestamp + 30 days;
            } else if (id == 2) {
                uint256 serialNum = mintedByPlayer[player][id];
                expiryDate[player][id][serialNum] = block.timestamp + 60 days;
            } else if (id == 3) {
                uint256 serialNum = mintedByPlayer[player][id];
                expiryDate[player][id][serialNum] = block.timestamp + 90 days;
            } else if (id == 4) {
                uint256 serialNum = mintedByPlayer[player][id];
                expiryDate[player][id][serialNum] = block.timestamp + 180 days;
            } else if (id == 5) {
                uint256 serialNum = mintedByPlayer[player][id];
                expiryDate[player][id][serialNum] = block.timestamp + 365 days;
            }
        }

        _mint(player, id, amount, "");
        minted[id] += amount;
        mintedByPlayer[player][id] += amount;
    }

    // withdraws all the balance of the contract to the dev & founder addresses
    function withdraw() external {
        require(address(this).balance > 0, "balance can't be zero");

        address founderOne = payable(
            0xfE38200d6206fcf177c8C2A25300FeeC3E3803F3
        );
        address founderTwo = payable(
            0x4ee757CfEBA27580BA587f8AE81f5BA63Bdd021d
        );
        address dev = payable(0x72a2547dcd6D114bA605Ad5C18756FD7aEAc467D);

        uint256 balanceOne = address(this).balance.mul(4).div(10);
        uint256 balanceTwo = address(this).balance.mul(4).div(10);
        uint256 balanceDev = address(this).balance.mul(2).div(10);

        payable(founderOne).transfer(balanceOne);
        payable(founderTwo).transfer(balanceTwo);
        payable(dev).transfer(balanceDev);
    }
}
