// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import {DCDIRepo} from "thefactory/dcdi/libs/DCDIRepo.sol";
import {FactoryService} from "thefactory/factories/libs/FactoryService.sol";
import {ICreate2Aware} from "thefactory/aware/create2/interfaces/ICreate2Aware.sol";
// import {Address} from "contracts/libs/primitives/Address.sol";
import "thefactory/utils/primitives/Primitives.sol";

library Create2AwareService {

    using Address for address;
    using DCDIRepo for address;
    using FactoryService for address;

    function _calcAddress(
        ICreate2Aware.Metadata memory metadata_
    ) internal pure returns(address target) {
        target = metadata_.origin._create2AddressFrom(
            metadata_.initCodeHash,
            metadata_.salt
        );
    }

    function _injectMetadata(
        ICreate2Aware.Metadata memory metadata_
    ) internal returns(address pointer) {
        address predictedAddr = address(this)._create2AddressFrom(
            metadata_.initCodeHash,
            metadata_.salt
        );
        pointer = DCDIRepo._injectData(
            abi.encode(metadata_),
            predictedAddr,
            // address(this)._toBytes32() ^ predictedAddr._toBytes32()
            // initCodeHash ^ salt
            predictedAddr._toBytes32()
        );
    }

    function _queryMetadata(
        address origin_,
        address target_
    ) internal view returns(ICreate2Aware.Metadata memory metadata_) {
        metadata_ = abi.decode(
            DCDIRepo._queryInjectedData(
                origin_,
                target_,
                target_._toBytes32()
            ),
            (ICreate2Aware.Metadata)
        );
    }

}