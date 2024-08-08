// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc6909/types/ERC6909Target.sol";
import "thefactory/tokens/erc6909/interfaces/IERC6909Metadata.sol";

struct ERC6909MetadataLayout {
    string name;
    string symbol;
    mapping(uint256 tokenId => uint8 decimals) decimalsFor;
}

library ERC6909MetadataRepo {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC6909MetadataLayout storage)
     */
    function slot(
        ERC6909MetadataLayout storage table
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
        ERC6909MetadataLayout storage table
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
    ) external pure returns(ERC6909MetadataLayout storage layout_) {
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
    ) internal pure returns(ERC6909MetadataLayout storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::_layout[]

}

abstract contract ERC6909MetadataStorage {

    using ERC6909MetadataRepo for ERC6909MetadataLayout;

    address constant ERC6909MetadataRepo_ID =
        address(uint160(uint256(keccak256(type(ERC6909MetadataRepo).creationCode))));
    bytes32 constant internal ERC6909MetadataRepo_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(ERC6909MetadataRepo_ID))) - 1);
    bytes32 internal constant ERC6909MetadataRepo_STORAGE_RANGE =
        type(IERC6909Metadata).interfaceId;
    bytes32 internal constant ERC6909MetadataRepo_STORAGE_SLOT =
        ERC6909MetadataRepo_STORAGE_RANGE ^ ERC6909MetadataRepo_STORAGE_RANGE_OFFSET;

    function _erc6909Metadata()
    internal pure virtual returns(ERC6909MetadataLayout storage) {
        return ERC6909MetadataRepo._layout(ERC6909MetadataRepo_STORAGE_SLOT);
    }

}

contract ERC6909MetadataTarget is ERC6909MetadataStorage, ERC6909Target, IERC6909Metadata {

    function name() public view returns (string memory) {
        return _erc6909Metadata().name;
    }

    function symbol() public view returns (string memory) {
        return _erc6909Metadata().symbol;
    }
    function decimals(uint256 id) public view returns (uint8) {
        return _erc6909Metadata().decimalsFor[id];
    }

}