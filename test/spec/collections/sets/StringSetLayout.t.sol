// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "thefactory/test/BetterTest.sol";

import "thefactory/collections/Collections.sol";

/**
 * @title StringSetLayoutTest Unit tests for storage layout operations upon an StringSet struct.
 * @author mises mind <misesmind@proton.me>
 */
contract StringSetLayoutTest is BetterTest {

    using StringSetLayout for StringSet;

    StringSet testInstance;

    /**
     * @dev Tests retreiving a value by index.
     * @param values Test values for use in the set.
     */
    function test_index(
        string[] calldata values
    ) public {
        // Manually add the values to the set.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            testInstance.values.push(values[cursor]);
            testInstance.indexes[values[cursor]] = testInstance.values.length;
        }
        // Check that the mapped indexes do load the matching value.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            assertEq(
                values[cursor],
                testInstance._index(testInstance.indexes[values[cursor]] - 1)
            );
        }
    }

    /**
     * @dev Tests retreiving the index of a value.
     * @param values Test values for use in the set.
     */
    function test_indexOf(
        string[] calldata values
    ) public {
        // Manually add the values to the set.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            testInstance.values.push(values[cursor]);
            testInstance.indexes[values[cursor]] = testInstance.values.length;
        }
        // Check the mapped values do load the matching index.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            assertEq(
                // cursor,
                testInstance.indexes[values[cursor]] - 1,
                testInstance._indexOf(values[cursor])
            );
        }
    }

    /**
     * @dev Tests set membership query.
     * @param values Test values for use in the set.
     */
    function test_contains(
        string[] calldata values
    ) public {
        // Manually add the values to the set.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            testInstance.values.push(values[cursor]);
            testInstance.indexes[values[cursor]] = testInstance.values.length;
        }
        // Check that set membership is reported correctly.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            assert(testInstance._contains(values[cursor]));
        }
    }

    /**
     * @dev Tests set length.
     * @param values Test values for use in the set.
     */
    function test_length(
        string[] calldata values
    ) public {
        // Manually add the values to the set.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            testInstance.values.push(values[cursor]);
            testInstance.indexes[values[cursor]] = testInstance.values.length;
        }
        // Check that returned length is correct.
        assertEq(
            values.length,
            testInstance._length()
        );
    }

    /**
     * @dev Tests adding a single member to the set.
     * @param value Test value for use in the set.
     */
    function test_add(
        string calldata value
    ) public {
        // Add value.
        testInstance._add(value);
        // Manually confirm set membership.
        assertEq(
            value,
            testInstance.values[testInstance.indexes[value] - 1]
        );
    }

    /**
     * @dev Tests adding a multiple members to the set.
     * @param values Test values for use in the set.
     */
    function test_add(
        string[] calldata values
    ) public {
        // Add members to set.
        testInstance._add(values);
        // Manually confirm set membership.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
        assertEq(
            values[cursor],
            testInstance.values[testInstance.indexes[values[cursor]] - 1]
        );
        }
    }

    /**
     * @dev Tests removing a single member from the set.
     * @param value Test value for use in the set.
     */
    function test_remove(
        string calldata value
    ) public {
        // Manually add the member to the set.
        testInstance.values.push(value);
        testInstance.indexes[value] = testInstance.values.length;
        // Confirm member is set correctly.
        assert(testInstance._contains(value));
        // Remove member.
        testInstance._remove(value);
        // Confirm member removal.
        assert(!testInstance._contains(value));
    }

    /**
     * @dev Tests removing a multiple members from the set.
     * @param values Test values for use in the set.
     */
    function test_remove(
        string[] calldata values
    ) public {
        // Manually add members to set.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            testInstance.values.push(values[cursor]);
            testInstance.indexes[values[cursor]] = testInstance.values.length;
        }
        // Confirm set membership.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            assert(testInstance._contains(values[cursor]));
        }
        // Remove members and validate removal.
        for(uint256 cursor = 0; values.length > cursor; cursor++) {
            // Remove member.
            testInstance._remove(values[cursor]);
            // Confirm member removal.
            assert(!testInstance._contains(values[cursor]));
        }
    }

}