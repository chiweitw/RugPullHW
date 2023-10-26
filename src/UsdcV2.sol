// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UsdcV2 is ERC20 {
    mapping(address => bool) public whitelist;

    constructor(string memory name, string memory symbol) ERC20(name, symbol){}

    modifier isWhitelist {
            require(whitelist[msg.sender], "Not in Whitelist!");
            _;
    }

    function addToWhitelist(address addr) public {
        whitelist[addr] = true;
    }

    function transfer(address to, uint256 value) override public virtual isWhitelist returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }
}