// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "contracts/daosys/core/counters/types/Uint256CounterStorage.sol";

/**
 * @title MutableGreeterTarget - Instantiatable contract for exposing and storing state to support IUint256Counter.
 * @author mises mind <misesmind@proton.me>
 */
contract Uint256CounterImpl is IUint256Counter, Uint256CounterStorage {

    /* -------------------------------------------------------------------------- */
    /*                            Internal Declarations                           */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Contract constructor registers ERC165 support.
     * @dev All contracts MUST override this function to declare their own supported interfaces.
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract for use via CALL.
     */
   function _supportedInterfaces()
    internal pure virtual
    // override
    returns(bytes4[] memory supportedInterfaces_) {
        supportedInterfaces_ = new bytes4[](1);
        supportedInterfaces_[0] = type(IUint256Counter).interfaceId;
    }

    /**
     * @dev All contracts MUST override this function to declare their own implemented functions.
     * @return functionSelectors_ The function selectors implemented in this contract for use via CALL.
     */
   function _functionSelectors()
    internal pure virtual
    // override
    returns(bytes4[] memory functionSelectors_) {
        functionSelectors_ = new bytes4[](2);
        functionSelectors_[0] = IUint256Counter.currentCount.selector;
        functionSelectors_[1] = IUint256Counter.nextCount.selector;
    }

   function _dcInterfaces()
    internal pure virtual
    // override
    returns(bytes4[] memory supportedInterfaces_) {
        // supportedInterfaces_ = new bytes4[](1);
        // supportedInterfaces_[0] = type(IUint256Counter).interfaceId;
    }

   function _dcFuncs()
    internal pure virtual
    // override
    returns(bytes4[] memory dcFuncs_) {
        // dcFuncs_ = new bytes4[](2);
        // dcFuncs_[0] = IUint256Counter.currentCount.selector;
        // dcFuncs_[1] = IUint256Counter.nextCount.selector;
    }

   function _proxiedInterfaces()
    internal pure virtual
    // override
    returns(bytes4[] memory proxiedInterfaces_) {
        // proxiedInterfaces_ = new bytes4[](1);
        // proxiedInterfaces_[0] = type(IUint256Counter).interfaceId;
    }

   function _proxiedFuncs()
    internal pure virtual
    // override
    returns(bytes4[] memory proxiedFuncs_) {
        // proxiedFuncs_ = new bytes4[](2);
        // proxiedFuncs_[0] = IUint256Counter.currentCount.selector;
        // proxiedFuncs_[1] = IUint256Counter.nextCount.selector;
    }

    /* -------------------------------------------------------------------------- */
    /*                                MUST OVERRIDE                               */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                               Initialization                               */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                                    LOGIC                                   */
    /* -------------------------------------------------------------------------- */

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