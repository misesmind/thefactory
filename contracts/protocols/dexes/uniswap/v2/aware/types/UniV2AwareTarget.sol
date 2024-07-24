// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/protocols/dexes/uniSwap/v2/aware/types/UniV2AwareStorage.sol";

contract UniV2AwareTarget is UniV2AwareStorage, IUniV2Aware {

    function uniV2Router() external view returns(IUniswapV2Router02) {
        return _uniV2Router();
    }

    function uniV2Factory() external view returns(IUniswapV2Factory) {
        return _uniV2Factory();
    }

    function uniV2() external view returns(address factory, address router) {
        return _uniV2Protocol();
    }
    
}