require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const Token = await hre.ethers.getContractFactory("Token");
  const token = await Token.deploy();
  await token.deployTransaction.wait();
  console.log("item deployed to:", token.address);
  //console.log("yarn hardhat verify --network goerli", item.address);
  //console.log("yarn hardhat verify --network bsc_test", item.address);
  //console.log("yarn hardhat verify --network fuji", item.address);
  console.log("yarn hardhat verify --network mumbai", token.address);

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
