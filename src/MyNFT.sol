pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721A, Ownable {
    string private _baseTokenURI;

    constructor(
        string memory name,
        string memory symbol,
        uint256 supply,
        string memory baseURI
    ) ERC721A(name, symbol) Ownable(msg.sender) {
        _baseTokenURI = baseURI;
        _mint(msg.sender, supply);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
