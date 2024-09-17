// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

interface ICreate2Aware {

    struct Metadata {
        address origin;
        bytes32 initCodeHash;
        bytes32 salt;
    }

    function SELF()
    external view returns(address self_);

    function ORIGIN()
    external view returns(address origin_);

    function INIT_CODE_HASH()
    external view returns(bytes32 initCodeHash_);

    function SALT()
    external view returns(bytes32 salt_);

    function METADATA()
    external view returns(ICreate2Aware.Metadata memory metadata_);

}