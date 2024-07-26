// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    Uint256CounterLayout,
    Uint256CounterRepo,
    IUint256Counter,
    Uint256CounterService
} from "../libs/Uint256CounterService.sol";

/**
 * @title Uint256CounterStorage Contract to facilitate inheritance usage of Service libraries.
 * @author cyotee dgoe <cyotee@syscoin.org>
 */
abstract contract Uint256CounterStorage {

    function _initCount(
        uint256 countInit
    ) internal {
        Uint256CounterService._initCount(countInit);
    }

    /**
     * @return currentCount_ The current count value.
     */
    function _currentCount()
    internal view  returns (uint256 currentCount_) {
        currentCount_ = Uint256CounterService._currentCount();
    }

    /**
     * @notice Increments the count
     * @return nextCount_ The count value after incrementing.
     */
    function _nextCount()
    internal returns ( uint256 nextCount_ ) {
        nextCount_ = Uint256CounterService._nextCount();
    }

}