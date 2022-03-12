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
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 9999,
      },
    },
  },
  networks: {
    mainnet: {
      url: process.env.MAINNET_RPC || "https://main-light.eth.linkpool.io",
      accounts,
    },
    goerli: {
      url: process.env.GOERLI_RPC || "",
      accounts,
    },
    polygon: {
      url: process.env.POLYGON_RPC || "",
      accounts,
    },
    mumbai: {
      url: process.env.MUMBAI_RPC || "",
      accounts,
    },
    bsc_test: {
      url: process.env.BSC_TESTNET_RPC || "",
      accounts,
    },
  },
  etherscan: {
    apiKey: process.env.POLYGON_API_KEY,
  },
};
