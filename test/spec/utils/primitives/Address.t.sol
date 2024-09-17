// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "forge-std/Test.sol";
// import "contracts/test/foundry/extensions/TestExtended.sol";

// import "contracts/daosys/core/primitives/Primitives.sol";

// contract AddressTest is TestExtended {

//     function test_isContract(address testValue)
//     public
//     notUsed(testValue)
//     {
//         assert(!Address._isContract(testValue));
//         vm.etch(testValue, address(this).code);
//         assert(Address._isContract(testValue));
//     }

//     function test_toBytes32(
//         address testValue
//     ) public {
//         assertEq(
//             Address._toBytes32(testValue),
//             bytes32(uint256(uint160(testValue)))
//         );
//     }

//     // function test__marshall(
//     //     address testValue
//     // ) public {
//     //     assertEq(
//     //         abi.decode(
//     //             abi.encode(testValue),
//     //             (address)
//     //         ),
//     //         abi.decode(
//     //             Address._marshall(testValue),
//     //             (address)
//     //         )
//     //     );
//     // }

// }