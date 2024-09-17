// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
// import "contracts/test/foundry/extensions/ExtendedTest.sol";
import "forge-std/Test.sol";

import "thefactory/utils/primitives/Primitives.sol";

/**
 * @dev Testing with range of values takes too long.
 */
contract StringTest is Test {

    using String for string;

    string constant testValue = "Hello World!";
    uint256 testPadDif = 10;
    uint256 testPadLen = bytes(testValue).length + testPadDif;
    
    function setUp() public {

    }

    function test()
    public {
    }

    function test_padLeft(
        // string memory testValue,
        // uint256 testPadLen
    ) public view {
        // vm.assume(bytes(testValue).length < testPadLen);
        string memory testResult = testValue._padLeft(" ", testPadLen);
        assertEq(
            testPadLen,
            bytes(testResult).length
        );
        console.log(string.concat(testResult, " || END TEST RESULT"));
    }

    function test_padRight(
        // string memory testValue,
        // uint256 testPadLen
    ) public view {
        // vm.assume(bytes(testValue).length < testPadLen);
        string memory testResult = testValue._padRight(" ", testPadLen);
        assertEq(
            testPadLen,
            bytes(testResult).length
        );
        console.log(testResult);
    }

}