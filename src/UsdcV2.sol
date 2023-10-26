// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract UsdcV2  {
    // FiatTokenProxy storage layout
    // Get by --pretty ./src/FiatTokenV2_1.sol:FiatTokenV2_1 storage > FiatTokenV2_1_storage_layout.txt
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

    // constructor(string memory name, string memory symbol) ERC20(name, symbol){}

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

    // ERC 20 events
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // ERC 20
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        allowed[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount) public virtual onlyWhitelist returns (bool) {
        balances[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balances[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowance = allowed[from][msg.sender]; // Saves gas for limited approvals.

        if (allowance != type(uint256).max) allowed[from][msg.sender] = allowance - amount;

        balances[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}