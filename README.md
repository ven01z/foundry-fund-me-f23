# Foundry Fund Me

This is a beginner Solidity project built while following the Cyfrin Updraft Foundry Fund Me course.

The project teaches how to create, test, deploy, and interact with a simple crowdfunding smart contract using Solidity and Foundry.

## What Does FundMe Do?

The `FundMe` contract allows users to send ETH to the contract.

Before accepting the funds, the contract checks whether the contribution is worth at least a minimum amount in USD. It uses a Chainlink price feed to convert the value of ETH into USD.

The contract also:

- Records how much each user has funded.
- Stores the addresses of the funders.
- Allows only the owner to withdraw the funds.
- Resets the funding records after withdrawal.

> This project is for learning purposes and has not been audited.

## What I Learned

While building this project, I learned about:

- Solidity smart contracts.
- Payable functions.
- ETH transfers.
- Contract ownership.
- Chainlink price feeds.
- Unit testing with Foundry.
- Integration testing.
- Foundry cheatcodes.
- Deployment scripts.
- Interaction scripts.
- Local testing with Anvil.
- Gas snapshots.
- Chisel, Foundry's Solidity command-line tool.
- Organizing a smart contract project on GitHub.

## Project Structure

```text
.
├── src/
│   ├── FundMe.sol
│   └── PriceConverter.sol
│
├── script/
│   ├── DeployFundMe.s.sol
│   ├── HelperConfig.s.sol
│   └── Interactions.s.sol
│
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol
│   ├── integration/
│   │   └── InteractionsTest.t.sol
│   └── mocks/
│       └── MockV3Aggregator.sol
│
├── foundry.toml
├── foundry.lock
├── Makefile
├── remappings.txt
└── README.md
```

## Folder Explanation

### `src`

This folder contains the main smart contract code.

- `FundMe.sol` contains the crowdfunding contract.
- `PriceConverter.sol` contains functions for converting ETH values into USD values.

### `script`

This folder contains scripts used to deploy and interact with the contract.

- `DeployFundMe.s.sol` deploys the `FundMe` contract.
- `HelperConfig.s.sol` selects the correct price feed configuration.
- `Interactions.s.sol` contains scripts for funding and withdrawing from `FundMe`.

### `test`

This folder contains the tests.

- `unit` contains tests for individual contract functions.
- `integration` contains tests for a complete workflow.
- `mocks` contains fake contracts used during local testing.

## Requirements

To run this project, you need:

- Git
- Foundry
- A terminal
- A testnet wallet if you want to deploy to a testnet

You can check whether Foundry is installed with:

```bash
forge --version
```

If Foundry is not installed, follow the official installation guide:

[Foundry Installation Guide](https://www.getfoundry.sh/)

## Installation

Clone the repository:

```bash
git clone https://github.com/ven01z/foundry-fund-me-f23.git
```

Enter the project folder:

```bash
cd foundry-fund-me-f23
```

Install the dependencies:

```bash
forge install
```

If the project does not already contain Foundry DevOps, install it with:

```bash
forge install Cyfrin/foundry-devops --no-commit
```

## Build the Project

Compile the contracts with:

```bash
forge build
```

If the build succeeds, the Solidity contracts compiled successfully.

## Run the Tests

Run all tests:

```bash
forge test
```

Run the tests with detailed information:

```bash
forge test -vvvv
```

Run one specific test:

```bash
forge test --match-test testWithdrawFromASingleFunder
```

Run the integration test:

```bash
forge test --match-test testUserCanFundAndOwnerWithdraw -vv
```

## Unit Tests

The unit tests are located in:

```text
test/unit/FundMeTest.t.sol
```

These tests check individual pieces of the `FundMe` contract, including:

- Whether the minimum funding value is correct.
- Whether the correct address becomes the owner.
- Whether the price-feed version is correct.
- Whether insufficient funding reverts.
- Whether a user's funded amount is recorded.
- Whether a funder is added to the funders array.
- Whether only the owner can withdraw.
- Whether the owner can withdraw from one funder.
- Whether the owner can withdraw from multiple funders.

## Integration Test

The integration test is located in:

```text
test/integration/InteractionsTest.t.sol
```

It tests the complete process:

1. Deploy the `FundMe` contract.
2. Give ETH to a test user called `alice`.
3. Have `alice` fund the contract.
4. Use the withdrawal interaction script.
5. Check that the `FundMe` contract has no ETH left.
6. Check that Alice lost the amount she funded.
7. Check that the owner received the funds.

Run the integration test with:

```bash
forge test --match-test testUserCanFundAndOwnerWithdraw -vv
```

## Deploy Locally

First, start a local Anvil blockchain:

```bash
anvil
```

Leave Anvil running in the terminal.

In another terminal, deploy the contract:

```bash
forge script script/DeployFundMe.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

Anvil provides test accounts with test ETH, so this does not use real money.

## Interact with the Contract

After deploying, you can run the funding script:

```bash
forge script script/Interactions.s.sol:FundFundMe \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

To withdraw the funds:

```bash
forge script script/Interactions.s.sol:WithdrawFundMe \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

The interaction scripts use Foundry DevOps to find the most recent `FundMe` deployment.

## Chainlink Mock

When testing locally, the project uses:

```text
MockV3Aggregator.sol
```

This is a fake Chainlink price feed.

Using a mock means the tests do not need to connect to a real Chainlink contract. It makes the tests faster and more predictable.

## Gas Snapshots

Foundry can measure gas usage with:

```bash
forge snapshot
```

This creates or updates:

```text
.gas-snapshot
```

Gas snapshots help compare gas usage after changing the contract.

For example, you can compare whether a new version of `withdraw()` uses more or less gas than the previous version.

## Chisel

Chisel is Foundry's interactive Solidity tool.

Start it with:

```bash
chisel
```

You can use it to quickly experiment with Solidity:

```solidity
uint256 cat = 1;
uint256 dog = 2;
cat + dog;
```

Chisel is useful for testing small ideas without creating a complete contract or test file.

## Formatting

Format the Solidity files with:

```bash
forge fmt
```

Check whether the files are formatted correctly without changing them:

```bash
forge fmt --check
```

## Security Notes

This is an educational project, not a production-ready financial application.

Important things to remember:

- The owner can withdraw all funds from the contract.
- The contract depends on a Chainlink price feed.
- The correct price-feed address must be used for each network.
- The withdrawal function loops through the list of funders.
- A very large number of funders could make withdrawal expensive.
- Testnet ETH has no real value, but mainnet ETH does.
- Never commit private keys or API keys to GitHub.

## Protecting Secrets

Do not upload your `.env` file if it contains private keys or API keys.

Your `.gitignore` should include:

```gitignore
.env
broadcast/
cache/
out/
```

Never place a real private key directly inside a Solidity file, script, README, or GitHub repository.

## Course Reference

This project follows the Cyfrin Updraft Foundry Fund Me course.

- [Cyfrin Updraft Foundry Fund Me Course](https://updraft.cyfrin.io/courses/foundry/foundry-fund-me)
- [Official Cyfrin Foundry Fund Me Repository](https://github.com/Cyfrin/foundry-fund-me-cu)
- [Foundry Documentation](https://www.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)

## License

This project is licensed under the MIT License.