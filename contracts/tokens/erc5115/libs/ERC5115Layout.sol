// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/collections/sets/AddressSetLayout.sol";

struct ERC5115Struct {
    // Set of tokens accepted for deposit.
    AddressSet tokensIn;
    // Set of tokens producable for redemption.
    AddressSet tokensOut;
}

library ERC5115Layout {

    function slot(
        ERC5115Struct storage layout_
    ) external pure returns(bytes32 slot_) {
        return _slot(layout_);
    }

    function _slot(
        ERC5115Struct storage layout_
    ) internal pure returns(bytes32 slot_) {
        assembly{slot_ := layout_.slot}
    }

    function layout(
        bytes32 slot_
    ) external pure returns(ERC5115Struct storage layout_) {
        return _layout(slot_);
    }

    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 slot_
    ) internal pure returns(ERC5115Struct storage layout_) {
        assembly{layout_.slot := slot_}
    }

}