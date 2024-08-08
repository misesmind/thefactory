// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "contracts/tokens/erc6909/interfaces/IERC6909Metadata.sol";

interface IERC6909MetadataEnumerated is IERC6909Metadata {
    function nameOfId(uint256 id) external view returns (string memory);
    function symbolOfId(uint256 id) external view returns (string memory symbol_);
}
