// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./MutableERC165Storage.sol";

/**
 * @title MutableERC165Target Impelemntation to expose inheritable external functions in support of ERC165.
 * @author mises mind <misesmind@proton.me>
 */
contract MutableERC165Target is
IERC165, MutableERC165Storage {

    /* -------------------------------------------------------------------------- */
    /*                            INTERNAL DECLARATIONS                           */
    /* -------------------------------------------------------------------------- */

    /**
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via CALL.
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE IDEMPOTENT
     */
    function _supportedInterfaces()
    internal pure virtual
    override(MutableERC165Storage)
    returns(bytes4[] memory supportedInterfaces_) {
        supportedInterfaces_ = new bytes4[](1);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        supportedInterfaces_[0] = type(IERC165).interfaceId;
    }

    /**
     * @return functionSelectors_ The function selectors implemented in this contract that MAY be used via CALL.
     */
    function _functionSelectors()
    internal pure virtual
    override(MutableERC165Storage)
    returns(bytes4[] memory functionSelectors_) {
        functionSelectors_ = new bytes4[](1);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        functionSelectors_[0] = IERC165.supportsInterface.selector;
    }

    // /**
    //  * @return dcInterfaces_ The ERC165 interface IDs implemented in this contract for use via DELEGATECALL.
    //  */
    // function _dcInterfaces()
    // internal pure virtual
    // returns(bytes4[] memory dcInterfaces_) {
    //     // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
    // }

    // /**
    //  * @return dcFuncs_ The function selectors implemented in this contract that MAY be used via DELEGATECALL.
    //  */
    // function _dcFuncs()
    // internal pure virtual
    // returns(bytes4[] memory dcFuncs_) {
    //     // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
    // }

    // /**
    //  * @return proxiedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via a proxy.
    //  */
    // function _proxiedInterfaces()
    // internal pure virtual
    // returns(bytes4[] memory proxiedInterfaces_) {
    //     // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
    //     proxiedInterfaces_ = _dcInterfaces();
    // }

    // /**
    //  * @return proxiedFuncs_ The function selectors implemented in this contract that MAY be used via a proxy.
    //  */
    // function _proxiedFuncs()
    // internal pure virtual
    // returns(bytes4[] memory proxiedFuncs_) {
    //     // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
    //     proxiedFuncs_ = _dcFuncs();
    // }

    /* -------------------------------------------------------------------------- */
    /*                                MUST OVERRIDE                               */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                               INITIALIZATION                               */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                                    LOGIC                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice query whether contract has registered support for given interface
     * @param interfaceId interface id
     * @return isSupported whether interface is supported
     * @custom:sighash 0x01ffc9a7
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE NON-IDEMPOTENT
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(IERC165) returns (bool isSupported) {
        isSupported = _supportsInterface(interfaceId);
    }

}