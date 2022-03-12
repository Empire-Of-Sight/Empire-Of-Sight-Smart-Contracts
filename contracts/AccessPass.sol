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

    // Access Passes can be paused together except the PROTOTYPE
    bool public paused = true;

    // amount of Access Passes minted by their IDs
    uint256[] public minted = [0, 0, 0, 0, 0, 0];

    // Access Passes prices in USD (format: $4.99 = 499 * 10^16)
    mapping(uint256 => uint256) public pricesUSD;

    // Access Passes expiry date based on the player (format: expiryDate[playerAddr][ID][serialNum] = expiry date timestamp)
    mapping(address => mapping(uint256 => mapping(uint256 => uint256)))
        public expiryDate;

    // amount of Access Passes minted individually
    mapping(address => mapping(uint256 => uint256)) public mintedByPlayer;

    // Chainlink Data Feeds
    AggregatorV3Interface internal priceFeed;

    //-------------------------------------------------------------------------
    // CONSTRUCTOR
    //-------------------------------------------------------------------------

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        priceFeed = AggregatorV3Interface(
            0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
        );
        pricesUSD[0] = 499 * 10**14; // it should be 16!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        pricesUSD[1] = 999 * 10**14;
        pricesUSD[2] = 1999 * 10**14;
        pricesUSD[3] = 2999 * 10**14;
        pricesUSD[4] = 3999 * 10**14;
        pricesUSD[5] = 4999 * 10**14;
    }

    //-------------------------------------------------------------------------
    // VIEW FUNCTIONS
    //-------------------------------------------------------------------------

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function getAccessPassNativePrice(uint256 id)
        public
        view
        returns (uint256)
    {
        require(id <= 5, "This type of Access Pass doesn't exist.");
        return pricesUSD[id].div(uint256(getLatestPrice())).mul(10**8);
    }

    function isValid(
        address player,
        uint256 id,
        uint256 serialNum
    ) public view returns (bool) {
        if (expiryDate[player][id][serialNum] > block.timestamp) return true;
        else return false;
    }

    function timeLeft(
        address player,
        uint256 id,
        uint256 serialNum
    ) public view returns (uint256) {
        return (expiryDate[player][id][serialNum] - block.timestamp);
    }

    //-------------------------------------------------------------------------
    // SET FUNCTIONS
    //-------------------------------------------------------------------------

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setPause() public onlyOwner {
        paused = !paused;
    }

    function setPriceUSD(uint256 id, uint256 price) public onlyOwner {
        pricesUSD[id] = price * 10**16;
    }

    //-------------------------------------------------------------------------
    // EXTERNAL FUNCTIONS
    //-------------------------------------------------------------------------

    function mint(uint256 id) public payable {
        require(id <= 5, "This type of Access Pass doesn't exist.");
        require(
            msg.value >= getAccessPassNativePrice(id),
            "The sent value is not enough."
        );

        if (id > 0) {
            require(
                paused == false,
                "The main game Access Pass minting hasn't been started yet."
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

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Balance is 0.");

        address founderOne = payable(
            0xfA387DD47044EbAdF3c05d07557D15c08D1b6Df7
        );
        address founderTwo = payable(
            0x85390F0A34636aE689Cd545665C4136404dfa696
        );
        address dev = payable(0xeAa43C424a0F9B1c52837046171Cb960D6A93023);

        uint256 balanceOne = address(this).balance.mul(4).div(10);
        uint256 balanceTwo = address(this).balance.mul(4).div(10);
        uint256 balanceDev = address(this).balance.mul(2).div(10);

        payable(founderOne).transfer(balanceOne);
        payable(founderTwo).transfer(balanceTwo);
        payable(dev).transfer(balanceDev);
    }
}
