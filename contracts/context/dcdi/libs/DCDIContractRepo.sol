// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    Address,
    ImmutableRepo
} from "thefactory/storage/immutable/ImmutableRepo.sol";

/**
 * @title DCDIRepo - A Repository Library executing DCDI storage operations.
 * @author mises mind <misesmind@proton.me>
 * @dev Provides the main integration for injecting data.
 */
library DCDIContractRepo {

    // using ContractService for IDCDI.metadata;
    using ImmutableRepo for address;
    using ImmutableRepo for bytes;

    using DCDIContractRepo for address;
    using DCDIContractRepo for bytes;
    using DCDIContractRepo for bytes32;

    /* -------------------------------------------------------------------------- */
    /*                          Arbitrary DCDI Injection                          */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Checks for the presence of bytecode that may store data.
     * @param writer The address that wrote the injected data.
     * @param consumer The address of the intended consumer of the injected data.
     * @param key The value used as the CREATE2 salt for storing the injected data.
     * @return isInjected Boolean indicating if bytecode is present.
     */
    function _isInjected(
        address writer,
        address consumer,
        bytes32 key
    ) internal view returns(bool isInjected) {
        isInjected = writer._isPresentFrom(keccak256(abi.encode(consumer, key)));
    }

    /**
     * @param data The encoded data to be injected for any domain specific process.
     * @param consumer The address of the intended consumer of the injected data.
     * @param key The value used as the CREATE2 salt for storing the injected data.
     * @return pointer The address under which the the injected data has been stored.
     */
    function _injectData(
        bytes memory data,
        address consumer,
        bytes32 key
    ) internal returns(address pointer) {
        pointer = data._mapBlob(keccak256(abi.encode(consumer, key)));
    }

    /**
     * @param writer The address that wrote the injected data.
     * @param consumer The address of the intended consumer of the injected data.
     * @param key The value used as the CREATE2 salt for storing the injected data.
     */
    function _queryInjectedData(
        address writer,
        address consumer,
        bytes32 key
    ) internal view returns(bytes memory initData) {
        // Double check that data was injected to prevent potential reversion if not present or contains no data.
        initData = _isInjected(writer, consumer, key)
            // If present, load and returns injected datas.
            ? writer._queryBlobFromOf(keccak256(abi.encode(consumer, key)))
            //If NOT present, returns empty bytes.
            : new bytes(0);
        
    }

}