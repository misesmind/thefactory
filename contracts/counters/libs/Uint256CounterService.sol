// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./Uint256CounterRepo.sol";
import "../interfaces/IUint256Counter.sol";

/**
 * @title Uint256CounterService - Library for operations in support of IUint256Counter.
 * @author mises mind <misesmind@proton.me>
 */
library Uint256CounterService {

    using Uint256CounterRepo for bytes32;

    // The default storage range to use with the Repo libraries consumed by this library.
    // Service libraries are expected to coordinate operations in relation to a interface between other Services and Repos.
    bytes32 internal constant STORAGE_RANGE = type(IUint256Counter).interfaceId;

    /**
     * @dev internal hook for the default storage range used by this library.
     * @dev Other services will use their default storage range to ensure consistant storage usage.
     * @return storageRange_ The default storage range used with repos.
     */
    function _storageRange()
    internal pure returns(bytes32 storageRange_) {
        storageRange_ = STORAGE_RANGE;
    }

    function _initCount(
        uint256 countInit
    ) internal {
        _storageRange()._initCount(countInit);
    }

    /**
     * @dev internal hook for the default storage range used by this library.
     * @dev Other services will use their default storage range to ensure consistant storage usage.
     * @return storageRange_ The default storage range used with repos.
     */
    function storageRange()
    external pure returns(bytes32 storageRange_) {
        storageRange_ = _storageRange();
    }

    /**
     * @return currentCount_ The current count value.
     */
    function _currentCount()
    internal view  returns (uint256 currentCount_) {
        currentCount_ = _storageRange()._currentCount();
    }

    /**
     * @return currentCount_ The current count value.
     */
    function currentCount()
    external view returns (uint256 currentCount_) {
        currentCount_ = _currentCount();
    }

    /**
     * @notice Increments the count
     * @return nextCount_ The count value after incrementing.
     */
    function _nextCount()
    internal returns (uint256 nextCount_) {
        nextCount_ = _storageRange()._nextCount();
    }

    /**
     * @notice Increments the count
     * @return nextCount_ The count value after incrementing.
     */
    function nextCount()
    external returns ( uint256 nextCount_ ) {
        nextCount_ = _nextCount();
    }

}