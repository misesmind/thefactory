// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IRateProvider} from "./pool-utils/IRateProvider.sol";
import {IERC20} from "../../../../../tokens/erc20/interfaces/IERC20.sol";

interface IWeightedPoolFactory {
    function create(
        string memory name,
        string memory symbol,
        IERC20[] memory tokens,
        uint256[] memory normalizedWeights,
        IRateProvider[] memory rateProviders,
        uint256 swapFeePercentage,
        address owner,
        bytes32 salt
    ) external returns (address);
}

