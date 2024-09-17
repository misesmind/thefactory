// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "forge-std/Test.sol";
// import "contracts/test/foundry/extensions/TestExtended.sol";

// import "contracts/daosys/core/factories/libs/services/FactoryService.sol";

// import "contracts/test/stubs/messanger/mutable/types/context/proxy/types/targets/MutableGreeterProxyTarget.sol";
// import "contracts/test/stubs/messanger/mutable/types/MutableGreeterStub.sol";

// contract FactoryServiceTest is TestExtended {

//     function test__calcInitCodeHash()
//     public {
//         bytes32 expectedValue = keccak256(type(MutableGreeterProxyTarget).creationCode);
//         bytes32 testValue = FactoryService._calcInitCodeHash(type(MutableGreeterProxyTarget).creationCode);
//         assertEq(
//             expectedValue,
//             testValue
//         );
//     }

//     // TODO implement test
//     function test__create(
//         string calldata testMessage
//     ) public {
//         // TODO redo with a no constructor stub
//         // address deployment = FactoryService._create(type(MutableGreeterTarget).creationCode);
//         // IMutableGreeter(deployment).setMessage(
//         //     testMessage
//         // );
//         // assertEq(
//         //     IMutableGreeter(deployment).getMessage(),
//         //     testMessage
//         // );
//     }

//     // TODO implement test
//     function test__create2(
//         bytes32 testSalt
//     ) public {
//         // TODO redo with a no constructor stub
//         // address expectedDeployment = FactoryService._create2AddressFrom(
//         //     address(this),
//         //     keccak256(type(MutableGreeterTarget).creationCode),
//         //     testSalt
//         // );
//         // address testDeployment = FactoryService._create2(
//         //     type(MutableGreeterTarget).creationCode,
//         //     testSalt
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create2WithArgs(
//         bytes32 testSalt,
//         string calldata testMessage
//     ) public {
//         // vm.assume(testSalt > bytes32(0));
//         // vm.assume(bytes(testMessage).length > 0);
//         // address expectedDeployment = Bytecode._create2WithArgsAddressFromOf(
//         //     address(this),
//         //     type(MutableGreeterStub).creationCode,
//         //     abi.encode(testMessage),
//         //     testSalt
//         // );
//         // address testDeployment = FactoryService._create2WithArgs(
//         //     type(MutableGreeterStub).creationCode,
//         //     testSalt,
//         //     abi.encode(testMessage)
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create2AddressFrom(
//         bytes32 testSalt
//     ) public {
//         // TODO redo with a no constructor stub
//         // address expectedDeployment = FactoryService._create2AddressFrom(
//         //     address(this),
//         //     keccak256(type(MutableGreeterTarget).creationCode),
//         //     testSalt
//         // );
//         // address testDeployment = address(new MutableGreeterTarget{salt: testSalt}());
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

// }