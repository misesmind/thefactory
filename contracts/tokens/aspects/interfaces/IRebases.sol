// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/introspection/erc165/interfaces/IERC165.sol";

/**
 * @notice Marker interface to indicate a token rebases balances and supply.
 * @notice ONLY for tokens that DO rebase.
 */
interface IRebases is IERC165 {

    /**
     * @return thisDoes MUST return true.
     */
    function doesRebase()
    external pure returns(bool thisDoes);

    function sharesBalanceOf(address account)
    external view returns(uint256 balance);

}