// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-inline-assembly
import {
    Uint256CounterLayout
} from "./Uint256CounterLayout.sol";

/**
 * @title Uint256CounterRepo - Library for storage operations upon a Uint256CounterLayout.Struct.
 * @author mises mind <misesmind@proton.me>
 */
library Uint256CounterRepo {

    using Uint256CounterLayout for Uint256CounterLayout.Struct;
    using Uint256CounterLayout for bytes32;
    using Uint256CounterRepo for bytes32;
  
    // TODO Replace with address of deployed layout library.
    // Defines the default offset applied to all provided storage ranges for use with operating on a storage layout struct.
    bytes32 constant internal STORAGE_RANGE_OFFSET = keccak256(type(Uint256CounterLayout).creationCode);

    /**
     * @dev "Binds" a struct to a storage slot.
     * @param storageRange The first slot to use in the range of slots used by the struct.
     * @return layout A struct from a Layout library bound to the provided slot.
     */
    function _count(
        bytes32 storageRange
    ) internal pure returns(Uint256CounterLayout.Struct storage layout) {
        storageRange ^= STORAGE_RANGE_OFFSET;
        // assembly{layout.slot := storageRange}
        layout = storageRange._layout();
    }

    function _initCount(
        bytes32 storageRange,
        uint256 countInit
    ) internal {
        storageRange._count().count = countInit;
    }

    /**
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @return currentCount_ The current count value.
     */
    function _currentCount(
        bytes32 storageRange
    ) internal view  returns ( uint256 currentCount_ ) {
        currentCount_ = storageRange._count()._currentCount();
    }

    /**
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @return currentCount_ The current count value.
     */
    function currentCount(
        bytes32 storageRange
    ) external view returns ( uint256 currentCount_ ) {
        currentCount_ = storageRange._currentCount();
    }

    /**
     * @notice Increments the count
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @return nextCount_ The count value after incrementing.
     */
    function _nextCount(
        bytes32 storageRange
    ) internal returns ( uint256 nextCount_ ) {
        nextCount_ = storageRange._count()._nextCount();
    }

    /**
     * @notice Increments the count
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @return nextCount_ The count value after incrementing.
     */
    function nextCount(
        bytes32 storageRange
    ) external returns ( uint256 nextCount_ ) {
        nextCount_ = storageRange._nextCount();
    }

}