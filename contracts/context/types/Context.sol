// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/utils/primitives/Primitives.sol";
import "thefactory/factories/libs/FactoryService.sol";
import "thefactory/aware/create2/libs/Create2AwareService.sol";
import "thefactory/factories/dcdi/libs/DCDIFactoryService.sol";
// import "lib/thefactory/contracts/context/dcdi/libs/DCDIContractService.sol";

interface IContextInitializer {

    function previewDeploy(
        address context,
        address deployer,
        bytes memory args
    ) external view returns(address deployment);

    /**
     * @dev WILL BE delegatecalled.
     * @dev Initializers will be able to capture Context and msg.sender directly.
     */
    function deploy(
        bytes memory args
    ) external returns(address deployment);

}

contract DCDIIniter is IContextInitializer {

    using Create2AwareService for ICreate2Aware.Metadata;
    using FactoryService for address;
    using DCDIFactoryService for bytes;
    using DCDIFactoryService for bytes32;

    function encodeArgs(
        bytes memory initCode,
        bytes memory initData
    ) public pure returns(bytes memory) {
        return abi.encode(initCode, initData); 
    }

    function previewDeploy(
        // context
        address context,
        // deployer
        address ,
        bytes memory args
    ) public pure returns(address deployment) {
        (
            bytes memory initCode,
            bytes memory initData
        ) = abi.decode(args, (bytes, bytes));
        bytes32 initCodeHash = keccak256(initCode);
        bytes32 salt = initCodeHash._calcSalt(keccak256(initData));
        return context._create2AddressFrom(
            initCodeHash,
            salt
        );
    }

    function deploy(
        bytes memory args
    ) public returns(address deployment) {
        (
            bytes memory initCode,
            bytes memory initData
        ) = abi.decode(args, (bytes, bytes));
        return initCode._deploySelfIDInjection(initData);
    }

}

library ContextIniterDelegateAdaptor {

    using Address for address;

    function delegateDeploy(
        IContextInitializer initializer,
        bytes memory args
    ) public returns(address newContract) {
        return abi.decode(
            address(initializer)
            ._delegateCall(
                IContextInitializer.deploy.selector,
                args
            ),
            (address)
        );
    }

}

contract Context {

    using ContextIniterDelegateAdaptor for IContextInitializer;

    function previewDeploy(
        IContextInitializer initializer,
        address deployer,
        bytes memory args
    ) public view returns(address newContract) {
        return initializer.previewDeploy(
            address(this),
            deployer,
            args
        );
    }

    function deploy(
        IContextInitializer initializer,
        bytes memory args
    ) public returns(address newContract) {
        return initializer.delegateDeploy(args);
    }

}