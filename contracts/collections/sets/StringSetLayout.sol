// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Array} from "../arrays/Array.sol";

    struct StringSet {
        // 1-indexed to allow 0 to signify nonexistence
        mapping( string => uint256 ) indexes;
        string[] values;
    }

/**
 * @title StringSetLayout - Struct and atomic operations for a set of string values
 * @author mises mind <misesmind@proton.me>
 */
library StringSetLayout {

    using Array for uint256;

    /**
     * @dev Will rrevert is provided index is out of bounds.
     * @param set The sotrage struct upon which this function will operate.
     * @param index The index of the value to be loaded from storage.
     * @return value The value from the set at the provided index.
     */
    function _index(
        StringSet storage set,
        uint index
    ) internal view returns (string memory) {
        require(set.values.length._isValidIndex(index));
        return set.values[index];
    }

    /**
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param value The value of which to retrieve the index.
     * @return index The index of the value.
     */
    function _indexOf(
        StringSet storage set,
        string memory value
    ) internal view returns (uint) {
        unchecked {
            return set.indexes[value] - 1;
        }
    }

    /**
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param value The value for which to check presence.
     * @return isPresent Boolean indicating presence of value in set.
     */
    function _contains(
        StringSet storage set,
        string memory value
    ) internal view returns (bool) {
        return set.indexes[value] != 0;
    }

    /**
     * @param set The storage pointer of the struct upon which this function should operate.
     * @return length The "length", quantity of entries, of the provided set.
     */
    function _length(
        StringSet storage set
    ) internal view returns (uint) {
        return set.values.length;
    }

    /**
     * @dev Writen to be idempotent.
     * @dev Sets care about ensuring desired state.
     * @dev Desired state is for address to be present in set.
     * @dev If address is present, desired state has been achieved.
     * @dev When the state change was achieved is irrelevant.
     * @dev If presence prior to addition is relevant, encapsulating logic should check for presence.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param value The value to ensure is present in the provided set.
     * @return success Boolean indicating desired set state has been achieved.
     */
    function _add(
        StringSet storage set,
        string memory value
    ) internal returns (bool success) {
        if (!_contains(set, value)) {
            set.values.push(value);
            set.indexes[value] = set.values.length;
        } 
        success = true;
    }

    /**
     * @dev Idempotently adds an array of values to the provided set.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param values The array of values to ensure are present in the provided set.
     * @return success Boolean indicating desired set state has been achieved.
     */
    function _add(
        StringSet storage set,
        string[] memory values
    ) internal returns (bool success) {
        for(uint256 iteration = 0; iteration < values.length; iteration++) {
            _add(set, values[iteration]);
        }
        success = true;
    }

    /**
     * @dev Writen to be idempotent.
     * @dev Sets care about ensuring desired state.
     * @dev Desired state is for address to not be present in the set.
     * @dev If address is not present, desired state has been achieved.
     * @dev When the state change was achieved is irrelevant.
     * @dev If lack of presence prior to addition is relevant, encapsulating logic should check for lakc of presence.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param value The value to ensure is not present in the provided set.
     * @return success Boolean indicating desired set state has been achieved.
     */
    function _remove(
        StringSet storage set,
        string memory value
    ) internal returns (bool) {
        uint valueIndex = set.indexes[value];

        if (valueIndex != 0) {
            uint index = valueIndex - 1;
            string memory last = set.values[set.values.length - 1];

            // move last value to now-vacant index

            set.values[index] = last;
            set.indexes[last] = index + 1;

            // clear last index

            set.values.pop();
            delete set.indexes[value];

        }

        return true;
    }

    /**
     * @dev Idempotently removes an array of values to the provided set.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @param values The array of values to ensure are not present in the provided set.
     * @return success Boolean indicating desired set state has been achieved.
     */
    function _remove(
        StringSet storage set,
        string[] memory values
    ) internal returns (bool success) {
        for(uint256 iteration = 0; iteration < values.length; iteration++) {
            _remove(set, values[iteration]);
        }
        success = true;
    }

    /**
     * @dev Copies the set into memory as an array.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @return array The members of the set copied to memory as an array.
     */
    function _asArray(
        StringSet storage set
    ) internal view returns (string[] memory array ) {
        array = set.values;
    }

    /**
     * @dev Provides the storage pointer os the underlying array of value.
     * @dev DO NOT alter values via this pointer.
     * @dev ONLY use to minimize memory usage when passing a reference internally for gas efficiency.
     * @param set The storage pointer of the struct upon which this function should operate.
     * @return values The members of the set copied to memory as an array.
     */
    function _values(
        StringSet storage set
    ) internal view returns (string[] storage values) {
        values = set.values;
    }

}