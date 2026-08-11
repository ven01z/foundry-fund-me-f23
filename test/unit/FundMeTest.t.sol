// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe; // state variable, accessible everywhere in this contract

    // makeAddr is a function from the forge-std library that creates a new address for testing purposes.
    address USER = makeAddr("user"); // It takes a string as an argument, which is used to generate a unique address. In this case, the string "user" is passed to makeAddr, and the resulting address is assigned to the USER variable. This allows you to simulate interactions with the FundMe contract from the perspective of a specific user during testing.
    uint256 constant SEND_VALUE = 10e18; // 10 ETH // 10e18 // This constant is used to represent the amount of ether that will be sent in the test cases when interacting with the FundMe contract. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.
    uint256 constant STARTING_BALANCE = 10 ether; // 10 ETH // This constant is used to represent the starting balance of the USER address during testing. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.
    uint256 constant GAS_PRICE = 1; // 1 gwei // This constant is used to represent the gas price that will be used in the test cases when simulating transactions with the FundMe contract. It allows you to easily reference this value throughout the test contract without having to repeatedly write out the full value.

    function setUp() external{
       // fundMe = new FundMe(); // The reason we are not using this line is because we want to deploy the FundMe contract using the DeployFundMe script, which handles the deployment process and provides the necessary configuration for the contract. By using the DeployFundMe script, we can ensure that the FundMe contract is deployed with the correct parameters and settings, making it easier to manage and maintain the deployment process.
        DeployFundMe deployFundMe = new DeployFundMe(); // this line creates a new instance of the DeployFundMe contract, which is responsible for deploying the FundMe contract. It allows you to call the run() function of the DeployFundMe contract to deploy the FundMe contract and obtain its address.
        fundMe = deployFundMe.run(); // this line calls the run() function of the DeployFundMe contract, which deploys the FundMe contract and returns its address. The returned address is then assigned to the fundMe state variable, allowing you to interact with the deployed FundMe contract in the test cases.
        vm.deal(USER, STARTING_BALANCE); // deal() is a function from the forge-std library that allows you to set the balance of an address for testing purposes. It takes two arguments: the address whose balance you want to set (in this case, USER) and the amount of ether you want to assign to that address (in this case, STARTING_BALANCE, which is 10 ether). This allows you to simulate interactions with the FundMe contract from the perspective of a user with a specific balance during testing.
        vm.txGasPrice(GAS_PRICE); // This line sets the gas price for the next transaction to the value of the GAS_PRICE constant.
    }

    function testMinimumDollarsIsFive() public view{ 
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view{
        console.log("Owner address:", fundMe.i_owner()); // For debugging purposes, this line logs the owner address of the FundMe contract to the console. It uses the console.log() function from the forge-std library to print the value of fundMe.i_owner(), which retrieves the owner address of the FundMe contract. This can be helpful for verifying that the owner is set correctly during testing.
        console.log("Deployer address:", msg.sender); 
        assertEq(fundMe.i_owner(), msg.sender); // This line asserts that the owner of the FundMe contract (retrieved using the i_owner() function) is equal to the address that deployed the contract (msg.sender). If the assertion fails, the test will fail, indicating that the owner is not set correctly during deployment.
    }

    function testPriceFeedVersionIsAccurate() public view{
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // expectRevert() is a function from the forge-std library that allows you to test if a function call reverts as expected. It sets up an expectation that the next function call will revert, and if it does not, the test will fail.    
        fundMe.fund{value: 1e15}(); // 5e18 is 5 * 10^18 wei, which is 5 ETH. This line is calling the fund() function of the FundMe contract and sending 5 ETH along with the call. Since the minimum funding amount is set to 5 USD (in terms of ETH), this test checks if the fund() function correctly reverts when an insufficient amount of ETH is sent.
        
    }

    function testFundUpdatesFundedDataStructure() public {
        // vm.prank(USER) // means the next calls will act as if they come from user.
        vm.prank(USER); // prank() is a function from the forge-std library that allows you to simulate a transaction from a different address. It sets the msg.sender to the specified address for the next function call. In this case, it sets msg.sender to USER, which is the address created earlier using makeAddr("user"). This allows you to test the fund() function as if it were being called by the USER address.
        fundMe.fund{value: SEND_VALUE}(); // 10e18 is 10 * 10^18 wei, which is 10 ETH. This line is calling the fund() function of the FundMe contract and sending 10 ETH along with the call.
        
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(USER)); // This line is calling the getAddressToAmountFunded() function of the FundMe contract, passing in the address of the current contract (address(this)). It retrieves the amount of ETH that has been funded by this address and stores it in the amountFunded variable.
        assertEq(amountFunded, SEND_VALUE); // This line asserts that the amount funded by address(1) is equal to 10 ETH (10e18 wei). If the assertion fails, the test will fail.
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        
        address funder = fundMe.getFunder(0); // This line is calling the getFunder() function of the FundMe contract, passing in the index 0. It retrieves the address of the first funder in the array of funders and stores it in the funder variable.
        assertEq(funder, USER); // This line asserts that the first funder in the array is equal to the USER address. If the assertion fails, the test will fail.
    }

    modifier funded() { // This modifier is used to set up a test scenario where the FundMe contract has already been funded by the USER address. It allows you to reuse this setup in multiple test functions without duplicating code.
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER); // This line is setting the msg.sender to USER for the next function call, simulating a transaction from the USER address.
        vm.expectRevert();
        fundMe.withdraw(); // This line is calling the withdraw() function of the FundMe contract. Since the msg.sender is set to USER (who is not the owner), it is expected to revert with the FundMe__NotOwner error.
    }

    function testWithDrawWithASingleFunder() public funded {
        // Arrange / This comment indicates that the following lines of code are setting up the initial conditions for the test case. In this case, it is retrieving the starting balances of the owner and the FundMe contract before the withdrawal takes place.
        uint256 startingOwnerBalance = fundMe.i_owner().balance; // This line retrieves the balance of the owner of the FundMe contract and stores it in the startingOwnerBalance variable. It uses the i_owner() function to get the owner's address and then accesses the balance property of that address.
        uint256 startingFundMeBalance = address(fundMe).balance; // This line retrieves the balance of the FundMe contract itself and stores it in the startingFundMeBalance variable. It uses the address() function to get the address of the FundMe contract and then accesses the balance property of that address.

        // Act / This comment indicates that the following lines of code are performing the main action of the test case, which is to withdraw the funds from the FundMe contract to the owner's address.
        vm.prank(fundMe.i_owner()); // This line sets the msg.sender to the owner of the FundMe contract for the next function call, simulating a transaction from the owner's address.
        fundMe.withdraw(); 
        
        // Assert / This comment indicates that the following lines of code are checking the results of the test case to ensure that the expected outcomes have occurred after the withdrawal.
        uint256 endingOwnerBalance = fundMe.i_owner().balance; // This line retrieves the balance of the owner after the withdrawal and stores it in endingOwnerBalance.
        uint256 endingFundMeBalance = address(fundMe).balance; // This line retrieves the balance of the FundMe contract after the withdrawal and stores it in endingFundMeBalance.

        assertEq(endingFundMeBalance, 0); // This line asserts that the ending balance of the FundMe contract is 0, meaning all funds have been withdrawn.
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance); // This line asserts that the sum of the starting balances of both the FundMe contract and the owner equals the ending balance of the owner, confirming that all funds were transferred correctly.
    }

    function testWithDrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10; // This line declares a variable numberOfFunders of type uint160 and assigns it the value 10. It represents the total number of funders that will be simulated in the test case.
        uint160 startingFunderIndex = 1; // This line declares a variable startingFunderIndex of type uint160 and assigns it the value 1. It represents the index from which the loop will start creating funder addresses.

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) { // This line starts a for loop that iterates from startingFunderIndex (1) to numberOfFunders (10). It creates multiple funder addresses and simulates funding the FundMe contract from each of them.
            hoax(address(i), SEND_VALUE); // hoax() is a function from the forge-std library that combines vm.prank() and vm.deal(). It sets the msg.sender to the specified address (in this case, address(i)) and assigns it a balance of SEND_VALUE (10 ETH). This allows you to simulate funding the FundMe contract from different addresses with a specific amount of ETH.
            fundMe.fund{value: SEND_VALUE}(); // This line calls the fund()
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance; // This line retrieves the balance of the owner of the FundMe contract before the withdrawal and stores it in startingOwnerBalance.
        uint256 startingFundMeBalance = address(fundMe).balance; // This line retrieves
    
        // Act
        vm.startPrank(fundMe.getOwner()); // This line sets the msg.sender to the owner of the FundMe contract for the next function calls, simulating a transaction from the owner's address.
        fundMe.withdraw(); // This line calls the withdraw() function of the FundMe contract, which transfers all funds from the contract to the owner's address.
        vm.stopPrank(); // This line stops the prank, reverting msg.sender back to its original value (the address that called the test
   
        // Assert
        assert(address(fundMe).balance == 0); // This line asserts that the ending balance of the FundMe contract is 0, meaning all funds have been withdrawn.
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }   

    function testWithDrawFromMultipleFundersCheaper() public funded {
        // Arrange
        uint160 numberOfFunders = 10; // This line declares a variable numberOfFunders of type uint160 and assigns it the value 10. It represents the total number of funders that will be simulated in the test case.
        uint160 startingFunderIndex = 1; // This line declares a variable startingFunderIndex of type uint160 and assigns it the value 1. It represents the index from which the loop will start creating funder addresses.

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) { // This line starts a for loop that iterates from startingFunderIndex (1) to numberOfFunders (10). It creates multiple funder addresses and simulates funding the FundMe contract from each of them.
            hoax(address(i), SEND_VALUE); // hoax() is a function from the forge-std library that combines vm.prank() and vm.deal(). It sets the msg.sender to the specified address (in this case, address(i)) and assigns it a balance of SEND_VALUE (10 ETH). This allows you to simulate funding the FundMe contract from different addresses with a specific amount of ETH.
            fundMe.fund{value: SEND_VALUE}(); // This line calls the fund()
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance; // This line retrieves the balance of the owner of the FundMe contract before the withdrawal and stores it in startingOwnerBalance.
        uint256 startingFundMeBalance = address(fundMe).balance; // This line retrieves
    
        // Act
        vm.startPrank(fundMe.getOwner()); // This line sets the msg.sender to the owner of the FundMe contract for the next function calls, simulating a transaction from the owner's address.
        fundMe.cheaperWithdraw(); // This line calls the cheaperWithdraw() function of the FundMe contract, which transfers all funds from the contract to the owner's address.
        vm.stopPrank(); // This line stops the prank, reverting msg.sender back to its original value (the address that called the test
   
        // Assert
        assert(address(fundMe).balance == 0); // This line asserts that the ending balance of the FundMe contract is 0, meaning all funds have been withdrawn.
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }   

}