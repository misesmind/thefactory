// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./ERC721Target.sol";

contract ERC721Stub is ERC721Target {

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        // _name = name_;
        // _symbol = symbol_;
        _setMetadata(name_, symbol_);
    }

}