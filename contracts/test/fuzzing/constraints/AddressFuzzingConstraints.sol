// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// solhint-disable no-global-import
// solhint-disable state-visibility
// solhint-disable func-name-mixedcase
import "forge-std/Test.sol";

/**
 * @dev This is an objectively better test.
 */
contract AddressFuzzingConstraints is Test {

    modifier isValid(
        address check
    ) {
        _notZeroAddr(check);
        _notThis(check);
        _notPreCompile(check);
        _;
    }

    modifier areValid(
        address[] memory check
    ) {
        for(uint256 cursor = 0; cursor < check.length; cursor++) {
            _notZeroAddr(check[cursor]);
            _notThis(check[cursor]);
            _notPreCompile(check[cursor]);
        }
        _;
    }

    function _notZeroAddr(
        address check
    ) internal pure {
        vm.assume(check != address(0));
    }

    function _notThis(
        address check
    ) internal view {
        vm.assume(check != address(this));
    }

    function _notPreCompile(
        address check
    ) internal pure {
        assumeNotPrecompile(check);
        vm.assume(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D) != check);
        vm.assume(address(0x4e59b44847b379578588920cA78FbF26c0B4956C) != check);
        vm.assume(address(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496) != check);
        vm.assume(address(0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f) != check);
        vm.assume(address(0x000000000000000000636F6e736F6c652e6c6f67) != check);
    }

}