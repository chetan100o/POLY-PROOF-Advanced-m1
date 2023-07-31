// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AbstractArt is ERC721Enumerable, Ownable {
    // Maximum capacity of tokens that can be minted
    uint256 public constant maxQuantity = 5;
    
    uint256 private totalMinted;
   
     // Base url for the nfts
    string private baseUrl = "https://gateway.pinata.cloud/ipfs/QmYhSfQPTu2fFwkrV3DNHpb74QF9AQ135QCmtCrXC3ChTQ/";

     // URL for the prompt description
    string public promptDescription = "Create a visually COOL NFT artwork that has onepiece refrence.";

    mapping(address => uint256) private tokensMinted;
    mapping(uint256 => string) private tokenAttributes;
    mapping(uint256 => string) private tokenUrls;

    event NFTMinted(address indexed minter, uint256 tokenId);

    constructor() ERC721("AbstractArt", "EMB") {
         owner = msg.sender;
    }

    // Modifier that only allows the owner to execute a function
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action!");
        _;
    }


    function mint(address to, string calldata nftUrl) external payable {
        require(totalMinted < maxQuantity, "Exceeds maximum minting quantity");

        totalMinted++;
        uint256 tokenId = totalMinted;
        tokensMinted[to]++;
        _mint(to, tokenId);
        tokenAttributes[tokenId] = ""; // Set empty attributes for now
        tokenUrls[tokenId] = nftUrl;   // Set the URL for the NFT
        emit NFTMinted(to, tokenId);
    }

    function setBaseURI(string memory newBaseUrl) external onlyOwner {
        baseUrl = newBaseUrl;
    }

    function updatePromptDescription(string memory newDescription) external onlyOwner {
        promptDescription = newDescription;
    }

    function setTokenAttributes(uint256 tokenId, string memory attributes) external onlyOwner {
        require(_exists(tokenId), "Invalid tokenId");
        tokenAttributes[tokenId] = attributes;
    }

    function getTokenAttributes(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Invalid tokenId");
        return tokenAttributes[tokenId];
    }

    function getTokenUrl(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Invalid tokenId");
        return tokenUrls[tokenId];
    }

    function totalSupply() public view override returns (uint256) {
        return totalMinted;
    }

    function tokensMintedByAddress(address account) external view returns (uint256) {
        return tokensMinted[account];
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUrl;
    }
}
