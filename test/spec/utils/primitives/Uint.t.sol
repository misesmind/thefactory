// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "thefactory/utils/primitives/Primitives.sol";

contract UintTest is Test {

    function test__toAddress(
        uint256 controlValue
    ) public {
        // address expectedValue = address(uint160(controlValue));
        // address testValue = UInt._toAddress(controlValue);
        // assertEq(
        //     expectedValue,
        //     testValue
        // );
    }

    function test__toBytes32(
        uint256 controlValue
    ) public {
        // bytes32 expectedValue = bytes32(controlValue);
        // bytes32 testValue = UInt._toBytes32(controlValue);
        // assertEq(
        //     expectedValue,
        //     testValue
        // );
    }

    function test__toString(
        uint256 controlValue
    ) public {
        // string memory expectedValue = vm.toString(controlValue);
        // string memory testValue = UInt._toString(controlValue);
        // assertEq(
        //     expectedValue,
        //     testValue
        // );
    }

}