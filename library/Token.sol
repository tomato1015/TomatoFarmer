pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./ERC20Detailed.sol";


contract Token is ERC20Detailed, ERC20 {
    constructor(uint256 amount, uint8 decimals,uint256 precision,string memory name, string memory symbol) public ERC20Detailed(name, symbol, decimals) {
        _mint(msg.sender, amount * (10 ** precision));
    }
}

