// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title ERC165 Interface registration interface.
 * @notice Allows for self-reporting implementation of a set of function selectors.
 * @notice Used within proxies to self-report porxy logic target configuration of a set of function selectors.
 * @dev see https://eips.ethereum.org/EIPS/eip-165
 * @custom:interfaceid 0x01ffc9a7
 */
interface IERC165 {

    /**
     * @notice query whether contract has registered support for given interface
     * @param interfaceId interface id of which to query support.
     * @return isSupported whether interface is supported
     * @custom:sighash 0x01ffc9a7
     */
    function supportsInterface(
        bytes4 interfaceId
    ) external view returns (bool isSupported);
  
}