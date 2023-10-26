# RugPullHW
Practice using proxy to update contract.

## Practices
1. Upgrade the TradingCenter contract (`/src/TradingCenter.sol`) and implement a rug pull function to steal user's usdt & usdc.
2. Upgrade the [USDC](https://etherscan.io/address/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48#code) and implement the features:
  - a whitelist
  - only whitelist can transfer
  - only whitelist can mint token

## Get Started

1. Make sure you have Foundry set up. If not, you can refer to the [installation guide](https://book.getfoundry.sh/getting-started/installation).

2. Run the following command to install the required dependencies:
   ```bash
   forge install
   ```
3. Run the following command to run the tests:
   ```bash
   forge test
   ```
## Test Result
<img width="1001" alt="image" src="https://github.com/chiweitw/RugPullHW/assets/34131145/475b8960-276a-4729-9f6c-407ed892b0e6">
