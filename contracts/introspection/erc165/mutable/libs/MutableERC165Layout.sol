// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title MutableERC165Layout Storage layout library to support ERC165.
 * @author mises mind <misesmind@proton.me>
 */
library MutableERC165Layout {

    error InvalidInterface(bytes4 interfaceId);
    
    // The maximum possible value is never a valid interface ID.
    bytes4 constant internal INVALID_INTERFACE = 0xffffffff;

    struct Struct {
        mapping(bytes4 interfaceId => bool isSupported) support;
    }

    /**
     * @dev "Binds" a struct to a storage slot.
     * @param storageRange The first slot to use in the range of slots used by the struct.
     * @return layout A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 storageRange
    ) internal pure returns(MutableERC165Layout.Struct storage layout) {
        // storageRange ^= STORAGE_SLOT_OFFSET;
        assembly{layout.slot := storageRange}
    }

    /**
     * @param layout The struct defining the storage layout upon which to operate.
     * @param interfaceId The ERC165 interface ID to map interface support.
     * @param support Boolean flag to store indicating interface support.
     */
    function _storeInterfaceSupport(
        MutableERC165Layout.Struct storage layout,
        bytes4 interfaceId,
        bool support
    ) internal {
        // require(interfaceId != INVALID_INTERFACE, "invalid ID");
        if(interfaceId == INVALID_INTERFACE) {
            revert InvalidInterface(interfaceId);
        }
        layout.support[interfaceId] = support;
    }

    /**
     * @param layout The struct defining the storage layout upon which to operate.
     * @param interfaceId The ERC165 interface ID to query interface support.
     * @return support The stored boolean indicating interface support.
     */
    function _loadInterfaceSupport(
        MutableERC165Layout.Struct storage layout,
        bytes4 interfaceId
    ) internal view returns(bool support) {
        support = layout.support[interfaceId];
    }

}