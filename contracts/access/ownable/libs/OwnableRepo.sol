// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

struct OwnableLayout {
    address owner;
    address proposedOwner;
}

library OwnableRepo {

    // tag::slot(OwnableLayout storage)[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     */
    function slot(
        OwnableLayout storage table
    ) external pure returns(bytes32 slot_) {
        return _slot(table);
    }
    // end::slot(OwnableLayout storage)[]

    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     */
    function _slot(
        OwnableLayout storage table
    ) internal pure returns(bytes32 slot_) {
        assembly{slot_ := table.slot}
    }

    // tag::layout(bytes32)[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function layout(
        bytes32 slot_
    ) external pure returns(OwnableLayout storage layout_) {
        return _layout(slot_);
    }
    // end::layout(bytes32)[]

    /**
     * @dev "Binds" a struct to a storage slot.
     * @param storageRange The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 storageRange
    ) internal pure returns(OwnableLayout storage layout_) {
        assembly{layout_.slot := storageRange}
    }

}