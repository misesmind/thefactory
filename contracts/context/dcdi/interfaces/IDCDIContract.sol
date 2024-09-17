// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {
    IERC165,
    IContract
} from "./IContract.sol";

interface IDCDIContract is IContract {

    /**
     * @return initData_ The data injected to initialize the contract exposing this interface.
     */
    function initData()
    external view returns(bytes memory initData_);

}