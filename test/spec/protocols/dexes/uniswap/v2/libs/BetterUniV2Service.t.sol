// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/test/BetterTest.sol";
import "thefactory/utils/math/BetterMath.sol";
import "thefactory/collections/Collections.sol";
import "thefactory/tokens/erc20/ERC20Test.sol";
import "thefactory/protocols/tokens/wrappers/weth/9/types/WETH9.sol";
import "thefactory/protocols/dexes/uniswap/v2/types/UniV2FactoryStub.sol";
import "thefactory/protocols/dexes/uniswap/v2/types/UniV2Router02Stub.sol";
// import "thefactory/protocols/dexes/uniswap/v2/libs/UniV2Utils.sol";
import "thefactory/protocols/dexes/uniswap/v2/libs/BetterUniV2Utils.sol";
import "thefactory/protocols/dexes/uniswap/v2/libs/BetterUniV2Service.sol";

contract BetterUniV2ServiceTest is BetterTest {

    using BetterMath for uint256;
    using BetterUniV2Utils for uint256;
    using BetterUniV2Service for IUniswapV2Pair;
    // using UniV2Utils for uint256;

    address market = vm.addr(uint256(bytes32(bytes("market"))));

    IWETH weth9;
    // IUniswapV2Router02 router;
    IUniswapV2Factory uniV2Factory;
    IUniswapV2Router02 uniV2outer;

    IERC20OperatableMintable token0;
    IERC20OperatableMintable token1;

    IUniswapV2Pair basePool;

    // uint256 subjectIndexLPRes;
    // uint256 rcIndexLpRes;

    function setUp() public {
        weth9 = new WETH9();
        uniV2Factory = IUniswapV2Factory(
            address(new UniV2FactoryStub(address(this)))
        );
        uniV2outer = IUniswapV2Router02(
            address(new UniV2Router02Stub(
                address(uniV2Factory),
                address(weth9)
            ))
        );
        token0 =  new ERC20OpertableMintableTargetStub(
          "Test Token",
          "TT1",
          18,
          0,
          address(this)
        );
        declareUsed(address(token0));
        token0.setOperator(address(this), true);
        token1 =  new ERC20OpertableMintableTargetStub
        {salt: keccak256(abi.encode(address(token0)))}
        (
          "Test Reserve CCurrency",
          "TRC1",
          18,
          0,
          address(this)
        );
        declareUsed(address(token1));
        token1.setOperator(address(this), true);
        basePool = IUniswapV2Pair(uniV2Factory.createPair(
            address(token0),
            address(token1)
        ));
        // uint256 lpRes = 
        // console.log("lpRes =  %s", lpRes);
        // lpRes = lpRes._safeHalf();
        // subjectIndexLPRes = lpRes;
        // rcIndexLpRes = lpRes;
        // console.log("subjectIndexLPRes =  %s", subjectIndexLPRes);
        // console.log("rcIndexLpRes =  %s", rcIndexLpRes);
    }

    function test_depositDirect(
        uint112 token0Amt,
        uint112 token1Amt
    ) public {
        // 142467277
        token0Amt = uint112(bound(
            token0Amt,
            10000,
            type(uint112).max
        ));
        token1Amt = uint112(bound(
            token1Amt,
            10000,
            type(uint112).max
        ));
        uint256 depositEstimate = BetterUniV2Utils._calcDeposit(
            token0Amt,
            token1Amt,
            0,
            0,
            0
        );
        token0.mint(token0Amt, address(this));
        token1.mint(token1Amt, address(this));
        uint256 depositProceeds = basePool._depositDirect(
            token0,
            token1,
            token0Amt,
            token1Amt
        );
        assertEq(
            depositProceeds,
            basePool.balanceOf(address(this))
        );
        assertEq(
            depositEstimate,
            basePool.balanceOf(address(this))
        );
        assertEq(
            depositEstimate,
            depositProceeds
        );
    }

    function test_swapDirect(
        uint112 amount0In,
        uint112 token0DepositAmt,
        uint112 token1depositAmt
    ) public {
        console.log("type(uint112).max = %s", type(uint112).max);
        token0DepositAmt = uint112(bound(
            token0DepositAmt,
            ONE_WAD,
            type(uint112).max / 2
        ));
        token1depositAmt = uint112(bound(
            token1depositAmt,
            ONE_WAD,
            type(uint112).max / 2
        ));
        token0.mint(token0DepositAmt, address(basePool));
        token1.mint(token1depositAmt, address(basePool));
        basePool.mint(address(this));
        console.log("lpBal = %s", basePool.balanceOf(address(this)));
        console.log("token 0 lpBal = %s", token0.balanceOf(address(basePool)));
        console.log("token 1 lpBal = %s", token1.balanceOf(address(basePool)));
        amount0In = uint112(bound(
            amount0In,
            ONE_WAD / 2,
            (token0DepositAmt / 2)
        ));
        console.log("amount0In = %s", amount0In);
        uint256 amount1Out = BetterUniV2Utils._calcSaleProceeds(
            amount0In,
            token0.balanceOf(address(basePool)),
            token1.balanceOf(address(basePool))
        );
        console.log("amount1Out = %s", amount1Out);
        token0.mint(amount0In, address(this));
        // basePool.swap(
        //     0,
        //     amount1Out,
        //     address(this),
        //     ""
        // );
        uint256 saleProceeds = basePool._swapDirect(
            token0,
            amount0In
        );
        // assertEq(
        //     saleProceeds,
        //     amount1Out
        // );
        assertEq(
            saleProceeds,
            token1.balanceOf(address(this))
        );
    }

    function test_swapDepositDirect(
        uint112 amount0In,
        uint112 token0DepositAmt,
        uint112 token1depositAmt
    ) public {
        console.log("type(uint112).max = %s", type(uint112).max);
        token0DepositAmt = uint112(bound(
            token0DepositAmt,
            TENK_WAD,
            type(uint112).max / 2
        ));
        token1depositAmt = uint112(bound(
            token1depositAmt,
            TENK_WAD,
            type(uint112).max / 2
        ));
        token0.mint(token0DepositAmt, address(basePool));
        token1.mint(token1depositAmt, address(basePool));
        basePool.mint(address(this));
        console.log("lpBal = %s", basePool.balanceOf(address(this)));
        basePool.transfer(market, basePool.balanceOf(address(this)));
        console.log("token 0 lpBal = %s", token0.balanceOf(address(basePool)));
        console.log("token 1 lpBal = %s", token1.balanceOf(address(basePool)));
        amount0In = uint112(bound(
            amount0In,
            ONE_WAD / 2,
            (token0DepositAmt / 4)
        ));
        console.log("amount0In = %s", amount0In);
        basePool.transfer(address(market), basePool.balanceOf(address(this)));
        token0.mint(amount0In, address(this));
        uint256 lpProceeds = basePool._swapDepositDirect(
            token0,
            amount0In,
            token0.balanceOf(address(basePool)),
            token1
        );
        // assertLe(
        //     token0.balanceOf(address(this)),
        //     1
        // );
        assertEq(
            lpProceeds,
            basePool.balanceOf(address(this))
        );
        // assertTrue(false);
    }

}