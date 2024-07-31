// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../interfaces/IGreeter.sol";

struct GreeterStruct {
    string message;
}

/**
 * @title GreeterLayout - Storage layout for string storage operations.
 * @author mises mind <misesmind@proton.me>
 */
library GreeterLayout {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param layout_ Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC20Struct storage)
     * @custom:selector 0x5bbea693
     */
    function slot(
        GreeterStruct storage layout_
    ) public pure returns(bytes32 slot_) {
        assembly{slot_ := layout_.slot}
    }
    // end::slot[]

    // tag::layout[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     * @custom:sig layout(bytes32)
     * @custom:selector 0x81366cef
     */
    function layout(
        bytes32 slot_
    ) public pure returns(GreeterStruct storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::layout[]

}

abstract contract GreeterStorage {

    using GreeterLayout for GreeterStruct;

    address constant GREETER_LAYOUT_ID =
        // address(GreeterLayout);
        address(uint160(uint256(keccak256(type(GreeterLayout).creationCode))));
    bytes32 internal constant GREETER_LAYOUT_STORAGE_RANGE = type(IGreeter).interfaceId;
    bytes32 internal constant GREETER_LAYOUT_STORAGE_SLOT =
        bytes32(uint256(keccak256(abi.encode(GREETER_LAYOUT_STORAGE_RANGE, GREETER_LAYOUT_ID))) - 1);
    
    function _greeter()
    internal pure virtual returns(GreeterStruct storage) {
        return GreeterLayout.layout(GREETER_LAYOUT_STORAGE_SLOT);
    }

}

contract GreeterTarget is GreeterStorage, IGreeter {

    function setMessage(
        string memory newMessage
    ) public virtual returns(bool success) {
        _greeter().message = newMessage;
        return true;
    }

    function getMessage()
    public view virtual returns(string memory) {
        return _greeter().message;
    }

}