// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/protocols/dexes/uniSwap/v2/interfaces/IUniswapV2Router02.sol";
import "thefactory/protocols/dexes/uniSwap/v2/interfaces/IUniswapV2Factory.sol";

interface IUniV2Aware {

    function uniV2() external view returns(address factory, address router);

    function uniV2Router() external view returns(IUniswapV2Router02);

    function uniV2Factory() external view returns(IUniswapV2Factory);

}