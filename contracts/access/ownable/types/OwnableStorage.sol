// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../libs/OwnableLayout.sol";
import "../interfaces/IOwnable.sol";

abstract contract OwnableStorage {

    /* ------------------------------ LIBRARIES ----------------------------- */

    using OwnableLayout for OwnablStruct;

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    // TODO Replace with address of deployed library.
    // Normally handled by usage for storage slot.
    // Included to facilitate automated audits.
    address constant OwnableLayout_ID = address(uint160(uint256(keccak256(type(OwnableLayout).creationCode))));

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */
  
    // Defines the default offset applied to all provided storage ranges for use when operating on a struct instance.
    // Subtract 1 from hashed value to ensure future usage of relevant library address.
    bytes32 constant internal OwnableLayout_STORAGE_RANGE_OFFSET = bytes32(uint256(keccak256(abi.encode(OwnableLayout_ID))) - 1);

    // The default storage range to use with the Repo libraries consumed by this library.
    // Service libraries are expected to coordinate operations in relation to a interface between other Services and Repos.
    bytes32 internal constant OwnableLayout_STORAGE_RANGE = type(IOwnable).interfaceId;
    bytes32 internal constant OwnableLayout_STORAGE_SLOT = OwnableLayout_STORAGE_RANGE ^ OwnableLayout_STORAGE_RANGE_OFFSET;

    modifier onlyOwner(address challenger) {
        _ifNotOwner(challenger);
        _;
    }

    modifier onlyProposedOwner(address challenger) {
        _ifNotProposedOwner(challenger);
        _;
    }

    function _initOwner(address newOwner) internal {
        _ownable().owner = newOwner;
        // emit IOwnable.OwnershipTransfered(
        //     address(0),
        //     newOwner
        // );
    }

    // tag::_ownable()[]
    /**
     * @dev internal hook for the default storage range used by this library.
     * @dev Other services will use their default storage range to ensure consistant storage usage.
     * @return The default storage range used with repos.
     */
    function _ownable()
    internal pure virtual returns(OwnablStruct storage) {
        return OwnableLayout._layout(OwnableLayout_STORAGE_SLOT);
    }
    // end::_ownable()[]

    function _owner() internal view returns(address) {
        return _ownable().owner;
    }

    function _isOwner(address challenger) internal view returns(bool) {
        return challenger == _owner();
    }

    function _ifNotOwner(address challenger) internal view {
        if(!_isOwner(challenger)) {
            revert IOwnable.NotOwner(challenger);
        }
    }

    function _proposedOwner() internal view returns(address) {
        return _ownable().proposedOwner;
    }

    function _isProposedOwner(address challenger) internal view returns(bool) {
        return challenger == _proposedOwner();
    }

    function _ifNotProposedOwner(address challenger) internal view {
        if(!_isProposedOwner(challenger)) {
            revert IOwnable.NotProposed(challenger);
        }
    }

    function _transferOwnerShip(address proposedOwner_) internal returns(bool) {
        _ownable().proposedOwner = proposedOwner_;
        // emit IOwnable.TransferProposed(proposedOwner_);
        return true;
    }

    function _acceptOwnership() internal returns(bool) {
        address prevOwner = _ownable().owner;
        address newOwner = _ownable().proposedOwner;
        _ownable().owner = newOwner;
        _ownable().proposedOwner = address(0);
        // emit IOwnable.OwnershipTransfered(prevOwner, newOwner);
        return true;
    }

    function _renounceOwnership() internal returns(bool) {
        require(_ownable().proposedOwner == address(0));
        address prevOwner = _ownable().owner;
        _ownable().owner = address(0);
        // emit IOwnable.OwnershipTransfered(prevOwner, address(0));
        return true;
    }
    
}