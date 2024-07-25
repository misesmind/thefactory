// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC5115Target.sol";
import {UniV2Utils} from "../../../protocols/dexes/uniswap/v2/libs/UniV2Utils.sol";
import "../../../protocols/dexes/uniswap/v2/interfaces/IUniswapV2Pair.sol";
import "../../../protocols/dexes/uniswap/v2/interfaces/IUniswapV2Factory.sol";
import "../../../protocols/dexes/uniswap/v2/interfaces/IUniswapV2Router02.sol";
import "../../../protocols/dexes/uniswap/v2/aware/types/UniV2AwareStorage.sol";
// import "contracts/daosys/core/math/Math.sol";
// import {SafeERC20} from "contracts/tokens/erc20/libs/utils/SafeERC20.sol";
// import "contracts/daosys/Logged.sol";
import "../../../utils/primitives/Primitives.sol";
// import "contracts/daosys/core/primitives/UInt.sol";

// import "hardhat/console.sol";
// import "forge-std/console.sol";
// import "forge-std/console2.sol";

contract ERC5115UniV2Stub
is
ERC5115Target, UniV2AwareStorage
{

    using Address for address;
    using UInt for uint256;
    using AddressSetLayout for AddressSet;
    using SafeERC20 for IERC20;

    constructor(
        address yieldToken_
    ) {
        // address token0 = IUniswapV2Pair(yieldToken_).token0();
        // address token1 = IUniswapV2Pair(yieldToken_).token1();
        // require(
        //     yieldToken == IUniswapV2Factory(
        //         IUniswapV2Pair(yieldToken).factory()
        //     ).getPair(token0, token1)
        // );
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = yieldToken_;
        // tokensIn[1] = token0;
        // tokensIn[2] = token1;
        // address[] memory tokensOut = new address[](3);
        // tokensOut[0] = yieldToken_;
        // tokensOut[1] = token0;
        // tokensOut[2] = token1;
        address[] memory tokensOut = new address[](1);
        tokensOut[0] = yieldToken_;
        // tokensOut[0] = token0;
        // tokensOut[1] = token1;
        _init5115(
            yieldToken_,
            tokensIn,
            tokensOut
        );
    }

    // function _contName() internal pure virtual override(Logged, ERC5115Target) returns(string memory) {
    //     return type(ERC5115UniV2Stub).name;
    // }

    /**
     * @notice execute a minting of shares on behalf of given address
     * @param shareAmount quantity of shares to mint
     * @param receiver recipient of shares resulting from deposit
     * @return assetAmount quantity of assets to deposit
     */
    function _mint(
        uint256 shareAmount,
        address receiver
    ) internal virtual override returns (uint256 assetAmount) {
        return ERC4626Storage._mint(
            shareAmount,
            receiver
        );
    }

    function _deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut,
        bool depositFromInternalBalance
    ) internal virtual override returns (uint256 amountSharesOut) {
        // string memory sig = "_deposit(address,address,uint256,uint256,bool)";
        // console.log(
        //     string.concat(
        //         _contName(), ":",
        //         sig, "::"
        //         " Entering Function"
        //     )
        // );
        // _log(type(ERC5115UniV2Stub).name, sig, "Entering Function");
        require(depositFromInternalBalance == false);
        uint256 preDepositReserve = IUniswapV2Pair(address(_yieldToken())).balanceOf(address(this));

        if(tokenIn == address(_yieldToken())) {
            IERC20(tokenIn)._safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
        }
        if(
            _erc5115().tokensIn._contains(address(tokenIn))
            && tokenIn != address(_yieldToken())
        ) {
            IERC20(tokenIn)._safeTransferFrom(msg.sender, address(this), amountTokenToDeposit);
            IERC20(tokenIn).approve(address(_uniV2Router()), amountTokenToDeposit);
            UniV2Utils._swapDeposit(
                tokenIn,
                address(_yieldToken()),
                amountTokenToDeposit,
                address(_uniV2Router())
            );
        }
        uint256 postDepositReserve = IUniswapV2Pair(address(_yieldToken())).balanceOf(address(this));
        uint256 reserveDiff = postDepositReserve - preDepositReserve;
        // _log(type(ERC5115UniV2Stub).name, sig, string.concat("reserveDiff = ", reserveDiff._toString()));
        // amountSharesOut = _previewDeposit(address(_yieldToken()), reserveDiff);
        // _quotePreviewDeposit
        amountSharesOut = _quotePreviewDeposit(address(_yieldToken()), reserveDiff, preDepositReserve);
        // _log(type(ERC5115UniV2Stub).name, sig, string.concat("amountSharesOut = ", amountSharesOut._toString()));
        require(minSharesOut <= amountSharesOut);
        // _log(type(ERC5115UniV2Stub).name, 
        //     sig,
        //     string.concat(
        //         "amountSharesOut = ",
        //         amountSharesOut._toString()
        //     )
        // );
        // _log(type(ERC5115UniV2Stub).name, sig, string.concat("Minting shares ", amountSharesOut._toString(), " to ", receiver._toString()));
        ERC4626Storage._mintShares(amountSharesOut, receiver);
    }

    function _redeem(
        // receiver
        address ,
        uint256 amountSharesToRedeem,
        address tokenOut,
        uint256 minTokenOut,
        // burnFromInternalBalance
        bool 
    ) internal virtual override returns (uint256 amountTokenOut) {
        // string memory sig = "_redeem(address,uint256,address,uint256,bool)";
        // string memory name_ = type(ERC5115UniV2Stub).name;
        // _log(name_, sig, "Entering Function");
        // // _log(name_, sig, string.concat("receiver = ", receiver._toString()));
        // _log(name_, sig, string.concat("amountSharesToRedeem = ", amountSharesToRedeem._toString()));
        // _log(name_, sig, string.concat("tokenOut = ", tokenOut._toString()));
        // _log(name_, sig, string.concat("minTokenOut = ", minTokenOut._toString()));
        // ERC4626Storage._burnShares(amountSharesToRedeem, msg.sender);
        // // amountTokenOut = _previewRedeem(tokenOut, amountSharesToRedeem);
        // amountTokenOut = _previewRedeem(address(_yieldToken()), amountSharesToRedeem);
        // _log(name_, sig, string.concat("amountTokenOut = ", amountTokenOut._toString()));
        // _log(name_, sig, "Checking IF tokenOut IS yieldToken");
        // if(tokenOut == address(_yieldToken())) {
        //     _log(name_, sig, "tokenOut IS yieldToken");
        //     require(minTokenOut <= amountTokenOut);
        //     IERC20(tokenOut)._safeTransferFrom(address(this), msg.sender, amountTokenOut);
        // }
        //     _log(name_, sig, "Checking IF tokenOut IS NOT yieldToken");
        // if(
        //     _erc5115().tokensOut._contains(address(tokenOut))
        //     && tokenOut != address(_yieldToken())
        // ) {
        //     _log(name_, sig, "tokenOut IS NOT yieldToken");
        //     // UniV2Utils._withdrawalSwap(
        //     //     address(_uniV2Router()),
        //     //     address(_yieldToken()),
        //     //     address(this),
        //     //     tokenOut,
        //     //     amountTokenOut
        //     // );
        //     (uint amount0, uint amount1) = UniV2Utils._withdraw(
        //         IUniswapV2Pair(address(_yieldToken())),
        //         amountTokenOut
        //     );

        //     UniV2Utils._swap(
        //         address(uniV2Router),
        //         route,
        //         amountToSwap
        //     );
        //     IERC20(tokenOut)._safeTransfer(msg.sender, amountTokenOut);
        // }
    }

    function _quotePreviewDeposit(
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 prevRes
    ) internal view virtual returns(uint256 amountSharesOut) {
        // string memory sig = "_quotePreviewDeposit(address,uint256,uint256)";
        // _log(type(ERC5115UniV2Stub).name, 
        //     sig,
        //     string.concat(
        //         "tokenIn = ",
        //         tokenIn._toString()
        //     )
        // );
        // _log(type(ERC5115UniV2Stub).name, 
        //     sig,
        //     string.concat(
        //         "amountTokenToDeposit = ",
        //         amountTokenToDeposit._toString()
        //     )
        // );
        // return _previewDeposit(amountTokenToDeposit);
        // _log(type(ERC5115UniV2Stub).name, sig, "Checking if tokenIn is yieldToken");
        if(tokenIn == address(_yieldToken())) {
            // _log(type(ERC5115UniV2Stub).name, sig, "tokenIn IS yieldToken");
            uint256 depositQuote = _convertToShares(amountTokenToDeposit, prevRes);
            // _log(type(ERC5115UniV2Stub).name, 
            //     sig,
            //     string.concat(
            //         "deposit preview is ",
            //         depositQuote._toString()
            //     )
            // );
            // return _previewDeposit(amountTokenToDeposit);
            return depositQuote;
        }
        if(
            _erc5115().tokensIn._contains(address(tokenIn))
            && tokenIn != address(_yieldToken())
        ) {
            uint256 depositQuote = UniV2Utils._quoteSwapDeposit(tokenIn, address(_yieldToken()), amountTokenToDeposit);
            // return _previewDeposit(depositQuote);
            return _convertToShares(depositQuote, prevRes);
        }

    }

    function _previewDeposit(
        address tokenIn,
        uint256 amountTokenToDeposit
    ) internal view virtual override returns(uint256 amountSharesOut) {
        // string memory sig = "_previewDeposit(address, uint256)";
        // _log(type(ERC5115UniV2Stub).name, 
        //     sig,
        //     string.concat(
        //         "tokenIn = ",
        //         tokenIn._toString()
        //     )
        // );
        // _log(type(ERC5115UniV2Stub).name, 
        //     sig,
        //     string.concat(
        //         "amountTokenToDeposit = ",
        //         amountTokenToDeposit._toString()
        //     )
        // );
        // return _previewDeposit(amountTokenToDeposit);
        // _log(type(ERC5115UniV2Stub).name, sig, "Checking if tokenIn is yieldToken");
        if(tokenIn == address(_yieldToken())) {
            // _log(type(ERC5115UniV2Stub).name, sig, "tokenIn IS yieldToken");
            uint256 depositQuote = _previewDeposit(amountTokenToDeposit);
            // _log(type(ERC5115UniV2Stub).name, 
            //     sig,
            //     string.concat(
            //         "deposit preview is ",
            //         depositQuote._toString()
            //     )
            // );
            // return _previewDeposit(amountTokenToDeposit);
            return depositQuote;
        }
        if(
            _erc5115().tokensIn._contains(address(tokenIn))
            && tokenIn != address(_yieldToken())
        ) {
            uint256 depositQuote = UniV2Utils._quoteSwapDeposit(tokenIn, address(_yieldToken()), amountTokenToDeposit);
            return _previewDeposit(depositQuote);
        }
    }

    function _previewRedeem(
        address tokenOut,
        uint256 amountSharesToRedeem
    ) internal view virtual override returns(uint256 amountTokenOut) {
        // string memory sig = "_previewRedeem(address,uint256)";
        // string memory name_ = type(ERC5115UniV2Stub).name;
        // _log(name_, sig, "Entering Function");
        // _log(name_, sig, string.concat("amountSharesToRedeem = ", amountSharesToRedeem._toString()));
        uint256 lpAmount = _previewRedeem(amountSharesToRedeem);
        // _log(name_, sig, string.concat("lpAmount = ", lpAmount._toString()));
        if(tokenOut == address(_yieldToken())) {
            return lpAmount;
        }
        if(
            _erc5115().tokensOut._contains(address(tokenOut))
            && tokenOut != address(_yieldToken())
        ) {
            // uint256 lpAmount = _previewRedeem(amountSharesToRedeem);
            uint256 withdrawalQuote = UniV2Utils._quoteWithdrawalSwap(tokenOut, address(_yieldToken()), lpAmount);
            // _log(name_, sig, string.concat("withdrawalQuote = ", withdrawalQuote._toString()));
            return _previewRedeem(withdrawalQuote);
        }
    }

}