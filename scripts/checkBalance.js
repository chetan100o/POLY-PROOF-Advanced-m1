const { ethers } = require("hardhat");

async function checkBalance() {
  const nftAddress = "0x1dc655Aa5619020425fADE76aB14b28BC445d27e";
  
  // Step 1: Get the contract instance for the AbstractArt NFT
  const nftCollection = await ethers.getContractAt("AbstractArt", nftAddress);

  // Replace this address with the address you want to check the balance for
  const walletAddress = "0xD568E4D22e269f1E6594E7805dddBb2Cc8274dB7";

  // Step 2: Get the balance of the wallet for AbstractArt NFTs
  const balance = await nftCollection.balanceOf(walletAddress);
  console.log(`🎉 AbstractArt Wallet Balance: ${balance.toString()} NFT(s) 🎉`);
}

checkBalance().catch((error) => {
  console.error("Error checking AbstractArt wallet balance:", error);
  process.exitCode = 1;
});
