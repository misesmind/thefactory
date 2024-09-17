// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "forge-std/Test.sol";
// import "contracts/test/foundry/extensions/TestExtended.sol";

// import "contracts/libs/primitives/Bytecode.sol";
// // import "contracts/test/stubs/messanger/mutable/types/context/proxy/types/targets/MutableGreeterProxyTarget.sol";
// import "contracts/test/stubs/messanger/mutable/types/MutableGreeterStub.sol";

// contract BytecodeTest is TestExtended {

//     address controlCode;

//     function setUp()
//     public {
//         // controlCode = address(new MutableGreeterTarget());
//         controlCode = context().deployContract(
//                 type(MutableGreeterStub).creationCode,
//                 ""
//             );
//     }

//     // TODO implement test
//     function test_codeSizeOf(
//         address testValue
//     ) public
//     isValid(testValue)
//     {
//         // vm.etch(testValue, address(controlCode).code);
//         // assertEq(Bytecode._codeSizeOf(testValue), 1295);
//     }

//     function test__codeAt(
//         address testValue,
//         string calldata testMessage
//     ) public
//     isValid(testValue)
//     {
//         vm.etch(testValue, address(controlCode).code);
//         IMutableGreeter(testValue).setMessage(
//             testMessage
//         );
//         assertEq(
//             IMutableGreeter(testValue).getMessage(),
//             testMessage
//         );
//     }

//     function test__initCodeFor(
//         string calldata testMessage
//     ) public {
//         bytes memory creationCode = Bytecode._initCodeFor(address(controlCode).code);
//         address deployment;
//         assembly {
//             let encoded_data := add(0x20, creationCode)
//             let encoded_size := mload(creationCode)
//             deployment := create(0, encoded_data, encoded_size)
//         }
//         IMutableGreeter(deployment).setMessage(
//             testMessage
//         );
//         assertEq(
//             IMutableGreeter(deployment).getMessage(),
//             testMessage
//         );
//     }

//     function test__create(
//         string calldata testMessage
//     ) public {
//         bytes memory creationCode = Bytecode._initCodeFor(address(controlCode).code);
//         address deployment = Bytecode._create(creationCode);
//         IMutableGreeter(deployment).setMessage(
//             testMessage
//         );
//         assertEq(
//             IMutableGreeter(deployment).getMessage(),
//             testMessage
//         );
//     }

//     // TODO implement test
//     function test__createWithArgs(
//         string calldata testMessage
//     ) public {
//         // address deployment = Bytecode._createWithArgs(
//         //     type(MutableGreeterStub).creationCode,
//         //     abi.encode(testMessage)
//         // );
//         // assertEq(
//         //     IMutableGreeter(deployment).getMessage(),
//         //     testMessage
//         // );
//     }

//     // TODO implement test
//     function test__create2AddressFromOf(
//         bytes32 testSalt
//     ) public
//     notZeroBytes32(testSalt)
//      {
//         // vm.assume(testSalt != bytes32(0));
//         // address expectedDeployment = Bytecode._create2AddressFromOf(
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

//     // TODO implement test
//     function test__create2(
//         bytes32 testSalt
//     ) public
//     notZeroBytes32(testSalt)
//      {
//         // vm.assume(testSalt != bytes32(0));
//         // address expectedDeployment = Bytecode._create2AddressFromOf(
//         //     address(this),
//         //     keccak256(type(MutableGreeterTarget).creationCode),
//         //     testSalt
//         // );
//         // address testDeployment = Bytecode._create2(
//         //     type(MutableGreeterTarget).creationCode,
//         //     testSalt
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create2WithArgsAddressFromOf(
//         bytes32 testSalt,
//         string calldata testMessage
//     ) public {
//         // address expectedDeployment = Bytecode._create2WithArgsAddressFromOf(
//         //     address(this),
//         //     type(MutableGreeterStub).creationCode,
//         //     abi.encode(testMessage),
//         //     testSalt
//         // );
//         // address testDeployment = address(new MutableGreeterStub{salt: testSalt}(testMessage));
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create2WithArgs(
//         bytes32 testSalt,
//         string calldata testMessage
//     ) public
//     notZeroBytes32(testSalt)
//      {
//         // vm.assume(testSalt != bytes32(0));
//         // address expectedDeployment = Bytecode._create2WithArgsAddressFromOf(
//         //     address(this),
//         //     type(MutableGreeterStub).creationCode,
//         //     abi.encode(testMessage),
//         //     testSalt
//         // );
//         // address testDeployment = Bytecode._create2WithArgs(
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
//     function test__create3AddressFromOf(
//         bytes32 testSalt
//     ) public
//     notZeroBytes32(testSalt)
//     {
//         // vm.assume(testSalt != bytes32(0));
//         // address expectedDeployment = Bytecode._create3AddressFromOf(
//         //     address(this),
//         //     testSalt
//         // );
//         // address testDeployment = Bytecode._create3(
//         //     type(MutableGreeterTarget).creationCode,
//         //     testSalt,
//         //     0
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create3AddressOf(
//         bytes32 testSalt
//     ) public
//     notZeroBytes32(testSalt)
//     {
//         // vm.assume(testSalt != bytes32(0));
//         // address expectedDeployment = Bytecode._create3AddressOf(
//         //     testSalt
//         // );
//         // address testDeployment = Bytecode._create3(
//         //     type(MutableGreeterTarget).creationCode,
//         //     testSalt,
//         //     0
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//     }

//     // TODO implement test
//     function test__create3(
//         bytes32 testSalt,
//         string calldata testMessage
//     ) public
//     notZeroBytes32(testSalt)
//     {
//         // address expectedDeployment = Bytecode._create3AddressOf(
//         //     testSalt
//         // );
//         // address testDeployment = Bytecode._create3(
//         //     type(MutableGreeterTarget).creationCode,
//         //     testSalt
//         // );
//         // assertEq(
//         //     expectedDeployment,
//         //     testDeployment
//         // );
//         // IMutableGreeter(testDeployment).setMessage(
//         //     testMessage
//         // );
//         // assertEq(
//         //     IMutableGreeter(testDeployment).getMessage(),
//         //     testMessage
//         // );
//     }

// }