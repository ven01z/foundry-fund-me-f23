// Fund
// Withdraw

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentDeployed) public { 
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}(); 
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }


    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment( // This line calls the get_most_recent_deployment function from the DevOpsTools library to retrieve the address of the most recently deployed instance of the FundMe contract. The function takes two arguments: the name of the contract ("FundMe") and the current blockchain's chain ID (block.chainid). The returned address is then assigned to the mostRecentDeployed variable, which will be used in subsequent interactions with the FundMe contract.
            "FundMe", 
            block.chainid
        );

        fundFundMe(mostRecentDeployed); // This line calls the fundFundMe function defined earlier in the contract, passing the mostRecentDeployed address as an argument. This function will execute the funding process for the FundMe contract at the specified address, sending a predefined amount of Ether (SEND_VALUE) to it. The purpose of this call is to simulate a user funding the FundMe contract during testing or deployment.
    }
}

contract WithdrawFundMe is Script {
        function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw(); // You can also use cheaperWithdraw() instead of withdraw() if you want to test the cheaper version of the withdrawal function. This line calls the withdraw function of the FundMe contract at the specified address (mostRecentDeployed). The withdraw function is responsible for transferring the funds from the contract to the owner's address. By calling this function, you are simulating a withdrawal of funds from the FundMe contract during testing or deployment.
        vm.stopBroadcast();
    }


    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment( 
            "FundMe", 
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}