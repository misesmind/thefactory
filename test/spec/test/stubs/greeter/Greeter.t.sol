// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "thefactory/test/BetterTest.sol";

import "thefactory/test/stubs/greeter/types/GreeterTarget.sol";

contract GreeterTest is BetterTest {

    GreeterTarget greeter;

    function setUp()
    public {
        greeter = new GreeterTarget();
    }

    function test_IGreeter(
        string memory testMessage
    ) public {
        greeter.setMessage(testMessage);
        assertEq(
            keccak256(bytes(testMessage)),
            keccak256(bytes(greeter.getMessage()))
        );
    }


}