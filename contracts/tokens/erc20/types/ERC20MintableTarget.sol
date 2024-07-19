// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;


import "./ERC20Target.sol";
import "../interfaces/IERC20Mintable.sol";
import "./ERC20Storage.sol";

abstract contract ERC20MintableTarget is ERC20Target, IERC20Mintable {

    // address minter;
    // mapping(address => bool) private operators;

    // constructor() {
    //     minter = msg.sender;
    //     operators[msg.sender] = true;
    // }

    // modifier isOperator {
    //     // require(operators[msg.sender], "Operator: caller is not an operator");
    //     _;
    // }

    function mint(
        uint256 amount,
        address to
    ) external payable virtual returns(uint256) {
        _mint(amount, to);
        return amount;
    }

    // function mint(
    //     address to,
    //     uint256 amount
    // ) external payable virtual returns(bool success) {
    //     _mint(amount, to);
    //     success = true;
    // }

    function burn(
        uint256 amount,
        address to
    ) external virtual returns(uint256) {
        _burn(amount, to);
        return amount;
    }

    // function burn(
    //     address to,
    //     uint256 amount
    // ) external virtual returns(bool success) {
    //     _burn(amount, to);
    //     success = true;
    // }
    
}