// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    Address,
    ImmutableRepo,
    DCDIContractRepo
} from "./DCDIContractRepo.sol";
import {
    IContract
} from "thefactory/context/dcdi/interfaces/IContract.sol";
import "thefactory/context/dcdi/interfaces/IDCDIContract.sol";
import {
    Bytes32,
    Bytecode,
    FactoryService
} from "thefactory/factories/libs/FactoryService.sol";
// import "contracts/daosys/core/context/interfaces/IDCDI.sol";
import "thefactory/introspection/erc165/libs/ERC165Utils.sol";
import "thefactory/utils/primitives/Primitives.sol";

/**
 * @title DCDIService - Library of common DCDI operations
 * @author mises mind <misesmind@proton.me>
 */
library DCDIContractService {

    using Address for address;
    using Bytes4 for bytes4;
    using DCDIContractRepo for address;
    using DCDIContractRepo for bytes;
    using FactoryService for address;
    using ERC165Utils for bytes4[];

    using DCDIContractService for address;
    using DCDIContractService for bytes4[];
    using DCDIContractService for bytes32;
    using DCDIContractService for IContract.Metadata;

    /**
     * @dev Recalculates the address from the provided IDCDI.metadata.
     * @param metadata_ The ICreate2Aware.Metadata from which to to recalculate the address.
     * @return target The address from the provided metadata_.
     */
    function _calcAddress(
        IContract.Metadata memory metadata_
    ) internal pure returns(address target) {
        // Use the Metadata members to calculate the CREATE2 address.
        target = metadata_.origin._create2AddressFrom(
            metadata_.initCodeHash,
            metadata_.salt
        );
    }

    /**
     * @dev Stores the provided IDCDI.metadata using DCDI using the address as the key.
     * @param metadata The IDCDI.metadata to be stored.
     * @return pointer The address under which the the injected data has been stored.
     */
    function _injectMetadata(
        IContract.Metadata memory metadata
    ) internal returns(address pointer) {
        // Calc the adress from the provided IDCDI.metadata.
        address consumer = address(this)._create2AddressFrom(
            metadata.initCodeHash,
            metadata.salt
        );
        // Pass calculated address and metadata for injection.
        pointer = consumer._injectMetadata(metadata);
    }

    /**
     * @dev Stores the provided IDCDI.metadata using DCDI using the address as the key.
     * @param metadata The IDCDI.metadata to be stored.
     * @return pointer The address under which the the injected data has been stored.
     */
    function _injectMetadata(
        address consumer,
        IContract.Metadata memory metadata
    ) internal returns(address pointer) {
        // Confirm the IDCDI.metadata matches the provided consumer.
        // If this is wrong, the universe is broken.
        require(consumer == metadata._calcAddress());
        // Inject the metadata.
        // Uses the related address as the "key".
        pointer = abi.encode(metadata)._injectData(
            consumer,
            consumer._toBytes32()
        );
    }

    /**
     * @dev Stores the provided IDCDI.metadata using DCDI using the address as the key.
     * @param consumer The address of the yet to be instantiated ResolverProxy.
     * @param salt The salt to use when deploying the proxy.
     * @return pointer The address under which the the injected data has been stored.
     */
    function _injectMetadata(
        address consumer,
        bytes32 initCodeHash,
        bytes32 salt
    ) internal returns(address pointer) {
        // Construct the IDCDI.metadata for the new Contract.
        IContract.Metadata memory metadata = IContract.Metadata({
            origin: address(this),
            initCodeHash: initCodeHash,
            salt: salt
        });
        pointer = consumer._injectMetadata(metadata);
    }

    /**
     * @dev Loads the ICreate2Aware.Metadata of the target_.
     * @param origin_ The address that deployed the target_.
     * @param target_ The address of the IDCDI.metadata.
     * @return metadata_ The IDCDI.metadata of the target_.
     */
    function _queryMetadata(
        address origin_,
        address target_
    ) internal view returns(IContract.Metadata memory metadata_) {
        metadata_ = abi.decode(
            origin_._queryInjectedData(
                target_,
                target_._toBytes32()
            ),
            (IContract.Metadata)
        );
    }

    /**
     * @dev Calculates the default key used to inject contract init data via DCDI.
     * @param initCodeHash The hash of the init code of the contract to consume the injected data.
     * @param salt The CREATE2 salt used to deploy the consuming contract.
     */
    function _calcInitDataKey(
        bytes32 initCodeHash,
        bytes32 salt
    ) internal pure returns(bytes32 initDataKey) {
        initDataKey = initCodeHash ^ salt;
        // TODO Figure out why this breaks.
        // initDataKey = keccak256(abi.encode(initCodeHash, salt));
    }

    /**
     * @param metadata_ The IDCDI.metadata of the contract that will consume the initData.
     * @param initData The data to injected so that it may be consumed by the subject of the metadata_.
     */
    function _injectInitData(
        IContract.Metadata memory metadata_,
        bytes memory initData
    ) internal returns(address pointer) {
        pointer = metadata_._calcAddress()._injectInitData(
            initData,
            metadata_.initCodeHash,
            metadata_.salt
        );
    }

    /**
     * @dev Inject data to be consumed by a contract during initialization.
     * @param consumer The address of the contract expected to consume the initData.
     * @param initData The data to be injected for consumption by the consumer.
     * @param initCodeHash The hash of the init code of the contract to consume injected data.
     * @param salt The CREATE2 salt that will be used to deploy the consumer.
     * @return pointer The address under which the the injected data has been stored.
     */
    function _injectInitData(
        address consumer,
        bytes memory initData,
        bytes32 initCodeHash,
        bytes32 salt
    ) internal returns(address pointer) {
        pointer = initData._injectData(
                consumer,
                initCodeHash._calcInitDataKey(salt)
            );
    }

    /**
     * @param consumer The address of the contract expected to consume the initData.
     * @param origin The address that wrote the injected data.
     * @param initCodeHash The hash of the init code of the contract to consume injected data.
     * @param salt The CREATE2 salt that will be used to deploy the consumer.
     * @return initData The data that was injected for consumption by the consumer.
     */
    function _queryInitData(
        address consumer,
        address origin,
        bytes32 initCodeHash,
        bytes32 salt
    ) internal view returns(bytes memory initData) {
        initData = origin._queryInjectedData(
                consumer,
                initCodeHash._calcInitDataKey(salt)
            );
    }

    /**
     * @param metadata_ The IDCDI.metadata of the contract for the initData to load.
     * @return initData_ The data that was injected for consumption by the consumer.
     */
    function _queryInitData(
        IContract.Metadata memory metadata_
    ) internal view returns(bytes memory initData_) {
        initData_ = metadata_._calcAddress()._queryInitData(
            metadata_.origin,
            metadata_.initCodeHash,
            metadata_.salt
        );
    }

    // function _injectDeclarations(
    //     bytes4[] memory interfaces,
    //     bytes4[] memory funcs,
    //     bytes4[] memory dcInterfaces,
    //     bytes4[] memory dcFuncs
    // ) internal {
    //     // interfaces._injectSupportedInterfaces();
    //     // funcs._injectFuncSelects();
    //     // dcInterfaces._injectDCInterfaces();
    //     // dcFuncs._injectDCFuncSelects();
    // }

    // function _injectDeclaration(
    //     bytes4[] memory declarations,
    //     bytes4 declareType
    // ) internal {
    //     abi.encode(declarations)._injectData(
    //         address(this),
    //         declareType
    //     );
    // }

    // function _queryDeclaration(
    //     address declarer,
    //     address subject,
    //     bytes4 declareType
    // ) internal view returns(bytes4[] memory) {
    //     return abi.decode(
    //         declarer._queryInjectedData(
    //             subject,
    //             declareType
    //         ),
    //         (bytes4[])
    //     );

    // }

    // function _injectSupportedInterfaces(
    //     bytes4[] memory interfaces
    // ) internal {
    //     interfaces._injectDeclaration(
    //         IContract.supportedInterfaces.selector
    //     );
    // }

    // function _querySupportedInterfaces(
    //     address subject
    // ) internal view returns(bytes4[] memory) {
    //     return subject._queryDeclaration(
    //         subject,
    //         IContract.supportedInterfaces.selector
    //     );
    // }

    // function _injectFuncSelects(
    //     bytes4[] memory funcs
    // ) internal {
    //     funcs._injectDeclaration(
    //         IContract.functionSelectors.selector
    //     );
    // }

    // function _queryFuncSelects(
    //     address subject
    // ) internal view returns(bytes4[] memory) {
    //     return subject._queryDeclaration(
    //         subject,
    //         IContract.functionSelectors.selector
    //     );
    // }

    // function _injectDCInterfaces(
    //     bytes4[] memory interfaces
    // ) internal {
    //     interfaces._injectDeclaration(
    //         IContract.dcInterfaces.selector
    //     );
    // }

    // function _queryDCInterfaces(
    //     address subject
    // ) internal view returns(bytes4[] memory) {
    //     return subject._queryDeclaration(
    //         subject,
    //         IContract.dcInterfaces.selector
    //     );
    // }

    // function _injectDCFuncSelects(
    //     bytes4[] memory funcs
    // ) internal {
    //     funcs._injectDeclaration(
    //         IContract.dcFuncs.selector
    //     );
    // }

    // function _queryDCFuncSelects(
    //     address subject
    // ) internal view returns(bytes4[] memory) {
    //     return subject._queryDeclaration(
    //         subject,
    //         IContract.dcFuncs.selector
    //     );
    // }

}