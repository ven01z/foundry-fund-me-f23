# Foundry Fund Me

This is a beginner Solidity project built while following the [Cyfrin Updraft Foundry Fund Me course](https://updraft.cyfrin.io/courses/foundry/foundry-fund-me).

The project demonstrates how to create, test, deploy, and interact with a simple crowdfunding smart contract using Solidity and Foundry.

> This repository documents my progress while learning smart contract development. It is an educational project.

## Table of Contents

- [Foundry Fund Me](#foundry-fund-me)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [What I Learned](#what-i-learned)
  - [Project Structure](#project-structure)
  - [Folder Explanation](#folder-explanation)
    - [`src/`](#src)
    - [`script/`](#script)
    - [`test/`](#test)
    - [`lib/`](#lib)
  - [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
    - [Installing Dependencies](#installing-dependencies)
  - [Usage](#usage)
  - [Build the Project](#build-the-project)
  - [Testing](#testing)
    - [Unit Tests](#unit-tests)
    - [Integration Tests](#integration-tests)
  - [Test Coverage](#test-coverage)
  - [Deploy Locally](#deploy-locally)
  - [Interaction Scripts](#interaction-scripts)
    - [Fund the Contract](#fund-the-contract)
    - [Withdraw the Funds](#withdraw-the-funds)
  - [Interacting with Cast](#interacting-with-cast)
  - [Deploying to a Testnet](#deploying-to-a-testnet)
    - [Create Environment Variables](#create-environment-variables)
    - [Load Environment Variables](#load-environment-variables)
    - [Get Testnet ETH](#get-testnet-eth)
    - [Deploy and Verify](#deploy-and-verify)
  - [Gas Snapshots](#gas-snapshots)
  - [Chisel](#chisel)
  - [Formatting](#formatting)
  - [Security Notes](#security-notes)
  - [Protecting Secrets](#protecting-secrets)
  - [Course Reference](#course-reference)
  - [License](#license)

## About

The `FundMe` contract allows users to send ETH to the contract as a donation.

Before accepting a donation, the contract checks whether the ETH sent is worth at least a minimum amount in USD. It uses a Chainlink price feed to calculate the current ETH/USD value.

The contract also:

- Records how much each user has funded.
- Stores the addresses of the funders.
- Allows only the owner to withdraw the funds.
- Resets the funding records after withdrawal.

This project uses mock price feeds during local testing so that the tests do not need to connect to a live Chainlink contract.

## What I Learned

While building this project, I learned about:

- Solidity smart contracts.
- Payable functions.
- Sending and receiving ETH.
- Contract ownership.
- Chainlink price feeds.
- Libraries in Solidity.
- Unit testing with Foundry.
- Integration testing.
- Foundry cheatcodes.
- Deployment scripts.
- Interaction scripts.
- Mock contracts.
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
├── lib/
├── foundry.toml
├── foundry.lock
├── Makefile
├── remappings.txt
└── README.md
```

## Folder Explanation

### `src/`

This folder contains the main smart contract code.

- `FundMe.sol` contains the crowdfunding contract.
- `PriceConverter.sol` contains functions for converting ETH values into USD values.

### `script/`

This folder contains scripts used to deploy and interact with the contract.

- `DeployFundMe.s.sol` deploys the `FundMe` contract.
- `HelperConfig.s.sol` selects the correct price-feed configuration.
- `Interactions.s.sol` contains scripts for funding and withdrawing from `FundMe`.

### `test/`

This folder contains the tests.

- `unit/` contains tests for individual contract functions.
- `integration/` contains tests for a complete contract workflow.
- `mocks/` contains fake contracts used during local testing.

### `lib/`

This folder contains external libraries used by the project, including:

- `forge-std`
- `foundry-devops`
- Chainlink contract libraries

## Getting Started

## Requirements

To run this project, you need:

- [Git](https://git-scm.com/)
- [Foundry](https://www.getfoundry.sh/)
- A terminal
- A testnet wallet if you want to deploy to a testnet
- Testnet ETH if you want to deploy to a testnet

Check whether Git is installed:

```bash
git --version
```

Check whether Foundry is installed:

```bash
forge --version
```

If Foundry is not installed, follow the [Foundry installation guide](https://www.getfoundry.sh/).

## Quickstart

Clone the repository:

```bash
git clone https://github.com/ven01z/foundry-fund-me-f23.git
```

Enter the project directory:

```bash
cd foundry-fund-me-f23
```

Build the project:

```bash
forge build
```

Run the tests:

```bash
forge test
```

If the build and tests complete successfully, the project is working correctly.

### Installing Dependencies

The required dependencies are already included in the project. If they are missing, install them with:

```bash
forge install
```

If Foundry DevOps is missing, install it with:

```bash
forge install Cyfrin/foundry-devops --no-commit
```

## Usage

## Build the Project

Compile the Solidity contracts with:

```bash
forge build
```

If the command succeeds, the contracts have compiled successfully.

## Testing

This project contains unit tests and integration tests.

### Unit Tests

The unit tests are located in:

```text
test/unit/FundMeTest.t.sol
```

The unit tests check individual parts of the `FundMe` contract, including:

- Whether the minimum funding value is correct.
- Whether the correct address becomes the owner.
- Whether the Chainlink price-feed version is correct.
- Whether insufficient funding reverts.
- Whether a user's funded amount is recorded.
- Whether a funder is added to the funders array.
- Whether only the owner can withdraw.
- Whether the owner can withdraw from one funder.
- Whether the owner can withdraw from multiple funders.

Run all tests:

```bash
forge test
```

Run the tests with detailed traces:

```bash
forge test -vvvv
```

Run one specific unit test:

```bash
forge test --match-test testWithdrawFromASingleFunder
```

### Integration Tests

The integration test is located in:

```text
test/integration/InteractionsTest.t.sol
```

The integration test checks the complete workflow:

1. Deploy the `FundMe` contract.
2. Give ETH to a test user called `alice`.
3. Have `alice` fund the contract.
4. Use the withdrawal interaction script.
5. Confirm that the `FundMe` contract has no ETH left.
6. Confirm that Alice's balance decreased by the funding amount.
7. Confirm that the owner's balance increased by the funding amount.

Run the integration test:

```bash
forge test --match-test testUserCanFundAndOwnerWithdraw -vv
```

Run the test with maximum trace details:

```bash
forge test --match-test testUserCanFundAndOwnerWithdraw -vvvv
```

## Test Coverage

To generate a test coverage report, run:

```bash
forge coverage
```

The report shows which parts of the contracts are reached by the tests.

## Deploy Locally

Anvil is a local Ethereum blockchain included with Foundry.

Start Anvil:

```bash
anvil
```

Keep Anvil running in one terminal.

Open a second terminal and deploy the contract:

```bash
forge script script/DeployFundMe.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

Anvil provides test accounts with test ETH, so this local deployment does not use real money.

## Interaction Scripts

The interaction scripts are located in:

```text
script/Interactions.s.sol
```

The project contains two interaction scripts:

- `FundFundMe` sends ETH to the `FundMe` contract.
- `WithdrawFundMe` withdraws the contract balance to the owner.

### Fund the Contract

After deploying locally, run:

```bash
forge script script/Interactions.s.sol:FundFundMe \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

This sends ETH to the most recently deployed `FundMe` contract.

### Withdraw the Funds

To withdraw the balance from the contract, run:

```bash
forge script script/Interactions.s.sol:WithdrawFundMe \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast
```

The withdrawal can only succeed when the account making the call is the owner of the `FundMe` contract.

## Interacting with Cast

Foundry's `cast` tool can also be used to interact with a deployed contract.

To fund a deployed contract:

```bash
cast send <FUNDME_CONTRACT_ADDRESS> \
    "fund()" \
    --value 0.1ether \
    --private-key $PRIVATE_KEY \
    --rpc-url $SEPOLIA_RPC_URL
```

To withdraw from a deployed contract:

```bash
cast send <FUNDME_CONTRACT_ADDRESS> \
    "withdraw()" \
    --private-key $PRIVATE_KEY \
    --rpc-url $SEPOLIA_RPC_URL
```

Replace:

```text
<FUNDME_CONTRACT_ADDRESS>
```

with the address of the deployed `FundMe` contract.

## Deploying to a Testnet

This project can be deployed to a network such as Sepolia.

### Create Environment Variables

Create a `.env` file in the project root:

```bash
SEPOLIA_RPC_URL=your_rpc_url
PRIVATE_KEY=your_test_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

The variables are used for:

- `SEPOLIA_RPC_URL`: Connecting to the Sepolia network.
- `PRIVATE_KEY`: Signing transactions.
- `ETHERSCAN_API_KEY`: Verifying the contract on Etherscan.

Use a development wallet that does not contain valuable funds.

Never commit your `.env` file, private key, or API keys to GitHub.

### Load Environment Variables

Depending on your terminal, you may load the variables with:

```bash
source .env
```

### Get Testnet ETH

Get Sepolia ETH from a Sepolia faucet before deploying.

You can use the [Chainlink faucet](https://faucets.chain.link/) or another trusted Sepolia faucet.

### Deploy and Verify

Deploy the contract and verify it on Etherscan:

```bash
forge script script/DeployFundMe.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

Only use testnet ETH when experimenting with this project.

## Gas Snapshots

Foundry can measure gas usage with:

```bash
forge snapshot
```

This creates or updates a file called:

```text
.gas-snapshot
```

Gas snapshots help compare gas usage before and after making changes to the contract.

For example, they can help determine whether a new version of `withdraw()` uses more or less gas.

## Chisel

Chisel is Foundry's interactive Solidity command-line tool.

Start Chisel with:

```bash
chisel
```

You can use it to experiment with Solidity expressions:

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

This project is for educational purposes and is not a production-ready financial application.

Important things to remember:

- The owner can withdraw all funds from the contract.
- The contract depends on a Chainlink price feed.
- The correct price-feed address must be used for each network.
- The price feed must return valid and reliable data.
- The withdrawal function loops through the list of funders.
- A very large number of funders could make withdrawal expensive.
- Testnet ETH has no real value, but mainnet ETH does.
- This project has not received a professional security audit.
- Do not use this contract to hold real funds without further testing and auditing.

## Protecting Secrets

Do not upload your `.env` file if it contains private keys or API keys.

Your `.gitignore` should include:

```gitignore
.env
broadcast/
cache/
out/
```

Never place any of the following inside a Solidity file, script, README, or GitHub repository:

- A private key.
- A wallet seed phrase.
- An API key.
- Passwords.
- Other secret information.

## Course Reference

This project follows the Cyfrin Updraft Foundry Fund Me course.

- [Cyfrin Updraft Foundry Fund Me Course](https://updraft.cyfrin.io/courses/foundry/foundry-fund-me)
- [Official Cyfrin Foundry Fund Me Repository](https://github.com/Cyfrin/foundry-fund-me-cu)
- [Foundry Documentation](https://www.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)

## License

This project is licensed under the MIT License.