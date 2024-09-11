// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyNFT nft = new MyNFT(
            "MyNFT",
            "MNFT",
            10000,
            "https://api.mynft.com/tokens/"
        );

        vm.stopBroadcast();
    }
}
