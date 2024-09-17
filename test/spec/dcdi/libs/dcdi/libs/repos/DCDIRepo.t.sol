// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "forge-std/Test.sol";
import "lib/forge-std/src/Test.sol";

import "thefactory/dcdi/libs/DCDIRepo.sol";

contract DCDIRepoTest is Test {

    using DCDIRepo for bytes;

    function setUp()
    public {}

    function test_isInjected(
        address consumer,
        bytes32 key
    ) public {
        
    }

    function test_injectData(
        string memory testValue,
        address consumer,
        bytes32 key
    ) public {
        address pointer = abi.encode(testValue)._injectData(consumer, key);
    }

    function test_queryInjectedData(
        address consumer,
        bytes32 key
    ) public {
        
    }

}