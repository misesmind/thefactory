// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc6909/types/ERC6909MetadataTarget.sol";
import "thefactory/tokens/erc6909/interfaces/IERC6909MetadataEnumerated.sol";

struct ERC6909MetadataEnumeratedLayout {
    mapping(uint256 tokenId => string name) nameFor;
    mapping(uint256 tokenId => string symbol) symbolFor;
}

library ERC6909MetadataEnumeratedRepo {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC6909MetadataEnumeratedLayout storage)
     */
    function slot(
        ERC6909MetadataEnumeratedLayout storage table
    ) external pure returns(bytes32 slot_) {
        return _slot(table);
    }
    // end::slot[]

    // tag::_slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     */
    function _slot(
        ERC6909MetadataEnumeratedLayout storage table
    ) internal pure returns(bytes32 slot_) {
        assembly{slot_ := table.slot}
    }
    // end::_slot[]

    // tag::layout[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     * @custom:sig layout(bytes32)
     */
    function layout(
        bytes32 slot_
    ) external pure returns(ERC6909MetadataEnumeratedLayout storage layout_) {
        return _layout(slot_);
    }
    // end::layout[]

    // tag::_layout[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 slot_
    ) internal pure returns(ERC6909MetadataEnumeratedLayout storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::_layout[]

}

abstract contract ERC6909MetadataEnumeratedStorage {

    using ERC6909MetadataEnumeratedRepo for ERC6909MetadataEnumeratedLayout;

    address constant ERC6909MetadataEnumeratedRepo_ID =
        address(uint160(uint256(keccak256(type(ERC6909MetadataEnumeratedRepo).creationCode))));
    bytes32 constant internal ERC6909MetadataEnumeratedRepo_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(ERC6909MetadataEnumeratedRepo_ID))) - 1);
    bytes32 internal constant ERC6909MetadataEnumeratedRepo_STORAGE_RANGE =
        type(IERC6909MetadataEnumerated).interfaceId;
    bytes32 internal constant ERC6909MetadataEnumeratedRepo_STORAGE_SLOT =
        ERC6909MetadataEnumeratedRepo_STORAGE_RANGE ^ ERC6909MetadataEnumeratedRepo_STORAGE_RANGE_OFFSET;

    function _erc6909MetadataEnumerated()
    internal pure virtual returns(ERC6909MetadataEnumeratedLayout storage) {
        return ERC6909MetadataEnumeratedRepo._layout(ERC6909MetadataEnumeratedRepo_STORAGE_SLOT);
    }

}

contract ERC6909MetadataEnumeratedTarget is ERC6909MetadataEnumeratedStorage, ERC6909MetadataTarget, IERC6909MetadataEnumerated {

    function nameOfId(uint256 id) public view returns (string memory) {
        return _erc6909MetadataEnumerated().nameFor[id];
    }

    function symbolOfId(uint256 id) public view returns (string memory symbol_) {
        return _erc6909MetadataEnumerated().symbolFor[id];
    }

}