// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/CRNFT.sol";

contract DeployCRNFT is Script {
    function run() external {
        // Read deployment parameters from environment variables
        string memory name = vm.envString("NFT_NAME");
        string memory symbol = "CRNFT";
        uint256 supply = vm.envUint("NFT_SUPPLY");
        string memory baseURI = vm.envString("NFT_BASE_URI");
        string memory dropId = vm.envString("DROP_ID");

        // Deploy the contract
        vm.startBroadcast();
        CRNFT nft = new CRNFT(name, symbol, supply, baseURI);
        vm.stopBroadcast();

        // Prepare deployment info
        string memory deploymentInfo = string(
            abi.encodePacked(
                "Contract Name: ",
                name,
                "\n",
                "Symbol: ",
                symbol,
                "\n",
                "Supply: ",
                vm.toString(supply),
                "\n",
                "Base URI: ",
                baseURI,
                "\n",
                "Deployed Address: ",
                vm.toString(address(nft))
            )
        );

        string memory filename = string(
            abi.encodePacked("output/", dropId, "_deployment")
        );
        vm.writeFile(filename, deploymentInfo);
    }
}
