// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct ERC4626Struct {
    address asset;
    uint8 assetDecimals;
}

library ERC4626Layout {

    using ERC4626Layout for ERC4626Struct;

    function slot(
        ERC4626Struct storage layout_
    ) external pure returns(bytes32 slot_) {
        return _slot(layout_);
    }

    function _slot(
        ERC4626Struct storage table
    ) internal pure returns(bytes32 slot_) {
        assembly{slot_ := table.slot}
    }

    function layout(
        bytes32 slot_
    ) external pure returns(ERC4626Struct storage layout_) {
        return _layout(slot_);
    }

    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 slot_
    ) internal pure returns(ERC4626Struct storage layout_) {
        assembly{layout_.slot := slot_}
    }

}