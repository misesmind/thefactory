// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title utility functions for uint256 operations
 * @author Nick Barry, mises mind <misesmind@proton.me>
 * @dev derived from https://github.com/OpenZeppelin/openzeppelin-contracts/ (MIT license)
 */
library UInt {

    // Array of possible hexidecimal values.
    bytes16 private constant HEX_SYMBOLS = "0123456789abcdef";


    /**
     * @dev Converts an uint256 to an address truncating from the left.
     * @dev All values over 2^160-1 will be returned as 2^160-1.
     * @param value The value to convert.
     * @return result The converted value.
     */
    function _toAddress(
        uint256 value
    ) internal pure returns(address result) {
        result = address(uint160(value));
    }

    /**
     * @dev Left pads (prepends) zeroes to provided address
     * @param value The value to convert.
     * @return result The converted value.
     */
    function _toBytes32(
        uint256 value
    ) internal pure returns(bytes32 result) {
        result = bytes32(value);
    }

    /**
     * @dev Converts a uint256 to a string.
     * @param value The value to convert.
     * @return result The converted value.
     */
    function _toString(
        uint256 value
    ) internal pure returns (string memory result) {
        if (value == 0) {
        return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    /**
     * @dev Converts a uint256 to the hex value of a string.
     * @param value The value to convert.
     * @return result The converted value.
     */
  function _toHexString(
    uint256 value
  ) internal pure returns (string memory result) {
    if (value == 0) {
      return "0x00";
    }

    uint256 length = 0;

    for (uint256 temp = value; temp != 0; temp >>= 8) {
      unchecked {
        length++;
      }
    }

    return _toHexString(value, length);
  }

  function _toHexString(
    uint256 value,
    uint256 length
  ) internal pure returns (string memory valueAsString) {
    bytes memory buffer = new bytes(2 * length + 2);
    buffer[0] = "0";
    buffer[1] = "x";

    unchecked {
      for (uint256 i = 2 * length + 1; i > 1; --i) {
        buffer[i] = HEX_SYMBOLS[value & 0xf];
        value >>= 4;
      }
    }

    require(value == 0, "UintUtils: hex length insufficient");

    return string(buffer);
  }
}
