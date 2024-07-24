// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/utils/math/BetterMath.sol";

import "thefactory/tokens/erc20/interfaces/IERC20.sol";
import {SafeERC20} from "thefactory/tokens/erc20/libs/utils/SafeERC20.sol";
import "../interfaces/IUniswapV2Factory.sol";
import "../interfaces/IUniswapV2Router02.sol";
import "../interfaces/IUniswapV2Pair.sol";
// import "contracts/daosys/core/math/Math.sol";
// import "contracts/daosys/core/math/MathEx.sol";

/* ---------------------------------- PERM ---------------------------------- */

import "thefactory/utils/primitives/Primitives.sol";

// import {console} from "forge-std/console.sol";
// import {console} from "forge-std/console.sol";
// import {console2} from "forge-std/console2.sol";

/**
 * @title UniV2Utils - Uniswap V2 utility library.
 * @author mises mind <misesmind@proton.me>
 */
library UniV2Utils {

    using Address for address;
    // using Conversion for uint256;
    using BetterMath for uint256;
    using BetterMath for Uint512;
    using SafeERC20 for IERC20;
    // using SafeMath for uint256;
    using UInt for uint256;

    uint256 private constant DEADLINE = 0xf000000000000000000000000000000000000000000000000000000000000000;
    uint internal constant _MINIMUM_LIQUIDITY = 10**3;

    /* --------------------------------- Reserve -------------------------------- */

    /**
     * @dev Sorts token address to the order used by Uniswap.
     * @param tokenA Address of token in expected pair.
     * @param tokenB Address of token in expected pair.
     * @param token0 The address that will be token 0 in the expected pair.
     * @param token1 The address that will be token 1 in the expected pair.
     */
    function _sortTokens(
        address tokenA,
        address tokenB
    ) internal pure returns (
        address token0,
        address token1
    ) {
        require(tokenA != address(0), "UniV2Utils: ZERO_ADDRESS");
        require(tokenB != address(0), "UniV2Utils: ZERO_ADDRESS");
        require(tokenA != tokenB, "UniV2Utils: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    // tag::_quote[]
    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function _quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) internal pure returns (uint amountB) {
        require(amountA > 0, "UniV2Utils: INSUFFICIENT_AMOUNT");
        require(reserveA > 0 && reserveB > 0, "UniV2Utils: INSUFFICIENT_LIQUIDITY");
        amountB = (amountA * reserveB) / reserveA;
    }
    // end::_quote[]

    function _correlateAmount(
        address pair,
        address knownToken,
        uint256 token0Amount,
        uint256 token1Amount
    ) internal view returns(
        uint256 knownTokenAmount,
        address opposingToken_,
        uint256 opposingTokenAmount
    ) {
        address token0 = IUniswapV2Pair(pair).token0();
        (
            knownTokenAmount,
            opposingToken_,
            opposingTokenAmount
        ) = knownToken == token0
            ? (token0Amount, IUniswapV2Pair(pair).token1(), token1Amount)
            : (token1Amount, token0, token0Amount);
    }

    // tag::_ownedReserves[]
    function _ownedReserves(
        uint256 ownedLPAmount,
        uint256 lpTotalSupply,
        uint256 totalReserve0,
        uint256 totalReserve1
    ) internal pure returns(
        uint256 ownedReserve0,
        uint256 ownedReserve1
    ) {
        // using balances ensures pro-rata distribution
        ownedReserve0 = ((ownedLPAmount * totalReserve0) / lpTotalSupply);
        ownedReserve1 = ((ownedLPAmount * totalReserve1) / lpTotalSupply);
    }
    // end::_ownedReserves[]

    function _quoteExitTarget(
        address pair,
        address tokenOut,
        uint256 targetOutAmt,
        uint256 lpTotalSupply
    ) internal view returns(
        uint256 targetLPAmt
    ) {
        (
            uint256 knownTokenReserve,
            // address opposingToken_
            ,
            uint256 opposingTokenReserve
        ) = _correlatedReserves(tokenOut, pair);

        uint256 opTAmt = _quote(targetOutAmt, knownTokenReserve, opposingTokenReserve);

        targetLPAmt = _quoteDeposit(
            targetOutAmt,
            opTAmt,
            lpTotalSupply,
            knownTokenReserve,
            opposingTokenReserve
        );

    }

    function _correlatedReserves(
        address knownToken,
        address pair
    ) internal view returns(
        uint256 knownTokenReserve,
        address opposingToken_,
        uint256 opposingTokenReserve
    ) {
        address token0 = IUniswapV2Pair(pair).token0();
        // address token1 = IUniswapV2Pair(pair).token1();
        (uint256 res0, uint256 res1, ) = IUniswapV2Pair(pair).getReserves();

        (
            knownTokenReserve,
            opposingToken_,
            opposingTokenReserve
        ) = knownToken == token0
            ? (res0, IUniswapV2Pair(pair).token1(), res1)
            : (res1, token0, res0);
    }

    function _correlatedOwnedReserve(
        address knownToken,
        address pair,
        uint256 ownedPairBalance
    ) internal view returns(
        uint256 knownTokenReserve,
        uint256 knownTokenOwnedReserve,
        address opposingToken_,
        uint256 opposingTokenReserve,
        uint256 opposingTokenOwnedReserve
    ) {
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        (uint256 totalReserve0, uint256 totalReserve1, ) = IUniswapV2Pair(pair).getReserves();

        (
            uint256 ownedReserve0,
            uint256 ownedReserve1
        ) = UniV2Utils._ownedReserves(
            ownedPairBalance,
            IERC20(pair).totalSupply(),
            totalReserve0,
            totalReserve1
        );

        (
            knownTokenReserve,
            knownTokenOwnedReserve,
            opposingToken_,
            opposingTokenReserve,
            opposingTokenOwnedReserve
        ) = knownToken == token0
            ? (totalReserve0, ownedReserve0, token1, totalReserve1, ownedReserve1)
            : (totalReserve1, ownedReserve1, token0, totalReserve0, ownedReserve0);
        // (
        //     knownTokenReserve,
        //     knownTokenOwnedReserve,
        //     opposingToken_,
        //     opposingTokenReserve,
        //     opposingTokenOwnedReserve
        // ) = _correlatedOwnedReserve(
        //     knownToken,
        //     pair,
        //     IUniswapV2Pair(pair).token0(),
        //     IERC20(pair).totalSupply(),
        //     ownedPairBalance,
        //     totalReserve0,
        //     totalReserve1
        // );
    }

    function _correlatedOwnedReserve(
        address knownToken,
        // address pair,
        address token0,
        uint256 lpTokenTotalSupply,
        uint256 ownedPairBalance,
        uint256 totalReserve0,
        uint256 totalReserve1
    ) internal pure returns(
        uint256 knownTokenReserve,
        uint256 knownTokenOwnedReserve,
        // address opposingToken_,
        uint256 opposingTokenReserve,
        uint256 opposingTokenOwnedReserve
    ) {
        // address token0 = IUniswapV2Pair(pair).token0();
        // address token1 = IUniswapV2Pair(pair).token1();
        // (uint256 totalReserve0, uint256 totalReserve1, ) = IUniswapV2Pair(pair).getReserves();

        (
            uint256 ownedReserve0,
            uint256 ownedReserve1
        ) = UniV2Utils._ownedReserves(
            ownedPairBalance,
            // IERC20(pair).totalSupply(),
            lpTokenTotalSupply,
            totalReserve0,
            totalReserve1
        );

        (
            knownTokenReserve,
            knownTokenOwnedReserve,
            // opposingToken_,
            opposingTokenReserve,
            opposingTokenOwnedReserve
        ) = knownToken == token0
            ? (totalReserve0, ownedReserve0, totalReserve1, ownedReserve1)
            : (totalReserve1, ownedReserve1, totalReserve0, ownedReserve0);
    }

    /* --------------------------------- Deposit -------------------------------- */
    /**
     * @param uniV2Router Router to use for deposit.
     * @param token0 Token 0 of pair for deposit.
     * @param token1 Token 1 of pair for deposit.
     * @param token0Amount Amount of Token 0 for deposit.
     * @param token1Amount Amount of Token 1 for deposit.
     * @return lpTokenAmount The amount of LP token minted from deposit.
     */
    // tag::_deposit[]
    function _deposit(
        address uniV2Router,
        address token0,
        address token1,
        uint256 token0Amount,
        uint256 token1Amount
    ) internal returns (uint256 lpTokenAmount) {
        ( , , lpTokenAmount) = IUniswapV2Router02(uniV2Router).addLiquidity(
            token0,
            token1,
            token0Amount,
            token1Amount,
            1,
            1,
            address(this),
            DEADLINE
        );
        return lpTokenAmount;
    }
    // end::_deposit[]


    function _depositDirect(
        // address uniV2Router,
        address pair,
        address tokenA,
        address tokenB,
        uint256 tokenAAmount,
        uint256 tokenBAmount
    ) internal returns (uint256 lpTokenAmount) {
        IERC20(tokenA)._safeTransfer(pair, tokenAAmount);
        IERC20(tokenB)._safeTransfer(pair, tokenBAmount);
        lpTokenAmount = IUniswapV2Pair(pair).mint(address(this));
    }

    function _quoteDeposit(
        uint256 amount0Deposit,
        uint256 amount1Deposit,
        uint256 lpTotalSupply,
        uint256 lpReserve0,
        uint256 lpReserve1
    ) internal pure returns(uint256 lpAmount) {
         lpAmount = lpTotalSupply == 0
            ? BetterMath._sqrt((amount0Deposit * amount1Deposit)) - _MINIMUM_LIQUIDITY
            : BetterMath._min(
                (amount0Deposit * lpTotalSupply) / lpReserve0,
                (amount1Deposit * lpTotalSupply) / lpReserve1
            );
    }

    /* ---------------------------------- Swap ---------------------------------- */

    // tag::_swap[]
    function _swap(
        address uniswapRouter,
        address[] memory route,
        uint256 saleAmount
    ) internal returns (uint256 saleProceeds) {

        saleProceeds = IUniswapV2Router02(uniswapRouter).swapExactTokensForTokens(
            saleAmount,
            1,
            route,
            address(this),
            DEADLINE
        )[route.length - 1];

        require(saleProceeds > 0, "Error Swapping Tokens 2");
    }
    // end::_swap[]

    function _swapOwnTokens(
        IUniswapV2Pair pair,
        address soldToken,
        uint amountToSell
    ) internal returns(uint256 proceedsAmount) {
        // string memory sig = "_swapOwnTokens(IUniswapV2Pair,address,uint256)";
        // string memory name_ = type(UniV2Utils).name;
        // console.log(
        //     string.concat(
        //         name_, sig, "Entering Function"
        //     )
        // );

        (
            uint256 totalReserve0,
            uint256 totalReserve1,

        ) = pair.getReserves();


        address token0 = pair.token0();

        (
            uint256 soldTokenReserve,
            uint256 proceedsTokenReserve
        ) = soldToken == token0
            ? (totalReserve0, totalReserve1)
            : (totalReserve1, totalReserve0);

        proceedsAmount = _quoteSwapIn(amountToSell, soldTokenReserve, proceedsTokenReserve);

        (
            uint256 amount0Out,
            uint256 amount1Out
        ) = soldToken == token0
            ? (uint256(0), proceedsAmount)
            : (proceedsAmount, uint256(0));

        IERC20(soldToken)._safeTransfer(address(pair), amountToSell);
        pair.swap(amount0Out, amount1Out, address(this), new bytes(0));
        // console.log(
        //     string.concat(
        //         name_, sig, "Exiting Function"
        //     )
        // );
    }

    // tag::_quoteSwapOut[]
    function _quoteSwapOut(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) internal pure returns (uint amountIn) {
        // TODO refactor to custom error
        require(amountOut > 0, "UniV2Utils: INSUFFICIENT_OUTPUT_AMOUNT");
        // TODO refactor to custom error
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint numerator = (reserveIn * amountOut) * (1000);
        uint denominator = (reserveOut - amountOut) * (997);
        amountIn = (numerator / denominator) + (1);
    }
    // end::_quoteSwapOut[]

    // tag::_quoteSwapIn[]
    function _quoteSwapIn(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) internal pure returns (uint amountOut) {
        // TODO refactor to custom error
        // FIXME Uncomment
        require(amountIn > 0, "UniV2Utils: INSUFFICIENT_INPUT_AMOUNT");
        // TODO refactor to custom error
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint amountInWithFee = (amountIn * 997);
        uint numerator = (amountInWithFee * reserveOut);
        uint denominator = (reserveIn * 1000) + (amountInWithFee);
        amountOut = numerator / denominator;
    }
    // end::_quoteSwapIn[]

    /* -------------------------------- Withdraw -------------------------------- */

    // tag::_withdraw[]
    function _withdraw(
        IUniswapV2Pair pair,
        uint256 burnAmount
    ) internal returns (uint amount0, uint amount1) {
        pair.transfer(address(pair), burnAmount);
        return pair.burn(address(this));
    }
    // end::_withdraw[]

    // tag::_quoteWithdraw[]
    function _quoteWithdraw(
        uint256 lpWithdrawAmount,
        uint256 lpTotalSupply,
        uint256 token0Reserve,
        uint256 token1Reserve
    ) internal pure returns(uint256 token0Amount, uint256 token1Amount) {
        token0Amount = (lpWithdrawAmount * token0Reserve) / lpTotalSupply; // using balances ensures pro-rata distribution
        token1Amount = (lpWithdrawAmount * token1Reserve) / lpTotalSupply;
    }
    // end::_quoteWithdraw[]

    /* ------------------------------ Swap/Deposit ------------------------------ */

    // tag::_swapDeposit[]
    function _swapDeposit(
        address saleToken,
        address pair,
        uint256 saleTokenAmount,
        address uniV2Router
    ) internal returns(uint256 lpTokenAmount) {
        (
            uint256 saleTokenReserve,
            address opposingToken_,
            // uint256 opposingTokenReserve
        ) = _correlatedReserves(saleToken, pair);
        uint256 amountToSwap = UniV2Utils._quoteSwapDepositPurchase(saleTokenReserve, saleTokenAmount);
        uint256 saleTokenDeposit = (saleTokenAmount - amountToSwap);
        IERC20(saleToken)._safeIncreaseAllowance(uniV2Router, amountToSwap);

        address[] memory route = new address[](2);
        route[0] = saleToken;
        route[1] = opposingToken_;
        
        uint256 opposingTokenAmount = UniV2Utils._swap(
            address(uniV2Router),
            route,
            amountToSwap
        );

        IERC20(saleToken)._safeIncreaseAllowance(uniV2Router, saleTokenAmount);
        IERC20(opposingToken_)._safeIncreaseAllowance(uniV2Router, opposingTokenAmount);

        lpTokenAmount = UniV2Utils._deposit(
                uniV2Router,
                saleToken,
                // opoosingToken,
                opposingToken_,
                saleTokenDeposit,
                opposingTokenAmount
            );
    }
    // end::_swapDeposit[]

    function _swapDepositDirect(
        address saleToken,
        address pair,
        uint256 saleTokenAmount
        // address uniV2Router
    ) internal returns(uint256 lpTokenAmount) {
        // string memory sig = "_swapDepositDirect(address,address,uint256)";
        // string memory name_ = type(UniV2Utils).name;
        // console.log(
        //     string.concat(
        //         name_, sig, "Entering Function"
        //     )
        // );
        (
            uint256 saleTokenReserve,
            address opposingToken_,
            // uint256 opposingTokenReserve
        ) = _correlatedReserves(saleToken, pair);
        uint256 amountToSwap = UniV2Utils._quoteSwapDepositPurchase(saleTokenReserve, saleTokenAmount);
        uint256 saleTokenDeposit = (saleTokenAmount - amountToSwap);
        // IERC20(saleToken)._safeIncreaseAllowance(uniV2Router, amountToSwap);

        // address[] memory route = new address[](2);
        // route[0] = saleToken;
        // route[1] = opposingToken_;
        
        // uint256 opposingTokenAmount = UniV2Utils._swap(
        //     address(uniV2Router),
        //     route,
        //     amountToSwap
        // );
        
        // console.log(string.concat(name_, sig, "swapping"));
        uint256 opposingTokenAmount = UniV2Utils._swapOwnTokens(
            IUniswapV2Pair(pair),
            saleToken,
            saleTokenAmount
        );

        // IERC20(saleToken)._safeIncreaseAllowance(uniV2Router, saleTokenAmount);
        // IERC20(opposingToken_)._safeIncreaseAllowance(uniV2Router, opposingTokenAmount);

        // lpTokenAmount = UniV2Utils._deposit(
        //         uniV2Router,
        //         saleToken,
        //         // opoosingToken,
        //         opposingToken_,
        //         saleTokenDeposit,
        //         opposingTokenAmount
        //     );
        // console.log(string.concat(name_, sig, "depositing"));
        lpTokenAmount = UniV2Utils._depositDirect(
            pair,
            saleToken,
            opposingToken_,
            saleTokenDeposit,
            opposingTokenAmount
        );
        // console.log(
        //     string.concat(
        //         name_, sig, "Exiting Function"
        //     )
        // );
    }

    function _quoteSwapDepositPurchase(
        uint256 reserveIn,
        uint256 userIn
    ) internal pure returns (uint256 swapAmount_) {
      return BetterMath._sqrt(
        (
            reserveIn 
            * ((userIn * 3988000) + (reserveIn * 3988009)))
      ) - ((reserveIn * 1997)) / 1994;
    }

    function _quoteSwapDeposit(
        address saleToken,
        address pair,
        uint256 saleTokenAmount
    ) internal view returns(uint256 lpProceeds) {
        (
            uint256 saleTokenReserve,
            // address opposingToken_,
            ,
            uint256 opposingTokenReserve
        ) = _correlatedReserves(saleToken, pair);
        uint256 amountToSwap = UniV2Utils._quoteSwapDepositPurchase(saleTokenReserve, saleTokenAmount);
        uint256 saleTokenDeposit = saleTokenAmount - amountToSwap;
        uint256 opposingTokenDeposit = UniV2Utils._quoteSwapIn(
            amountToSwap,
            saleTokenReserve,
            opposingTokenReserve
        );

        lpProceeds = UniV2Utils._quoteDeposit(
            saleTokenDeposit,
            opposingTokenDeposit,
            IUniswapV2Pair(pair).totalSupply(),
            saleTokenReserve + amountToSwap,
            opposingTokenReserve - opposingTokenDeposit
        );
    }

    /* ------------------------------ Withdraw/Swap ----------------------------- */

    // tag::_withdrawalSwap[]
    /**
     * @custom:funcsig _withdrawalSwap(address, address, address, address, uint256)
     */
    function _withdrawalSwap(
        address uniswapRouter,
        address uniV2LP,
        address holder,
        address settlementToken,
        uint256 targetSettlementAmount
    ) internal returns(uint256 proceedsAmount) {
        // FIXME Figure out proper rounding down error when dealing minimla liquidity.
        // targetSettlementAmount += 1;
        // targetSettlementAmount -= targetSettlementAmount % 2;
        // string memory sig = "_withdrawalSwap(address,address,address,address,uint256)";
        // string memory name_ = type(UniV2Utils).name;
        {
        // console.log(
        //     string.concat(
        //         name_, sig, "Entering Function"
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "uniswapRouter = ",
        //         uniswapRouter._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "uniV2LP = ",
        //         uniV2LP._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "holder = ",
        //         holder._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "settlementToken = ",
        //         settlementToken._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "targetSettlementAmount = ",
        //         targetSettlementAmount._toString()
        //     )
        // );
        }
        uint256 lpAmountToWithdraw;
        {
            uint256 adjustedAmt = targetSettlementAmount._precision(18, 15);
            adjustedAmt += adjustedAmt % 2;
            adjustedAmt = adjustedAmt._precision(15, 18);
        // console.log(
        //     string.concat(
        //         name_, sig, "adjustedAmt = ",
        //         adjustedAmt._toString()
        //     )
        // );
        lpAmountToWithdraw = UniV2Utils._reduceExposureToTargetQuote(
            uniV2LP,
            holder,
            settlementToken,
            // targetSettlementAmount
            adjustedAmt
        );
        // lpAmountToWithdraw += lpAmountToWithdraw % 2;
        // console.log(
        //     string.concat(
        //         name_, sig, "lpAmountToWithdraw = ",
        //         lpAmountToWithdraw._toString()
        //     )
        // );
        }
            uint256 settlementTokenWithdrawalAmount;
            address saleToken_;
            uint256 saleTokenWithdrawalAmount;
            uint256 adjustedLPAmt = lpAmountToWithdraw._precision(18, 15);
            adjustedLPAmt += adjustedLPAmt % 2;
            adjustedLPAmt = adjustedLPAmt._precision(15, 18);
        {
        // console.log("Transfering LP Token.");
        // IERC20(uniV2LP)._safeTransfer(uniV2LP, lpAmountToWithdraw);
        // FIXME UNDO this with fix.
        IERC20(uniV2LP)._safeTransfer(uniV2LP, adjustedLPAmt);
        // console.log("Transfered LP Token.");
        // console.log("Burning LP Token.");
        (uint amount0, uint amount1) = IUniswapV2Pair(uniV2LP).burn(address(this));
        // console.log("Burned LP Token.");
        // console.log("Correlating amounts");
        (
            settlementTokenWithdrawalAmount,
            saleToken_,
            saleTokenWithdrawalAmount
        ) = UniV2Utils._correlateAmount(
            uniV2LP,
            settlementToken,
            amount0,
            amount1
        );
        // console.log(
        //     string.concat(
        //         name_, sig, "settlementTokenWithdrawalAmount = ",
        //         settlementTokenWithdrawalAmount._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "saleTokenWithdrawalAmount = ",
        //         saleTokenWithdrawalAmount._toString()
        //     )
        // );
        }
        // console.log("swapping");
        {
        address[] memory route = new address[](2);
        route[0] = saleToken_;
        route[1] = settlementToken;
        // console.log("approving");
        IERC20(saleToken_).approve(uniswapRouter, saleTokenWithdrawalAmount);
        // console.log("approved");
        // console.log("swapping");
        uint256 saleProceedsAmount = UniV2Utils._swap(
            address(uniswapRouter),
            route,
            saleTokenWithdrawalAmount
        );
        // console.log(
        //     string.concat(
        //         name_, sig, "saleProceedsAmount = ",
        //         saleProceedsAmount._toString()
        //     )
        // );
        // console.log("swapped");
        proceedsAmount = settlementTokenWithdrawalAmount + saleProceedsAmount;
        // console.log(
        //     string.concat(
        //         name_, sig, "proceedsAmount = ",
        //         proceedsAmount._toString()
        //     )
        // );
        }
        // console.log(
        //     string.concat(
        //         name_, sig, "targetSettlementAmount = ",
        //         targetSettlementAmount._toString()
        //     )
        // );
        require(proceedsAmount >= targetSettlementAmount, "Proceeds do NOT meet settlement target.");
    }
    // end::_withdrawalSwap[]

    // tag::_quoteWithdrawalSwap[]
    /**
     * @custom:funcsig _quoteWithdrawalSwap(uint256, uint256, uint256, uint256)
     */
    function _quoteWithdrawalSwap(
        uint256 ownedLPAmount,
        uint256 lpTotalSupply,
        uint256 indexedTokenTotalReserve,
        uint256 opposingTokenTotalReserve
    ) internal pure returns(uint256 exitAmount) {

        (
            uint256 indexedTokenOwnedReserve,
            uint256 opposingTokenOwnedReserve
        ) = UniV2Utils._ownedReserves(
            ownedLPAmount,
            lpTotalSupply,
            indexedTokenTotalReserve,
            opposingTokenTotalReserve
        );
    
        exitAmount = UniV2Utils._quoteExit(
            opposingTokenTotalReserve,
            opposingTokenOwnedReserve,
            indexedTokenTotalReserve,
            indexedTokenOwnedReserve
        );
    }
    // end::_quoteWithdrawalSwap[]

    function _quoteWithdrawalSwap(
        address exitToken,
        address pair
    ) internal view returns(uint256 exitAmount) {

        (
            uint256 indexedTokenTotalReserve,
            uint256 indexedTokenOwnedReserve,
            ,
            uint256 opposingTokenTotalReserve,
            uint256 opposingTokenOwnedReserve
        ) = UniV2Utils._correlatedOwnedReserve(
            exitToken,
            pair,
            IERC20(pair).balanceOf(address(this))
        );
    
        exitAmount = UniV2Utils._quoteExit(
            opposingTokenTotalReserve,
            opposingTokenOwnedReserve,
            indexedTokenTotalReserve,
            indexedTokenOwnedReserve
        );
    }

    function _quoteWithdrawalSwap(
        address exitToken,
        address pair,
        uint256 lpTokenBalance
    ) internal view returns(uint256 exitAmount) {

        (
            uint256 indexedTokenTotalReserve,
            uint256 indexedTokenOwnedReserve,
            ,
            uint256 opposingTokenTotalReserve,
            uint256 opposingTokenOwnedReserve
        ) = UniV2Utils._correlatedOwnedReserve(
            exitToken,
            pair,
            // IERC20(pair).balanceOf(address(this))
            lpTokenBalance
        );
    
        exitAmount = UniV2Utils._quoteExit(
            opposingTokenTotalReserve,
            opposingTokenOwnedReserve,
            indexedTokenTotalReserve,
            indexedTokenOwnedReserve
        );
    }

    // tag::_quoteExit[]
    function _quoteExit(
        uint256 saleTokenTotalReserve,
        uint256 saleTokenOwnedReserve,
        uint256 exitTokenTotalReserve,
        uint256 exitTokenOwnedReserve
    ) internal pure returns(uint256 exitAmount) {
        uint256 saleProceeds = UniV2Utils._quoteSwapIn(
            saleTokenOwnedReserve,
            saleTokenTotalReserve - saleTokenOwnedReserve,
            exitTokenTotalReserve - exitTokenOwnedReserve
        );
        exitAmount = exitTokenOwnedReserve + saleProceeds;
    }
    // end::_quoteExit[]

    // tag::_reduceExposureToTargetQuote[]
    /**
     * @param uniV2LP Uniswap V2 liquidity pool upon which the WITHDRAW_SWAP operation will be completed.
     * @param holder LP holder that will be executing the WITHDRAW_SWAP operation.
     * @param settlementToken Token to setlle exit from providing liquidity.
     * @param targetSettlementAmount Desired amount of `settlementToken` to extract from liquidity.
     * @return lpAmountToWithdraw Amount of LP token to burn such that SWAP of NOT `settlementToken` will result in holding `targetSettlementAmount` when combined with amount from WITHDRAW action.
     */
    function _reduceExposureToTargetQuote(
        address uniV2LP,
        address holder,
        address settlementToken,
        uint256 targetSettlementAmount
    ) internal view returns (
        uint256 lpAmountToWithdraw
    ) {
        // string memory sig = "_reduceExposureToTargetQuote(address,address,address,uint256)";
        // string memory name_ = type(UniV2Utils).name;
        {
        // console.log(
        //     string.concat(
        //         name_, sig, "Entering Function"
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "uniV2LP = ",
        //         uniV2LP._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "holder = ",
        //         holder._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "settlementToken = ",
        //         settlementToken._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "targetSettlementAmount = ",
        //         targetSettlementAmount._toString()
        //     )
        // );
        }
        IUniswapV2Pair pair = IUniswapV2Pair(uniV2LP);
        uint256 lpAmount;
        uint reserveA;
        uint reserveB;
        address tokenA;
        {
            // @icmoore: stack too deep
            (uint reserve0, uint reserve1,) = pair.getReserves();
            address token0 = pair.token0();
            address token1 = pair.token1();
            (tokenA,) = _sortTokens(token0, token1);
            (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
        }
        {
        // console.log(
        //     string.concat(
        //         name_, sig, "reserveA = ",
        //         reserveA._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "reserveB = ",
        //         reserveB._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "tokenA = ",
        //         tokenA._toString()
        //     )
        // );
        }
        {
            // @icmoore: stack too deep
            (uint reserveI, uint reserveO) = settlementToken == tokenA ? (reserveA, reserveB) : (reserveB, reserveA);
            uint256 supply = pair.totalSupply();

            if (reserveI > targetSettlementAmount) {
                lpAmount = _calcLpSettlement(reserveI, reserveO, targetSettlementAmount, supply);       
            } else  {
                lpAmount = 0;
            } 
        }
        // console.log(
        //     string.concat(
        //         name_, sig, "lpAmount = ",
        //         lpAmount._toString()
        //     )
        // );
        lpAmountToWithdraw = lpAmount > pair.balanceOf(holder) ? 0 : lpAmount;
        {
        // console.log(
        //     string.concat(
        //         name_, sig, "pair.balanceOf(holder) = ",
        //         pair.balanceOf(holder)._toString()
        //     )
        // );
        // console.log(
        //     string.concat(
        //         name_, sig, "lpAmountToWithdraw = ",
        //         lpAmountToWithdraw._toString()
        //     )
        // );
        }
    }
    // end::_reduceExposureToTargetQuote[]

    function _calcLpSettlement(
        uint reserveI,
        uint reserveO,
        uint256 targetSettlementAmount,
        uint256 supply
    ) internal pure returns (uint256 LpSettlement) { 
        uint a1 = (reserveO * reserveI) / supply;
        uint a2 = supply;
        uint b = __partB(reserveI, reserveO, targetSettlementAmount, supply);
        uint c = (targetSettlementAmount * reserveO);

        uint Lp1;
        uint Lp2;
        uint Lp3;
        {
            Lp1 = (b * a2);
            Lp2 = (a2 * BetterMath._sqrt((b * b) - (BetterMath.mul512(a1, (c * 4)).div256(a2))));
            Lp3 = (a1 * 2);
        }

        LpSettlement = ((Lp1 - Lp2)) / (Lp3);
    }

    function __partB(
        uint reserveI,
        uint reserveO,
        uint256 targetSettlementAmount,
        uint256 supply
    ) private pure returns (
        uint b
    ) { 
        uint gamma = 997;

        uint b1 = (targetSettlementAmount * reserveO) * (1000);
        uint b2 = ((targetSettlementAmount * gamma) * (reserveO));
        uint b3 = ((reserveO * reserveI) * (1000));
        uint b4 = (reserveO * reserveI) * (gamma);
        uint b5 = (supply * 1000);

        b = (b1 - b2 + b3 + b4) / b5;
    }

}