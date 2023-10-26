// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {UsdcV2} from "../src/UsdcV2.sol";

contract UsdcV2Test is Test {
    uint256 mainnetFork;
    address user1;
    address user2;
    address private admin;
    address public constant owner = 0xFcb19e6a322b27c06842A71e8c725399f049AE3a;
    address public constant contractProxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
    UsdcV2 usdc;


    function setUp() public {
        // Create and Select Fork 
        mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
        vm.selectFork(mainnetFork);

        // Get admin
        bytes32 adminSlotVal = vm.load(contractProxy, ADMIN_SLOT);
        // console2.logBytes32(adminSlotVal);
        admin = address(uint160(uint256(adminSlotVal)));

        user1 = makeAddr("Alice");
        user2 = makeAddr("Bob");

        vm.label(user1, "Alice");
        vm.label(user2, "Bob");

        // Let user1 have initial balances of usdc
        deal(contractProxy, user1, 10 ether);
        
        // Upgrade logic contract
        vm.startPrank(admin);
        usdc = new UsdcV2("USDC", "USDC");
        (bool success, ) = contractProxy.call(abi.encodeWithSignature("upgradeTo(address)", address(usdc)));
        require(success, "Not successfully upgrage!");

        vm.stopPrank();
    }

    function testSwitchFork() public {
         assertEq(vm.activeFork(), mainnetFork);
    }

    function testWhitelistOwnerCanAdd() public {
        vm.startPrank(owner);

        // use low level call
        // (bool success,) = contractProxy.call(abi.encodeWithSignature("addToWhitelist(address)", user1));
        // console2.log(success);

        // use interface
        UsdcV2(contractProxy).addToWhitelist(user1);

        assertEq(UsdcV2(contractProxy).whitelist(user1), true);
        vm.stopPrank();
    }

    function testWitelistCannotTransfer() public {
        vm.startPrank(user1);

        vm.expectRevert("Not in Whitelist!");
        UsdcV2(contractProxy).transfer(user2, 1 ether);
    }
    
    function testWhitelistCanTransfer() public {
        // add to whitelist
        vm.startPrank(owner);
        UsdcV2(contractProxy).addToWhitelist(user1);

        vm.startPrank(user1);
        UsdcV2(contractProxy).transfer(user2, 1 ether);

        assertEq(UsdcV2(contractProxy).balanceOf(user2), 1 ether);

        vm.stopPrank();
    }
}