const hardhat = require("hardhat");
const { FXRootContractAbi } = require("../abis");

async function main() {
  // Replace with the contract address of your AbstractArt NFT
  const nftAddress = "0x6711bdd7C0788ef3A4fa44A77086B55C268E79e3";
  
  // Replace with the address where you want to deposit the NFTs
  const accountAddress = "0xD568E4D22e269f1E6594E7805dddBb2Cc8274dB7";

  // Replace with the token IDs you want to deposit
  const tokenIds = [1, 2, 3, 4, 5];

  // Step 1: Get the contract instances
  const nftCollection = await hardhat.ethers.getContractAt("AnimePiece", nftAddress);
  const fxRoot = await hardhat.ethers.getContractAt(
    FXRootContractAbi,
    "0xF9bc4a80464E48369303196645e876c8C7D972de"
  );

  for (let i = 0; i < tokenIds.length; i++) {
    const tokenId = tokenIds[i];

    // Step 2: Approve the transfer of the token to fxRoot contract
    const approveTxn = await nftCollection.approve(fxRoot.address, tokenId, { gasLimit: 300000 });
    await approveTxn.wait();
    console.log(`👍 NFT ${tokenId} approved`);

    // Step 3: Deposit the token into fxRoot contract
    const depositTxn = await fxRoot.deposit(
      nftAddress,
      accountAddress,
      tokenId,
      "0x6566",
      { gasLimit: 300000 }
    );
    await depositTxn.wait();
    console.log(`✅ NFT ${tokenId} deposited`);
  }
}

main().catch((error) => {
  console.error(`❌ Error: ${error}`);
  process.exitCode = 1;
});
