require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const Item = await hre.ethers.getContractFactory("Item");
  const item = await Item.deploy();
  await item.deployTransaction.wait();
  console.log("item deployed to:", item.address);
  //console.log("yarn hardhat verify --network goerli", item.address);
  //console.log("yarn hardhat verify --network bsc_test", item.address);
  //console.log("yarn hardhat verify --network fuji", item.address);
  console.log("yarn hardhat verify --network mumbai", item.address);

  //console.log("yarn hardhat verify --network eth", item.address);
  //console.log("yarn hardhat verify --network bsc", item.address);
  //console.log("yarn hardhat verify --network avax", item.address);
  //console.log("yarn hardhat verify --network poly", item.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
