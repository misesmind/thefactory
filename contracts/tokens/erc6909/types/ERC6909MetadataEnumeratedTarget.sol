// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc6909/types/ERC6909MetadataTarget.sol";
import {IERC6909MetadataEnumerated} from "thefactory/tokens/erc6909/interfaces/IERC6909MetadataEnumerated.sol";

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

contract ERC6909MetadataEnumeratedTarget
is
ERC6909MetadataEnumeratedStorage,
ERC6909MetadataTarget
// IERC6909MetadataEnumerated
{

    /**
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via CALL.
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE IDEMPOTENT
     */
    function _supportedInterfaces()
    internal pure virtual
    override(ERC6909MetadataTarget)
    returns(bytes4[] memory supportedInterfaces_) {
        supportedInterfaces_ = new bytes4[](4);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        supportedInterfaces_[0] = type(IERC165).interfaceId;
        supportedInterfaces_[1] = type(IERC6909).interfaceId;
        supportedInterfaces_[2] = type(IERC6909Metadata).interfaceId;
        supportedInterfaces_[3] = type(IERC6909MetadataEnumerated).interfaceId;
    }

    /**
     * @return functionSelectors_ The function selectors implemented in this contract that MAY be used via CALL.
     */
    function _functionSelectors()
    internal pure virtual
    override(ERC6909MetadataTarget)
    returns(bytes4[] memory functionSelectors_) {
        functionSelectors_ = new bytes4[](9);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        functionSelectors_[0] = IERC165.supportsInterface.selector;
        functionSelectors_[1] = IERC6909.totalSupply.selector;
        functionSelectors_[2] = IERC6909.balanceOf.selector;
        functionSelectors_[3] = IERC6909.allowance.selector;
        functionSelectors_[4] = IERC6909.isOperator.selector;
        functionSelectors_[5] = IERC6909.transfer.selector;
        functionSelectors_[6] = IERC6909.transferFrom.selector;
        functionSelectors_[7] = IERC6909.approve.selector;
        functionSelectors_[8] = IERC6909.setOperator.selector;
        functionSelectors_[9] = IERC6909Metadata.name.selector;
        functionSelectors_[10] = IERC6909Metadata.symbol.selector;
        functionSelectors_[11] = IERC6909Metadata.decimals.selector;
        functionSelectors_[10] = IERC6909MetadataEnumerated.nameOfId.selector;
        functionSelectors_[11] = IERC6909MetadataEnumerated.symbolOfId.selector;
    }

    function nameOfId(uint256 id) public view virtual returns (string memory) {
        return _erc6909MetadataEnumerated().nameFor[id];
    }

    function symbolOfId(uint256 id) public view virtual returns (string memory symbol_) {
        return _erc6909MetadataEnumerated().symbolFor[id];
    }

}