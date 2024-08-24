pragma solidity ^0.8.23;

// import {IERC20} from "contracts/tokens/erc20/interfaces/IERC20.sol";
import "thefactory/protocols/dexes/balancer/v3/interfaces/pool-utils/IRateProvider.sol";
import "thefactory/protocols/dexes/balancer/v3/interfaces/vault/IBasePool.sol";
import "thefactory/tokens/erc20/interfaces/IERC20.sol";

// 

interface IComposableStablePoolFactory {

    function create(
        string memory name,
        string memory symbol,
        IERC20[] memory tokens,
        uint256 amplificationParameter,
        IRateProvider[] memory rateProviders,
        uint256[] memory tokenRateCacheDurations,
        bool exemptFromYieldProtocolFeeFlag,
        uint256 swapFeePercentage,
        address owner,
        bytes32 salt
    ) external returns (IBasePool);
}