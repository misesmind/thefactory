// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Uint256CounterStorage} from "contracts/daosys/core/counters/types/Uint256CounterStorage.sol";
import {IUint256Counter} from "contracts/daosys/core/counters/interfaces/IUint256Counter.sol";

/**
 * @title MutableGreeterTarget - Instantiatable contract for exposing and storing state to support IUint256Counter.
 * @author mises mind <misesmind@proton.me>
 */
contract Uint256CounterTarget is IUint256Counter, Uint256CounterStorage {

    /**
     * @inheritdoc IUint256Counter
     */
    function currentCount()
    public view returns (uint256 currentCount_) {
        currentCount_ = _currentCount();
    }

    /**
     * @inheritdoc IUint256Counter
     */
    function nextCount()
    public returns (uint256 nextCount_) {
        nextCount_ = _nextCount();
    }

}