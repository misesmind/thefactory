// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "forge-std/Test.sol";
// import "contracts/test/foundry/extensions/TestExtended.sol";

import "thefactory/introspection/erc165/libs/ERC165Utils.sol";

contract ERC165UtilsTest is Test {

    using ERC165Utils for bytes4[];

    function test_calcInterfaceId(
        bytes4[] memory testValues
    ) public {
        bytes4 interfaceId;
        for(uint256 cursor = 0; cursor < testValues.length; cursor++) {
            interfaceId ^= testValues[cursor];
        }
        assertEq(
            interfaceId,
            testValues._calcInterfaceId()
        );
    }

}