// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-inline-assembly
import {
    MutableERC165Layout
} from "./MutableERC165Layout.sol";

/**
 * @title MutableERC165Repo Repository library to support ERC165.
 * @author mises mind <misesmind@proton.me>
 */
library MutableERC165Repo {

    using MutableERC165Layout for MutableERC165Layout.Struct;
    using MutableERC165Layout for bytes32;

    using MutableERC165Repo for bytes32;

    // TODO Replace with address of deployed layout library.
    // Defines the default offset applied to all provided storage ranges for use with operating on a storage layout struct.
    bytes32 internal constant STORAGE_SLOT_OFFSET = keccak256(type(MutableERC165Layout).creationCode);

    /**
     * @dev "Binds" a struct to a storage slot.
     * @param storageRange The first slot to use in the range of slots used by the struct.
     * @return layout A struct from a Layout library bound to the provided slot.
     */
    function _isSupported(
        bytes32 storageRange
    ) internal pure returns(MutableERC165Layout.Struct storage layout) {
        storageRange ^= STORAGE_SLOT_OFFSET;
        layout = storageRange._layout();
    }

    /**
     * @dev The exact slot used to store the provided value will be determined by the underlying struct.
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @param interfaceId The ERC165 interface ID to map interface support.
     * @param support Boolean flag to store indicating interface support.
     */
    function _storeInterfaceSupport(
        bytes32 storageRange,
        bytes4 interfaceId,
        bool support
    ) internal {
        storageRange._isSupported()._storeInterfaceSupport(
            interfaceId,
            support
        );
    }

    /**
     * @dev The exact slot used to load the requested value will be determined by the underlying struct.
     * @param storageRange The storage slot to bind to the struct(s) used by this repo.
     * @param interfaceId The ERC165 interface ID to query interface support.
     * @return support The stored boolean indicating interface support.
     */
    function _loadInterfaceSupport(
        bytes32 storageRange,
        bytes4 interfaceId
    ) internal view returns(bool support) {
        support = storageRange._isSupported()._loadInterfaceSupport(
            interfaceId
        );
    }

}