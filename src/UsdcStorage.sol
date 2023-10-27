// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract UsdcV1Storage {
    // FiatTokenProxyV2_1 storage layout
    address	public _owner;
    address public pauser;
    bool public	paused;
    address public blacklister;
    mapping(address => bool) public blacklisted;
    string public name;
    string public symbol;
    uint8 public decimals;
    string public currency;
    address	public masterMinter;
    bool public initialized;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    uint256 public totalSupply_;
    mapping(address => bool) public minters;
    mapping(address => uint256)	public minterAllowed;
    address public _rescuer;
    bytes32	DOMAIN_SEPARATOR;
    mapping(address => mapping(bytes32 => bool)) public _authorizationStates;
    mapping(address => uint256) public _permitNonces;
    uint8 public _initializedVersion;
}

contract UsdcV2Storage is UsdcV1Storage {
    mapping(address => bool) public whitelist;
}
