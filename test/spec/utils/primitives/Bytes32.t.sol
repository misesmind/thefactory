// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "thefactory/utils/primitives/Primitives.sol";

contract Bytes32Test is Test {

    function test_toAddress(
        bytes32 testValue
    ) public pure {
        vm.assume(testValue > bytes32(0));
        vm.assume(testValue <= bytes32(uint256(type(uint160).max)));
        assertEq(
            address(uint160(uint256(testValue))),
            Bytes32._toAddress(testValue)
        );
        assert(
            Bytes32._toAddress(testValue) != address(bytes20(testValue))
        );
    }

}