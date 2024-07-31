// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "../../GreeterTarget.sol";
import "thefactory/access/ownable/Ownable.sol";

contract OwnableGreeter is GreeterTarget, OwnableTarget {

    constructor(address owner_) {
        _initOwner(owner_);
    }

    function setMessage(
        string memory newMessage
    ) public virtual override onlyOwner(msg.sender) returns(bool success) {
        super.setMessage(newMessage);
        return true;
    }

    // function getMessage()
    // public view returns(string memory) {
    //     return super.getMessage();
    // }

}