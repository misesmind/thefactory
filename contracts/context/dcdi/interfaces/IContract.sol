// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IERC165} from "thefactory/introspection/erc165/interfaces/IERC165.sol";

/**
 * @title IContract Interface for interacting with all Context compatible contracts.
 * @author mises mind <misesmind@proton.me>
 * @notice All Context compatible contracts are deployed using CREATE2.
 * @custom:interfaceid 0xfbe5b62a
 */
interface IContract is IERC165 {

    /**
     * @dev Contains all components used to calculate a CREATE2 address
     * @param origin The address of the contract that deployed the contract providing this struct.
     * @param initCodeHash The keccak256 hash of the creation code.
     * @param salt The salt used to deploy the contract providing this struct.
     */
    struct Metadata {
        // The address of the contract that deployed the contract providing this struct.
        address origin;
        // The keccak256 hash of the creation code.
        bytes32 initCodeHash;
        // The salt used to deploy the contract providing this struct.
        bytes32 salt;
    }

    /**
     * @return origin_ The address that deployed the contract exposing this interface.
     * @custom:context-exec SAFE IDEMPOTENT
     */
    function origin()
    external view returns(address origin_);

    /**
     * @notice MUST be consistent to execution bytecode regardless of execution context.
     * @return self_ own address.
     * @custom:context-exec SAFE IDEMPOTENT
     */
    function self()
    external view returns(address self_);

    /**
     * @return initCodeHash_ The hash of the creation code used to deploy the exposing contract.
     * @custom:context-exec SAFE IDEMPOTENT
     */
    function initCodeHash()
    external view returns(bytes32 initCodeHash_);

    /**
     * @return salt_ The salt used to deploy the exposing contract with CREATE2.
     */
    function salt()
    external view returns(bytes32 salt_);

    /**
     * @return metadata_ The full Metadata struct containing all CREATE2 variables used to deploy the exposing contract.
     */
    function metadata()
    external view returns(IContract.Metadata memory metadata_);

    // /**
    //  * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract for use via CALL.
    //  */
    // function supportedInterfaces()
    // external view returns(bytes4[] memory supportedInterfaces_);

    // /**
    //  * @return functionSelectors_ The function selectors implemented in this contract for use via CALL.
    //  */
    // function functionSelectors()
    // external view returns(bytes4[] memory functionSelectors_);

    // /**
    //  * @return dcInterfaces_ The ERC165 interface IDs implemented in this contract for use via DELEGATECALL.
    //  */
    // function dcInterfaces()
    // external view returns(bytes4[] memory dcInterfaces_);

    // /**
    //  * @return dcFuncs_ The function selectors implemented in this contract for use via DELEGATECALL.
    //  */
    // function dcFuncs()
    // external view returns(bytes4[] memory dcFuncs_);

}