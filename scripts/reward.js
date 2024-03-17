require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const Reward = await hre.ethers.getContractFactory("Reward");
  const reward = await Reward.deploy();
  await reward.deployTransaction.wait();
  console.log("deployed to:", reward.address);
  //console.log("yarn hardhat verify --network goerli", item.address);
  //console.log("yarn hardhat verify --network bsc_test", item.address);
  //console.log("yarn hardhat verify --network fuji", item.address);
  //console.log("yarn hardhat verify --network mumbai", item.address);
  //console.log("yarn hardhat verify --network fuse_test", itemFuse.address);

  //console.log("yarn hardhat verify --network eth", item.address);
  //console.log("yarn hardhat verify --network bsc", item.address);
  //console.log("yarn hardhat verify --network avax", item.address);
  //console.log("yarn hardhat verify --network poly", item.address);
  //console.log("yarn hardhat verify --network fuse", item.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
