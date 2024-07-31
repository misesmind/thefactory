// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import "thefactory/test/BetterTest.sol";

import "thefactory/test/stubs/greeter/types/access/ownable/OwnableGreeter.sol";

contract OwnableTargetTest is BetterTest {

    address owner = vm.addr(uint256(bytes32(bytes("owner"))));
    // address newOwner = vm.addr(uint256(bytes32(bytes("newOwner"))));
    // address nonOwner = vm.addr(uint256(bytes32(bytes("nonOwner"))));

    OwnableGreeter greeter;

    function setUp()
    public {
        greeter = new OwnableGreeter(owner);
    }

    function test_IGreeter(
        string memory testMessage
    ) public {
        vm.prank(owner);
        greeter.setMessage(testMessage);
        assertEq(
            keccak256(bytes(testMessage)),
            keccak256(bytes(greeter.getMessage()))
        );
    }

    function testFail_IGreeter(
        string memory testMessage
    ) public {
        // vm.prank(owner);
        vm.expectRevert(abi.encode(IOwnable.NotOwner.selector, address(this)));
        greeter.setMessage(testMessage);
    }

    function test_owner() public view {
        assertEq(
            owner,
            greeter.owner()
        );
    }

    function test_transferOwnerShip(
        address newOwner,
        string memory testMessage
    ) public notZeroAddr(newOwner) {
        vm.expectEmit(address(greeter));
        emit IOwnable.TransferProposed(newOwner);
        vm.prank(owner);
        greeter.transferOwnership(newOwner);
        assertEq(
            newOwner,
            greeter.proposedOwner()
        );
        vm.expectEmit(address(greeter));
        emit IOwnable.OwnershipTransfered(
            owner,
            newOwner
        );
        vm.prank(newOwner);
        greeter.acceptOwnership();
        assertEq(
            newOwner,
            greeter.owner()
        );
        vm.prank(newOwner);
        greeter.setMessage(testMessage);
        assertEq(
            keccak256(bytes(testMessage)),
            keccak256(bytes(greeter.getMessage()))
        );
    }

    function testFail_transferOwnerShip(
        address nonOwner
    ) public notZeroAddr(nonOwner) {
        vm.prank(nonOwner);
        vm.expectRevert(abi.encode(IOwnable.NotProposed.selector, nonOwner));
        greeter.acceptOwnership();
    }

    function testFail_renounceOwnership(string memory testMessage) public {
        vm.expectEmit(address(greeter));
        emit IOwnable.OwnershipTransfered(
            owner,
            address(0)
        );
        vm.prank(owner);
        greeter.renounceOwnership();
        assertEq(
            address(0),
            greeter.owner()
        );
        vm.expectRevert(abi.encode(IOwnable.NotOwner.selector, address(this)));
        greeter.setMessage(testMessage);
    }

}