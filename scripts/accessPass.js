require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const AccessPass = await hre.ethers.getContractFactory("AccessPass");
  const accessPass = await AccessPass.deploy();
  await accessPass.deployTransaction.wait();
  console.log("accessPass deployed to:", accessPass.address);

  //console.log("yarn hardhat verify --network rinkeby", accessPass.address);
  //console.log("yarn hardhat verify --network bsc_test", accessPass.address);
  //console.log("yarn hardhat verify --network fuji", accessPass.address);
  //console.log("yarn hardhat verify --network mumbai", accessPass.addresss);

  console.log("yarn hardhat verify --network eth", accessPass.address);
  //console.log("yarn hardhat verify --network bsc", accessPass.address);
  //console.log("yarn hardhat verify --network avax", accessPass.address);
  //console.log("yarn hardhat verify --network poly", accessPass.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
