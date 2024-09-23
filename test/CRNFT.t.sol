pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/CRNFT.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CRNFTTest is Test {
    CRNFT public nft;
    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    function setUp() public {
        vm.prank(owner);
        nft = new CRNFT(
            "TestNFT",
            "TNFT",
            1000,
            "https://api.testnft.com/tokens/"
        );
    }

    function testInitialMint() public view {
        assertEq(nft.balanceOf(owner), 1000);
        assertEq(nft.totalSupply(), 1000);
    }

    function testOwnership() public view {
        assertEq(nft.owner(), owner);
    }

    function testBaseURI() public view {
        assertEq(nft.tokenURI(1), "https://api.testnft.com/tokens/1");
    }

    function testSetBaseURI() public {
        vm.prank(owner);
        nft.setBaseURI("https://new.testnft.com/tokens/");
        assertEq(nft.tokenURI(1), "https://new.testnft.com/tokens/1");
    }

    function testFailSetBaseURINotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.setBaseURI("https://fake.testnft.com/tokens/");
    }

    function testTokenStartsAtOne() public {
        assertEq(nft.tokenURI(1), "https://api.testnft.com/tokens/1");

        vm.expectRevert(
            abi.encodeWithSignature("URIQueryForNonexistentToken()")
        );
        nft.tokenURI(0);
    }

    function testMaxSupply() public view {
        assertEq(nft.totalSupply(), 1000);
    }

    function testOwnerOfAllTokens() public view {
        for (uint256 i = 1; i <= 1000; i++) {
            assertEq(nft.ownerOf(i), owner);
        }
    }

    function testFailTokenIdOutOfRange() public view {
        nft.ownerOf(1001);
    }

    function testTransferFrom() public {
        vm.prank(owner);
        nft.transferFrom(owner, user1, 1);
        assertEq(nft.ownerOf(1), user1);
        assertEq(nft.balanceOf(owner), 999);
        assertEq(nft.balanceOf(user1), 1);
    }

    function testSafeTransferFrom() public {
        vm.prank(owner);
        nft.safeTransferFrom(owner, user1, 2);
        assertEq(nft.ownerOf(2), user1);
        assertEq(nft.balanceOf(owner), 999);
        assertEq(nft.balanceOf(user1), 1);
    }

    function testFailTransferFromNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("ERC721A: transfer caller is not owner nor approved");
        nft.transferFrom(owner, user1, 3);
    }

    function testApprove() public {
        vm.prank(owner);
        nft.approve(user1, 4);
        assertEq(nft.getApproved(4), user1);
    }

    function testTransferFromApproved() public {
        vm.prank(owner);
        nft.approve(user1, 5);

        vm.prank(user1);
        nft.transferFrom(owner, user2, 5);
        assertEq(nft.ownerOf(5), user2);
    }

    function testSetApprovalForAll() public {
        vm.prank(owner);
        nft.setApprovalForAll(user1, true);
        assertTrue(nft.isApprovedForAll(owner, user1));
    }

    function testTransferFromApprovedForAll() public {
        vm.prank(owner);
        nft.setApprovalForAll(user1, true);

        vm.prank(user1);
        nft.transferFrom(owner, user2, 6);
        assertEq(nft.ownerOf(6), user2);
    }

    function testFailTransferToZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert("ERC721A: transfer to the zero address");
        nft.transferFrom(owner, address(0), 7);
    }

    function testBatchTransfer() public {
        vm.startPrank(owner);
        for (uint256 i = 1; i <= 10; i++) {
            nft.transferFrom(owner, user1, i);
        }
        vm.stopPrank();

        assertEq(nft.balanceOf(owner), 990);
        assertEq(nft.balanceOf(user1), 10);
    }

    function testTokenURIForAllTokens() public view {
        for (uint256 i = 1; i <= 1000; i++) {
            assertEq(
                nft.tokenURI(i),
                string(
                    abi.encodePacked(
                        "https://api.testnft.com/tokens/",
                        Strings.toString(i)
                    )
                )
            );
        }
    }

    function testFailSetBaseURIEmptyString() public {
        vm.prank(owner);
        vm.expectRevert("Base URI cannot be empty");
        nft.setBaseURI("");
    }

    function testTransferOwnership() public {
        vm.prank(owner);
        nft.transferOwnership(user1);
        assertEq(nft.owner(), user1);
    }

    function testFailTransferOwnershipNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.transferOwnership(user2);
    }

    function testRenounceOwnership() public {
        vm.prank(owner);
        nft.renounceOwnership();
        assertEq(nft.owner(), address(0));
    }

    function testFailRenounceOwnershipNotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.renounceOwnership();
    }
}
