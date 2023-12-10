require("dotenv").config();
const hre = require("hardhat");

async function main() {
  // Hardhat setup and network connection
  const [deployer] = await hre.ethers.getSigners();
  const Item = await hre.ethers.getContractFactory("Item");
  const item = await Item.attach("0x563fA566e67E5E396857520b11d67B02be937a5B");

  //await item.setPack(5, 1, [1, 2, 3], [100, 100, 100]);

  const packId = 5; // The key of the mapping you want to access

  const packInfo = await item.packs(packId);
  console.log("Pack Info:", packInfo);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
