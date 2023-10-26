// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {UsdcV2} from "../src/UsdcV2.sol";

contract UsdcV2Test is Test {
    uint256 mainnetFork;
    address user1;
    address user2;
    address private admin;
    address private owner;
    address private constant contractProxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
    UsdcV2 usdcV2;

    function setUp() public {
        // Create and Select Fork 
        mainnetFork = vm.createFork(vm.envString("MAINNET_RPC_URL"));
        vm.selectFork(mainnetFork);

        // Get admin
        bytes32 adminSlotVal = vm.load(contractProxy, ADMIN_SLOT);
        // console2.logBytes32(adminSlotVal); // 0x000000000000000000000000807a96288a1a408dbc13de2b1d087d10356395d2
        admin = address(uint160(uint256(adminSlotVal))); // 0x807a96288a1a408dbc13de2b1d087d10356395d2

        // Get owner
        bytes32 ownerSlotVal = vm.load(contractProxy, 0);
        // console2.logBytes32(ownerSlotVal); // 0x000000000000000000000000fcb19e6a322b27c06842a71e8c725399f049ae3a
        owner = address(uint160(uint256(ownerSlotVal))); // 0xfcb19e6a322b27c06842a71e8c725399f049ae3a

        user1 = makeAddr("Alice");
        user2 = makeAddr("Bob");

        vm.label(user1, "Alice");
        vm.label(user2, "Bob");
        
        // Upgrade logic contract
        vm.startPrank(admin);
        usdcV2 = new UsdcV2();
        (bool success, ) = contractProxy.call(abi.encodeWithSignature("upgradeTo(address)", address(usdcV2)));
        require(success, "Not successfully upgrage!");

        vm.stopPrank();
    }

    function testSwitchFork() public {
         assertEq(vm.activeFork(), mainnetFork);
    }

    function testAddToWhitelist() public {
        // fail case
        vm.prank(user1);
        vm.expectRevert("Not Owner");
        UsdcV2(contractProxy).addToWhitelist(user1);

        // owner add user1 to whitelist
        vm.prank(owner);
        UsdcV2(contractProxy).addToWhitelist(user1);

        // check user1 in whitelist
        assertEq(UsdcV2(contractProxy).whitelist(user1), true);
    }


    function testOnlyWitelistCanTransfer() public {
        // Let user1 have initial balances of usdc
        deal(contractProxy, user1, 1 ether);

        // fail case
        vm.prank(user1);
        vm.expectRevert("Not in Whitelist!");
        UsdcV2(contractProxy).transfer(user2, 1 ether);

        // owner add user1 to whitelist
        vm.prank(owner);
        UsdcV2(contractProxy).addToWhitelist(user1);

        // switch back to user1 and transfer
        vm.prank(user1);
        UsdcV2(contractProxy).transfer(user2, 1 ether);
        assertEq(UsdcV2(contractProxy).balances(user2), 1 ether);
    }

    function testOnlyWhitelistCanMint() public {
        // fail case
        vm.prank(user1);
        vm.expectRevert("Not in Whitelist!");
        UsdcV2(contractProxy).mint(1 ether);

        // owner add user1 to whitelist
        vm.prank(owner);
        UsdcV2(contractProxy).addToWhitelist(user1);

        // switch back to user1 and mint
        vm.prank(user1);
        UsdcV2(contractProxy).mint(1 ether);
        assertEq(UsdcV2(contractProxy).balances(user1), 1 ether); 
    }
}