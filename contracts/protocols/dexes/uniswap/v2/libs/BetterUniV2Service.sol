// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/tokens/erc20/libs/utils/SafeERC20.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "./BetterUniV2Utils.sol";

library BetterUniV2Service {

    using BetterUniV2Utils for uint256;
    using SafeERC20 for IERC20;

    function _swapDirect(
        IUniswapV2Pair pair,
        IERC20 soldToken,
        uint amountToSell
    ) internal returns(uint256 proceedsAmount) {
        (
            uint256 totalReserve0,
            uint256 totalReserve1,

        ) = pair.getReserves();


        address token0 = pair.token0();

        (
            uint256 soldTokenReserve,
            uint256 proceedsTokenReserve
        ) = address(soldToken) == address(token0)
            ? (totalReserve0, totalReserve1)
            : (totalReserve1, totalReserve0);

        proceedsAmount = amountToSell._calcSaleProceeds(
            soldTokenReserve,
            proceedsTokenReserve
        );

        (
            uint256 amount0Out,
            uint256 amount1Out
        ) = address(soldToken) == address(token0)
            ? (uint256(0), proceedsAmount)
            : (proceedsAmount, uint256(0));

        IERC20(soldToken)._safeTransfer(address(pair), amountToSell);
        pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
    }

    function _depositDirect(
        IUniswapV2Pair pair,
        IERC20 tokenA,
        IERC20 tokenB,
        uint256 tokenAAmount,
        uint256 tokenBAmount
    ) internal returns (uint256 lpTokenAmount) {
        tokenA._safeTransfer(address(pair), tokenAAmount);
        tokenB._safeTransfer(address(pair), tokenBAmount);
        lpTokenAmount = pair.mint(address(this));
    }

    function _swapDepositDirect(
        IUniswapV2Pair pair,
        IERC20 saleToken,
        uint256 saleTokenAmount,
        uint256 saleTokenReserve,
        IERC20 opposingToken_
    ) internal returns(uint256 lpTokenAmount) {
        // (
        //     uint256 saleTokenReserve,
        //     address opposingToken_,
        // ) = _correlatedReserves(saleToken, pair);
        uint256 amountToSwap = saleTokenReserve._calcSwapDepositAmtIn(saleTokenAmount);
        uint256 saleTokenDeposit = (saleTokenAmount - amountToSwap);
        uint256 opposingTokenAmount = _swapDirect(
            IUniswapV2Pair(pair),
            saleToken,
            saleTokenAmount
        );
        lpTokenAmount = _depositDirect(
            pair,
            saleToken,
            opposingToken_,
            saleTokenDeposit,
            opposingTokenAmount
        );
    }

    function _withdrawDirect(
        IUniswapV2Pair pool,
        uint256 amt
    ) internal {
        pool.transfer(address(pool), amt);
        pool.burn(address(this));
    }

}