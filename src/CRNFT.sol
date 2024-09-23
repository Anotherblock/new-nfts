pragma solidity ^0.8.19;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CRNFT is ERC721A, Ownable {
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

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
    }
}
