import { ethers } from "hardhat";

async function main() {
  const Ideally_Store = await ethers.getContractFactory("Ideally");
  const Store_Deploy = await Ideally_Store.deploy();
  await Store_Deploy.deployed();
  console.log(`Ideally deployed to ${Store_Deploy.address} `);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
