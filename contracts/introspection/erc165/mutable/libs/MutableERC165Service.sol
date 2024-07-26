// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable state-visibility
import {
    MutableERC165Layout,
    MutableERC165Repo
} from "./MutableERC165Repo.sol";
import {ERC165Utils} from "../../libs/ERC165Utils.sol";
import {IERC165} from "../../interfaces/IERC165.sol";

/**
 * @title MutableERC165Service - Service library to support ERC165.
 * @author mises mind <misesmind@proton.me>
 */
library MutableERC165Service {

    using ERC165Utils for bytes4[];
    using MutableERC165Repo for bytes32;

    using MutableERC165Service for bytes4;

    /**
     * @dev The default storage range to use with the Repo libraries consumed by this library.
     * @dev Service libraries are expected to coordinate operations in relation to a interface between other Services and Repos.
     * @dev Preferably, Service library usage is coordinated in a Storage contract.
     */
    bytes32 constant STORAGE_RANGE = type(IERC165).interfaceId;

    /**
     * @dev internal hook for the default storage range used by this library.
     * @dev Other services will use their default storage range to ensure consistant storage usage.
     * @return storageRange_ The default storage range used with repos.
     */
    function _storageRange()
    internal pure returns(bytes32 storageRange_) {
        storageRange_ = STORAGE_RANGE;
    }

    /**
     * @param supportedInterface The ERC165 interface ID of which to register support.
     */
    function _registerInterfaceSupport(
        bytes4 supportedInterface
    ) internal {
        _storageRange()._storeInterfaceSupport(
            supportedInterface,
            true
        );
    }

    /**
     * @param supportedInterface The ERC165 interface ID of which to deregister support.
     */
    function _deregisterInterfaceSupport(
        bytes4 supportedInterface
    ) internal {
        _storageRange()._storeInterfaceSupport(
            supportedInterface,
            false
        );
    }

    /**
     * @param supportedInterfaces The array of ERC165 interface ID of which to register support.
     */
    function _registerInterfacesSupport(
        bytes4[] memory supportedInterfaces
    ) internal {
        for(uint256 cursor = 0; cursor < supportedInterfaces.length; cursor++) {
            supportedInterfaces[cursor]._registerInterfaceSupport();
        }
    }

    /**
     * @param supportedInterfaces The array of ERC165 interface ID of which to deregister support.
     */
    function _deregisterInterfacesSupport(
        bytes4[] memory supportedInterfaces
    ) internal {
        for(uint256 cursor = 0; cursor < supportedInterfaces.length; cursor++)  {
            supportedInterfaces[cursor]._deregisterInterfaceSupport();
        }
    }

    /**
     * @param functionSelectors The array of function selectors of which to calculate the ERC165 interface ID of which to register support.
     */
    function _registerFunctionsAsInterfaceSupport(
        bytes4[] memory functionSelectors
    ) internal {
        functionSelectors._calcInterfaceId()._registerInterfaceSupport();
    }

    /**
     * @param functionSelectors The array of function selectors of which to calculate the ERC165 interface ID of which to deregister support.
     */
    function _deregisterFunctionsAsInterfacesSupport(
        bytes4[] memory functionSelectors
    ) internal {
        functionSelectors._calcInterfaceId()._deregisterInterfaceSupport();
    }

    /**
     * @param interfaceId The ERC165 of which to query support.
     * @return isSupported Boolean indicating whether a contract supports the provided interfaceId.
     */
    function _queryInterfaceSupport(
        bytes4 interfaceId
    ) internal view returns (bool isSupported) {
        isSupported = _storageRange()._loadInterfaceSupport(interfaceId);
    }

}