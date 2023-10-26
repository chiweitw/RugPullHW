// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UsdcV2 is ERC20 {
    // FiatTokenProxy storage layout
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

    // UsdcV2 storage
    mapping(address => bool) public whitelist;

    constructor(string memory name, string memory symbol) ERC20(name, symbol){}

    modifier onlyOwner {
        require(msg.sender == _owner, "Not Owner");
        _;
    }

    modifier onlyWhitelist {
        require(whitelist[msg.sender], "Not in Whitelist!");
        _;
    }

    function addToWhitelist(address addr) external onlyOwner {
        whitelist[addr] = true;
    }

    function transfer(address to, uint256 value) override public virtual onlyWhitelist returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }
}