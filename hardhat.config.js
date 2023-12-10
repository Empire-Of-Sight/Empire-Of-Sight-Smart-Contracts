require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

let accounts = [];

if (process.env.PRIVATE_KEY) {
  accounts = [`0x${process.env.PRIVATE_KEY}`, ...accounts];
}

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 50,
      },
    },
  },
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC || "",
      accounts,
    },
    bsc_test: {
      url: process.env.BSC_TESTNET_RPC || "",
      accounts,
    },
    fuji: {
      url: process.env.FUJI_RPC || "",
      accounts,
    },
    mumbai: {
      url: process.env.MUMBAI_RPC || "",
      accounts,
    },
    fuse_test: {
      url: process.env.FUSE_TEST_RPC || "",
      accounts,
    },
    fuse: {
      url: process.env.FUSE_RPC || "",
      accounts,
    },
    eth: {
      url: process.env.ETHEREUM_RPC || "",
      accounts,
    },
    bsc: {
      url: process.env.BSC_RPC || "",
      accounts,
    },
    avax: {
      url: process.env.AVAX_RPC || "",
      accounts,
    },
    poly: {
      url: process.env.POLYGON_RPC || "",
      accounts,
    },
  },

  etherscan: {
    //apiKey: process.env.ETHEREUM_API_KEY,
    //apiKey: process.env.BSC_API_KEY,
    //apiKey: process.env.AVALANCHE_API_KEY,
    apiKey: process.env.POLYGON_API_KEY,
    //apiKey: process.env.BLOCKSCOUT_API_KEY,
  },
};
