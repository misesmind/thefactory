// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/collections/Collections.sol";
import "thefactory/utils/primitives/Primitives.sol";
// import "contracts/daosys/core/test/behaviors/Behavior.sol";

import "../interfaces/IERC165.sol";

// import "hardhat/console.sol";
import {console} from "forge-std/console.sol";
// import {console2} from "forge-std/console2.sol";

contract ERC165Behavior {

    using Address for address;
    using AddressSetRepo for AddressSet;
    using Bytes4SetRepo for Bytes4Set;

    mapping(address => Bytes4Set) internal _expected_supportsInterface;

    // constructor() ERC165Behavior() {}

    /* ---------------------------------------------------------------------- */
    /*                             TEST INSTANCES                             */
    /* ---------------------------------------------------------------------- */

    function expected_supportsInterface(
        address subject
    ) public view returns(bytes4[] memory controlInterfaceIds) {
        controlInterfaceIds = _expected_supportsInterface[subject]._asArray();
    }

    /* ---------------------------------------------------------------------- */
    /*                       TEST INSTANCE REGISTRATION                       */
    /* ---------------------------------------------------------------------- */

    function register(
        address subject,
        bytes4 controlInterfaceId
    ) public {
        _expected_supportsInterface[subject]._add(controlInterfaceId);
    }

    function register(
        address subject,
        bytes4[] memory controlInterfaceIds
    ) public {
        _expected_supportsInterface[subject]._add(controlInterfaceIds);
    }

    /* ---------------------------------------------------------------------- */
    /*                            VALIDATION LOGIC                            */
    /* ---------------------------------------------------------------------- */

    function validate(
        address subject
    ) public view virtual returns(bool isValid) {
        isValid = true;
        IERC165 testInstance = IERC165(address(subject));
        for(uint256 index = 0; index < _expected_supportsInterface[subject]._length(); index++) {
            bool specCheck = testInstance.supportsInterface(_expected_supportsInterface[subject]._index(index));
            if(!specCheck) {
                console.log("Expected contract %s does not support interface ");
                console.logBytes4(_expected_supportsInterface[subject]._index(index));
                isValid = specCheck;
            }
        }
        return isValid;
    }

}