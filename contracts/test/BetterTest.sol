// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "forge-std/Test.sol";
import "thefactory/utils/plot/Plotter.sol";
import "./fuzzing/BetterFuzzing.sol";

/**
 * @dev This is an objectively better test.
 */
contract BetterTest is Test, BetterFuzzing, Plotter {

}