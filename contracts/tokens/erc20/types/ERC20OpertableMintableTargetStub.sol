// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./ERC20OpertableMintableTarget.sol";
import "../interfaces/IERC20OperatableMintable.sol";

contract ERC20OpertableMintableTargetStub is ERC20OpertableMintableTarget {

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint8 tokenDecimals,
        uint256 newTokenSupply,
        address owner_
    ) {
        _initERC20(
            tokenName,
            tokenSymbol,
            tokenDecimals
        );
        _mint(newTokenSupply, owner_);
        _initOwner(owner_);
        _isOperator(owner_, true);
    }

}