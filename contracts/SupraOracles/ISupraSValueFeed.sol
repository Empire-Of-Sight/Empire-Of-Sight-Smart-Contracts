pragma solidity 0.8.19;

// depending on the requirement, you may build one or more
// data structures given below.

interface ISupraSValueFeed {
    // Data structure to hold the pair data
    struct dataWithoutHcc {
        uint256 round;
        uint256 decimals;
        uint256 time;
        uint256 price;
    }

    // Data Structure To Hold The Derived Pair Data
    struct derivedData {
        int256 roundDifference;
        uint256 derivedPrice;
        uint256 decimals;
    }

    // Below functions enable you to retrieve different flavours of S-Value
    // Term "pair ID" and "Pair index" both refer to the same, pair index mentiond in our data pairs list

    // Function to retrieve the data for a single data pair
    function getSvalue(
        uint256 _pairIndex
    ) external view returns (dataWithoutHcc memory);

    //Function to fetch the data for a multiple data pairs
    function getSvalues(
        uint256[] memory _pairIndexes
    ) external view returns (dataWithoutHcc[] memory);

    // Function to convert and derive new data pairs using two pair IDs and a mathematical operator multiplication(*) or division(/).
    function getDerivedSvalue(
        uint256 pair_id_1,
        uint256 pair_id_2,
        uint256 operation
    ) external view returns (derivedData memory);

    // Function to check  the latest Timestamp on which a data pair is updated. This will help you check the staleness of a data pair before performing an action.
    function getTimestamp(uint256 _tradingPair) external view returns (uint256);
}
