// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "thefactory/test/BetterTest.sol";

import "thefactory/storage/immutable/ImmutableRepo.sol";

// contract ImmutableRepoTest is TestExtended {

//     function setUp()
//     public {}

//     function test_salt(
//         bytes32 controlStorageRange
//     ) public {
//         bytes32 controlSalt = keccak256(abi.encode(ImmutableRepo.STORAGE_RANGE_OFFSET, controlStorageRange));
//         bytes32 testSalt = ImmutableRepo._salt(controlStorageRange);
//         assertEq(
//             controlSalt,
//             testSalt
//         );
//     }

//     function test__writeBlob(
//         bytes memory controlBlob
//     ) public {
//         vm.assume(controlBlob.length > 0);
//         address pointer = ImmutableRepo._writeBlob(
//             controlBlob
//         );
//         bytes memory testBlob = ImmutableRepo._readBlob(
//             pointer
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test__readBlob(
//         bytes memory controlBlob
//     ) public {
//         vm.assume(controlBlob.length > 0);
//         address pointer = ImmutableRepo._writeBlob(
//             controlBlob
//         );
//         bytes memory testBlob = ImmutableRepo._readBlob(
//             pointer
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test__mapBlob(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         bytes memory testBlob = ImmutableRepo._queryBlobOf(
//             key
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test__queryBlobFromOf(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         bytes memory testBlob = ImmutableRepo._queryBlobFromOf(
//             address(this),
//             key
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test__queryBlobOf(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         bytes memory testBlob = ImmutableRepo._queryBlobOf(
//             key
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test_pointerFromOf(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         address expectedPointer = ImmutableRepo._pointerFromOf(
//             address(this),
//             key
//         );
//         address pointer = ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         assertEq(
//             pointer,
//             expectedPointer
//         );
//         bytes memory testBlob = ImmutableRepo._readBlob(
//             pointer
//         );
//         assertEq(
//             controlBlob,
//             testBlob
//         );
//     }

//     function test_recordSizeFromOf(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         address pointer = ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         bytes memory testBlob = ImmutableRepo._readBlob(
//             pointer
//         );
//         assertEq(
//             controlBlob.length,
//             testBlob.length
//         );
//     }

//     function test_isPresentFrom(
//         bytes memory controlBlob,
//         bytes32 key
//     ) public {
//         ImmutableRepo._mapBlob(
//             controlBlob,
//             key
//         );
//         assertEq(
//             ImmutableRepo._isPresentFrom(address(this), key),
//             true
//         );
//     }

// }