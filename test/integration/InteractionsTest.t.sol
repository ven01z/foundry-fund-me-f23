// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe; // state variable, accessible everywhere in this contract

    address USER = makeAddr("user"); // It takes a string as an argument, which is used to generate a unique address. In this case, the string "user" is passed to makeAddr, and the resulting address is assigned to the USER variable. This allows you to simulate interactions with the FundMe contract from the perspective of a specific user during testing.
    uint256 constant SEND_VALUE = 10e18; // 10 ETH // 10e18 // This constant is used to represent the amount of ether that will be sent in the test cases when interacting with the FundMe contract. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.
    uint256 constant STARTING_BALANCE = 10 ether; // 10 ETH // This constant is used to represent the starting balance of the USER address during testing. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.
    uint256 constant GAS_PRICE = 1; // 1 wei // This constant is used to represent the gas price that will be used in the test cases when simulating transactions with the FundMe contract. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run(); // This line calls the run function of the DeployFundMe contract, which deploys the FundMe contract and returns its address. The returned address is then assigned to the fundMe state variable, allowing the test contract to interact with the deployed FundMe contract during testing.
        vm.deal(USER, STARTING_BALANCE); // This line sets the balance of the USER address to the value specified in STARTING_BALANCE (10 ether) using the vm.deal function. This is done to ensure that the USER address has sufficient funds to interact with the FundMe contract during testing.
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe)); // This line calls the fundFundMe function of the FundFundMe contract, passing the address of the deployed FundMe contract (fundMe) as an argument. This function will execute the funding process for the FundMe contract at the specified address, sending a predefined amount of Ether (SEND_VALUE) to it. The purpose of this call is to simulate a user funding the FundMe contract during testing.

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
