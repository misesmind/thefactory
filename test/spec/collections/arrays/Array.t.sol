// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "thefactory/test/BetterTest.sol";

import "thefactory/collections/arrays/Array.sol";

/**
 * @title ArrayTest Unit tests or the Array library.
 * @author mises mind <misesmind@proton.me>
 */
contract ArrayTest is BetterTest {

    using Array for uint256;

    /**
     * @dev Tests that function returns TRUE when the index with less than the length.
     * @param testLength The value to use as an array length for testing.
     * @param testIndex The value to use as an index to confirm is within the array length.
     */
    function test__isValidIndex(
        uint256 testLength,
        uint256 testIndex
    ) public pure {
        // Throw away any values that would not be expected to pass.
        vm.assume(testLength > testIndex);
        assertTrue(testLength._isValidIndex(testIndex));
    }

    /**
     * @dev Tests that function returns FALSE when the index with greater than the length.
     * @param testLength The value to use as an array length for testing.
     * @param testIndex The value to use as an index to confirm is within the array length.
     */
    function testFail__isValidIndex(
        uint256 testLength,
        uint256 testIndex
    ) public pure {
        // Throw away any values that would be expected to pass.
        vm.assume(testLength < testIndex);
        assertTrue(testLength._isValidIndex(testIndex));
    }

    /**
     * @dev Tests that function returns FALSE when the index with greater than the length.
     * @param testLength The value to use as an array length for testing.
     * @param testIndex The value to use as an index to confirm is within the array length.
     */
    function testError__isValidIndex(
        uint256 testLength,
        uint256 testIndex
    ) public {
        // Throw away any values that would be expected to pass.
        vm.assume(testLength < testIndex);
        vm.expectRevert(abi.encodeWithSelector(Array.IndexOutOfBounds.selector, testLength, testIndex));
        testLength._isValidIndex(testIndex);
    }

}