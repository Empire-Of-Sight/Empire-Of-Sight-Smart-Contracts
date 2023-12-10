require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const ItemFuse = await hre.ethers.getContractFactory("ItemFuse");
  const itemFuse = await ItemFuse.deploy();
  await itemFuse.deployTransaction.wait();
  console.log("item deployed to:", itemFuse.address);
  //console.log("yarn hardhat verify --network goerli", item.address);
  //console.log("yarn hardhat verify --network bsc_test", item.address);
  //console.log("yarn hardhat verify --network fuji", item.address);
  //console.log("yarn hardhat verify --network mumbai", item.address);
  console.log("yarn hardhat verify --network fuse_test", itemFuse.address);

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
