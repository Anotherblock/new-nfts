pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT public nft;
    address public owner = address(1);
    address public user = address(2);

    function setUp() public {
        vm.prank(owner);
        nft = new MyNFT(
            "TestNFT",
            "TNFT",
            1000,
            "https://api.testnft.com/tokens/"
        );
    }

    function testInitialMint() public {
        assertEq(nft.balanceOf(owner), 1000);
        assertEq(nft.totalSupply(), 1000);
    }

    function testOwnership() public {
        assertEq(nft.owner(), owner);
    }

    function testBaseURI() public {
        vm.prank(owner);
        assertEq(nft.tokenURI(1), "https://api.testnft.com/tokens/1");
    }

    function testSetBaseURI() public {
        vm.prank(owner);
        nft.setBaseURI("https://new.testnft.com/tokens/");
        assertEq(nft.tokenURI(1), "https://new.testnft.com/tokens/1");
    }

    function testFailSetBaseURINotOwner() public {
        vm.prank(user);
        nft.setBaseURI("https://fake.testnft.com/tokens/");
    }
}
