// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Constants.sol";

/**
 * @dev a proper math lib.
 */
library BetterMath {

    using BetterMath for uint256;

    uint8 constant ERC20_DEFAULT_DECIMALS = 18;

  function _convertDecimalsFromTo(
    uint256 amount,
    uint8 amountDecimals,
    uint8 targetDecimals
  ) internal pure returns(uint256 convertedAmount) {
    if(amountDecimals == targetDecimals) {
      return amount;
    }
    convertedAmount = amountDecimals > targetDecimals
    ? amount / 10**(amountDecimals - targetDecimals)
    : amount * 10**(targetDecimals - amountDecimals);
  }

    function _precision(
        uint256 value,
        uint8 precision,
        uint8 targetPrecision
    ) internal pure returns(uint256 preciseValue) {
        preciseValue = value._convertDecimalsFromTo(
            precision,
            targetPrecision
        );
    }

    function _normalize(
        uint256 value
    ) internal pure returns(uint256) {
        return value._precision(ERC20_DEFAULT_DECIMALS, 2);
    }

    function _min(uint256 a, uint256 b)
    internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function _mod(
        uint256 a,
        uint256 b
    ) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    function _safeHalf(
        uint256 value
    ) internal pure returns(uint256 safeHalf) {
        safeHalf = value / 2;
        if(value._mod(2) == 0) {
            return safeHalf;
        }
        return value - safeHalf;
    }

    function _sqrt(uint256 x)
    internal pure returns (uint z) {
        assembly {
            // Start off with z at 1.
            z := 1

            // Used below to help find a nearby power of 2.
            let y := x

            // Find the lowest power of 2 that is at least sqrt(x).
            if iszero(lt(y, 0x100000000000000000000000000000000)) {
                y := shr(128, y) // Like dividing by 2 ** 128.
                z := shl(64, z) // Like multiplying by 2 ** 64.
            }
            if iszero(lt(y, 0x10000000000000000)) {
                y := shr(64, y) // Like dividing by 2 ** 64.
                z := shl(32, z) // Like multiplying by 2 ** 32.
            }
            if iszero(lt(y, 0x100000000)) {
                y := shr(32, y) // Like dividing by 2 ** 32.
                z := shl(16, z) // Like multiplying by 2 ** 16.
            }
            if iszero(lt(y, 0x10000)) {
                y := shr(16, y) // Like dividing by 2 ** 16.
                z := shl(8, z) // Like multiplying by 2 ** 8.
            }
            if iszero(lt(y, 0x100)) {
                y := shr(8, y) // Like dividing by 2 ** 8.
                z := shl(4, z) // Like multiplying by 2 ** 4.
            }
            if iszero(lt(y, 0x10)) {
                y := shr(4, y) // Like dividing by 2 ** 4.
                z := shl(2, z) // Like multiplying by 2 ** 2.
            }
            if iszero(lt(y, 0x8)) {
                // Equivalent to 2 ** z.
                z := shl(1, z)
            }

            // Shifting right by 1 is like dividing by 2.
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            // Compute a rounded down version of z.
            let zRoundDown := div(x, z)

            // If zRoundDown is smaller, use it.
            if lt(zRoundDown, z) {
                z := zRoundDown
            }
        }
    }

    function _mulDivDown(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 z) {
        assembly {
            // Store x * y in z for now.
            z := mul(x, y)

            // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
            if iszero(and(iszero(iszero(denominator)), or(iszero(x), eq(div(z, x), y)))) {
                revert(0, 0)
            }

            // Divide z by the denominator.
            z := div(z, denominator)
        }
    }

    function _mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
        return _mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
    }

    function _divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
      // require( (y != 0), "FixedPointWadMathLib:_divWadDown:: Attempting to divide by 0");
      return _mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
    }

}