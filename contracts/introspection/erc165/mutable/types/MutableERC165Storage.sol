// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    MutableERC165Layout,
    MutableERC165Repo,
    ERC165Utils,
    IERC165,
    MutableERC165Service
} from "../libs/MutableERC165Service.sol";

/**
 * @title MutableERC165Storage Storage contract making bundled Service libraries inheritable.
 * @author mises mind <misesmind@proton.me>
 */
abstract contract MutableERC165Storage {

    using ERC165Utils for bytes4[];
    using MutableERC165Service for bytes4;
    using MutableERC165Service for bytes4[];

    /* -------------------------------------------------------------------------- */
    /*                            Internal Declarations                           */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                               Initialization                               */
    /* -------------------------------------------------------------------------- */

    function _initERC165() internal {
        _registerInterfaceSupport(_supportedInterfaces());
        _registerInterfaceSupport(_functionSelectors()._calcInterfaceId());
    }

    /* -------------------------------------------------------------------------- */
    /*                                MUST OVERRIDE                               */
    /* -------------------------------------------------------------------------- */

    /**
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via CALL.
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE IDEMPOTENT
     */
    function _supportedInterfaces()
    internal pure virtual
    returns(bytes4[] memory supportedInterfaces_);

    /**
     * @return functionSelectors_ The function selectors implemented in this contract that MAY be used via CALL.
     */
    function _functionSelectors()
    internal pure virtual
    returns(bytes4[] memory functionSelectors_);

    /* -------------------------------------------------------------------------- */
    /*                                    LOGIC                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @param _supportedInterface The ERC165 interface ID of which to register support.
     */
    function _registerInterfaceSupport(
        bytes4 _supportedInterface
    ) internal {
        _supportedInterface._registerInterfaceSupport();
    }

    /**
     * @param supportedInterfaces The array of ERC165 interface ID of which to register support.
     */
    function _registerInterfaceSupport(
        bytes4[] memory supportedInterfaces
    ) internal {
        supportedInterfaces._registerInterfacesSupport();
    }

    /**
     * @param functionSelectors The array of function selectors of which to calculate the ERC165 interface ID of which to register support.
     */
    function _registerFunctionsAsInterfaceSupport(
        bytes4[] memory functionSelectors
    ) internal {
        functionSelectors._registerFunctionsAsInterfaceSupport();
    }

    /**
     * @param supportedInterface The ERC165 interface ID of which to deregister support.
     */
    function _deregisterInterfaceSupport(
        bytes4 supportedInterface
    ) internal {
        supportedInterface._deregisterInterfaceSupport();
    }
  
    /**
     * @param supportedInterfaces The array of ERC165 interface ID of which to register support.
     */
    function _deregisterInterfaceSupport(
        bytes4[] memory supportedInterfaces
    ) internal {
        supportedInterfaces._deregisterInterfacesSupport();
    }

    /**
     * @param functionSelectors The array of function selectors of which to calculate the ERC165 interface ID of which to deregister support.
     */
    function _deregisterFunctionsAsInterfacesSupport(
        bytes4[] memory functionSelectors
    ) internal {
        functionSelectors._deregisterFunctionsAsInterfacesSupport();
    }

    /**
     * @notice query whether contract has registered support for given interface
     * @param interfaceId interface id
     * @return isSupported whether interface is supported
     * @custom:sighash 0x01ffc9a7
     */
    function _supportsInterface(
        bytes4 interfaceId
    ) internal view virtual returns (bool isSupported) {
        isSupported = interfaceId._queryInterfaceSupport();
    }

}