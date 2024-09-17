// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    Bytes32,
    Bytecode
} from "thefactory/utils/primitives/Primitives.sol";

/**
 * @title FactoryService - Library for deploying contracts and common related operations.
 * @author mises mind <misesmind@proton.me>
 */
library FactoryService {

    using Bytecode for address;
    using Bytecode for bytes;

    /**
     * @param initCode The creation code of which to calculate the hash used for CREATE2 deployments.
     * @return initCodeHash The hashed value of the provided creation code that would be used for CREATE2 deployment.
     */
    function _calcInitCodeHash(
        bytes memory initCode
    ) internal pure returns(bytes32 initCodeHash) {
        initCodeHash = initCode._calcInitCodeHash();
    }

    /**
     * @dev Intended to be used in cases where you only have the initCode for deployment.
     *  Typically you would just use "new" to deploy a contract.
     *  Primarily, this is used for Metamorphic deployments.
     * @param initCode The provided initCode that will be deployed using CREATE.
     * @return deployment The address of the newly deployed contract.
     */
    function _create(
        bytes memory initCode
    ) internal returns(address deployment) {
        deployment = initCode._create();
    }

    /**
     * @dev Intended to be used in cases where you only have the initCode for deployment.
     *  Typically you would just use "new" to deploy a contract.
     *  Primarily, this is used for Metamorphic deployments.
     * @param initCode The provided initCode that will be deployed using CREATE2.
     * @param salt The value to be used with CREATE2 to get a deterministic address.
     * @return deployment The address of the newly deployed contract.
     */
    function _create2(
        bytes memory initCode,
        bytes32 salt
    ) internal returns(address deployment) {
        deployment = initCode._create2(salt);
    }

    /**
     * @dev Deploys the provided init code using CREATE2 after attaching constructor arguments.
     * @dev Intended to be used in cases where you only have the initCode for deployment.
     *  Typically you would just use "new" to deploy a contract.
     *  Primarily, this is used for Metamorphic deployments.
     * @param initCode The provided initCode that will be deployed using CREATE2.
     * @param salt The value to be used with CREATE2 to get a deterministic address.
     * @param initArgs The ABI encoded constructor arguments to be attached to the provided init code.
     */
    function _create2WithArgs(
        bytes memory initCode,
        bytes32 salt,
        bytes memory initArgs
    ) internal returns(address deployment) {
        deployment = initCode._create2WithArgs(
            salt,
            initArgs
        );
    }

    /**
     * @notice calculate the _deployMetamorphicContract deployment address for a given salt
     * @param initCodeHash hash of contract initialization code
     * @param salt input for deterministic address calculation
     * @return deployment address
     */
    function _create2AddressFrom(
        address deployer,
        bytes32 initCodeHash,
        bytes32 salt
    ) internal pure returns (address payable) {
        return
            payable(
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    hex'ff',
                                    deployer,
                                    salt,
                                    initCodeHash
                                )
                            )
                        )
                    )
                )
            );
    }

}