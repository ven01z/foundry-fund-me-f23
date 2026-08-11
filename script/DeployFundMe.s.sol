// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // run() is a special function in Foundry scripts that is executed when the script is run.
        // Before startBroadcast -> not a transaction, just a local call
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // After startBroadcast -> transaction, will be sent to the blockchain
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed); // Deploy the FundMe contract with the price feed address
        vm.stopBroadcast();
        return fundMe;
    }
}
