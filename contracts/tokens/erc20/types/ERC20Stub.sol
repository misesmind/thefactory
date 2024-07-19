// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./ERC20MintableTarget.sol";

contract ERC20Stub is ERC20MintableTarget {


    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 tokenDecimals,
        uint256 newTokenSupply
    ) {
        _initERC20(
            tokenName,
            tokenSymbol,
            tokenDecimals
        );
        _mint(newTokenSupply, msg.sender);
    }

}