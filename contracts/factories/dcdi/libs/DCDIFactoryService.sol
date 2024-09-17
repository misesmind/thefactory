// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {FactoryService} from "thefactory/factories/libs/FactoryService.sol";
import {
    IContract,
    // ContractService,
    DCDIContractService
} from "thefactory/context/dcdi/libs/DCDIContractService.sol";
// import "contracts/daosys/core/context/interfaces/IDCDI.sol";

/**
 * @title DCDIFactoryService - Service library for completing deployments with DCDI injection.
 * @author mises mind <misesmind@proton.me>
 */
library DCDIFactoryService {

    using DCDIContractService for IContract.Metadata;
    using DCDIContractService for bytes;
    using DCDIContractService for IContract.Metadata;
    using FactoryService for bytes;

    using DCDIFactoryService for bytes;
    using DCDIFactoryService for bytes32;

    function _calcSalt(
        bytes32 initCodeHash,
        bytes32 initDataHash
    ) internal pure returns(bytes32) {
        return keccak256(abi.encode(initCodeHash, initDataHash));
    }

    function _calcSalt(
        bytes memory initCode,
        bytes memory initData
    ) internal pure returns(bytes32) {
        return keccak256(initCode)._calcSalt(keccak256(initData));
    }

    /**
     * @dev Will use hash of initCode as CREATE2 salt.
     * @param initCode The creation byteccode to be deployed.
     * @param initData Blob to store using SSTORE2 as initiialization data for initCode.
     */
    function _deploySelfIDInjection(
        bytes memory initCode,
        bytes memory initData
    ) internal returns(address deployment) {
        deployment = initCode._create2WithInjection(
            // We replicate the constructor argument process to simulate the EVM normal behavior.
            // This also allows for duplicate bytecode deployments with differing initialization data.
            // keccak256(bytes.concat(initCode, initData)),
            initCode._calcSalt(initData),
            initData
        );
    }

    /**
     * @param initCode The creation byteccode to be deployed.
     * @param salt The CREATE2 salt to use for deployment of initCode.
     * @param initData Blob to store using SSTORE2 as initiialization data for initCode.
     */
    function _create2WithInjection(
        bytes memory initCode,
        bytes32 salt,
        bytes memory initData
    ) internal returns(address deployment) {
        // Calc the init code hash.
        bytes32 initCodeHash = keccak256(initCode);
        // Declare new deployment metadata.
        IContract.Metadata memory metadata = IContract.Metadata({
            origin: address(this),
            initCodeHash: initCodeHash,
            salt: salt
        });
        // Inject the metadata.
        // TODO Optimize by consolidating the two underlying CREATE2 address calculation.
        metadata._injectMetadata();
        // Check if init data was provided.
        if(initData.length > 0) {
            // Inject init data if present.
            metadata._injectInitData(initData);
        }
        // Deploy bytecode and return deployed address.
        deployment = initCode._create2(salt);
    }

}