require("dotenv").config();
const hre = require("hardhat");

async function main() {
  const AccessPass = await hre.ethers.getContractFactory("AccessPass");
  const accessPass = await AccessPass.deploy();
  await accessPass.deployTransaction.wait();
  console.log("accessPass deployed to:", accessPass.address);
  console.log("npx hardhat verify --network mumbai", accessPass.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
