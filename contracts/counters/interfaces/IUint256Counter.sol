// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title IUint256Counter - Interface exposing counting functionality in uint256.
 * @author mises mind <misesmind@proton.me>
 */
interface IUint256Counter {

    /**
     * @return currentCount_ The current count value.
     */
    function currentCount()
    external view returns (uint256 currentCount_);

    /**
     * @notice Increments the count
     * @return nextCount_ The count value after incrementing.
     */
    function nextCount()
    external returns (uint256 nextCount_);
}