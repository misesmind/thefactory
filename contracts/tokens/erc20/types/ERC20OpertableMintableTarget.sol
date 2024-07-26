// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./ERC20MintableTarget.sol";
import "thefactory/security/operatable/types/OperatableTarget.sol";

contract ERC20OpertableMintableTarget is ERC20MintableTarget, OperatableTarget {

    function mint(
        uint256 amount,
        address to
    ) external payable virtual override(ERC20MintableTarget) onlyOperator(msg.sender) returns(uint256) {
        _mint(amount, to);
        return amount;
    }

    function burn(
        uint256 amount,
        address to
    ) external virtual override(ERC20MintableTarget) onlyOperator(msg.sender) returns(uint256) {
        _burn(amount, to);
        return amount;
    }

}