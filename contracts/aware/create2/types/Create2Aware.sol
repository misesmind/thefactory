// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;


import "thefactory/aware/create2/interfaces/ICreate2Aware.sol";
import "thefactory/aware/create2/libs/Create2AwareService.sol";

contract Create2Aware is ICreate2Aware {

    // using Address for address;
    using Create2AwareService for address;

    // solhint-disable-next-line var-name-mixedcase
    address public immutable SELF;

    // solhint-disable-next-line var-name-mixedcase
    address public immutable ORIGIN;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 public immutable INIT_CODE_HASH;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 public immutable SALT;

    constructor() {
        SELF = address(this);
        ORIGIN = address(msg.sender);
        ICreate2Aware.Metadata memory metadata_ = address(msg.sender)._queryMetadata(address(this));
        INIT_CODE_HASH = metadata_.initCodeHash;
        SALT = metadata_.salt;
    }

    function METADATA()
    public view returns(ICreate2Aware.Metadata memory metadata_) {
        metadata_ = ICreate2Aware.Metadata({
            origin: ORIGIN,
            initCodeHash: INIT_CODE_HASH,
            salt: SALT
        });
    }

}