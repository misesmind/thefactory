// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./OwnableStorage.sol";

contract OwnableTarget is OwnableStorage, IOwnable {

    function owner() external view returns(address) {
        return _owner();
    }

    function proposedOwner() external view returns(address) {
        return _proposedOwner();
    }

    function transferOwnership(address proposedOwner_) onlyOwner(msg.sender) external returns(bool) {
        return _transferOwnerShip(proposedOwner_);
    }

    function acceptOwnership() onlyProposedOwner(msg.sender) external returns(bool) {
        return _acceptOwnership();
    }

    function renounceOwnership() onlyOwner(msg.sender) external returns(bool) {
        return _renounceOwnership();
    }

}