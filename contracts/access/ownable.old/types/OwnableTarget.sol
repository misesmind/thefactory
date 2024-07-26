// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IOwnable.sol";

contract OwnableTarget is IOwnable {

    struct OwnablStruct {
        address owner;
        address proposedOwner;
    }

    OwnablStruct ownable;

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
        emit IOwnable.OwnershipTransfered(
            address(0),
            newOwner
        );
    }

    function _ownable()
    internal view virtual returns(OwnablStruct storage layout_) {
        return ownable;
    }

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

    function owner() external view returns(address) {
        return _owner();
    }

    function proposedOwner() external view returns(address) {
        return _proposedOwner();
    }

    function transferOwnership(address proposedOwner_) onlyOwner(msg.sender) external returns(bool) {
        _ownable().proposedOwner = proposedOwner_;
        emit IOwnable.TransferProposed(proposedOwner_);
        return true;
    }

    function acceptOwnership() onlyProposedOwner(msg.sender) external returns(bool) {
        address prevOwner = _ownable().owner;
        address newOwner = _ownable().proposedOwner;
        _ownable().owner = newOwner;
        _ownable().proposedOwner = address(0);
        emit IOwnable.OwnershipTransfered(prevOwner, newOwner);
        return true;
    }

    function renounceOwnership() onlyOwner(msg.sender) external returns(bool) {
        require(_ownable().proposedOwner == address(0));
        address prevOwner = _ownable().owner;
        _ownable().owner = address(0);
        emit IOwnable.OwnershipTransfered(prevOwner, address(0));
        return true;
    }

}