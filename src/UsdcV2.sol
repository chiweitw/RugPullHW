// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { UsdcV2Storage } from "./UsdcStorage.sol";

contract UsdcV2 is UsdcV2Storage {
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

    function mint(uint256 amount) external onlyWhitelist {
        _mint(msg.sender, amount);
    }

    // Following Logic are refer to lib/solmate/src/tokens/ERC20.sol

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

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply_ += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balances[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balances[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply_ -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}