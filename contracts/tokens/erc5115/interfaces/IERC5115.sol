// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "thefactory/tokens/erc20/interfaces/IERC20.sol";

/**
 * @title IStandardizedYield ERC20 Vault extension
 * @notice Generic Yield Generating Pool
 * @notice We will first introduce Generic Yield Generating Pool (GYGP),
 * @notice a model to describe most yield generating mechanisms in DeFi.
 * @notice In every yield generating mechanism, there is a pool of funds, whose value is measured in assets.
 * @notice There are a number of users who contribute liquidity to the pool,
 * @notice in exchange for shares of the pool, which represents units of ownership of the pool.
 * @notice Over time, the value (measured in assets) of the pool grows, such that each share is worth
 * @notice more assets over time. The pool could earn a number of reward tokens over time,
 * @notice which are distributed to the users according to some logic (for example,
 * @notice proportionally the number of shares).
 */
interface IERC5115 {

    error PreTransferDisabled();

    event Deposit(
        address indexed caller,
        address indexed receiver,
        address indexed tokenIn,
        uint256 amountDeposited,
        uint256 amountSyOut
    );

    event Redeem(
        address indexed caller,
        address indexed receiver,
        address indexed tokenOut,
        uint256 amountSyToRedeem,
        uint256 amountTokenOut
    );

    // tag::deposit[]
    /**
     * @custom:sig deposit(address,address,uint256,uint256,bool)
     */
    function deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut,
        bool depositFromInternalBalance
    ) external returns(uint256 amountSharesOut);
    // end::deposit[]

    // tag::redeem[]
    /**
     * @custom:sig redeem(address,uint256,address,uint256,bool)
     */
    function redeem(
        address receiver,
        uint256 amountSharesToRedeem,
        address tokenOut,
        uint256 minTokenOut,
        bool burnFromInternalBalance
    ) external returns(uint256 amountTokenOut);
    // end::redeem[]

    // tag::exchangeRate[]
    /**
     * @dev This method updates and returns the latest exchange rate, which is the exchange rate from SY token amount
     * @dev into asset amount, scaled by a fixed scaling factor of 1e18.
     * @custom:sig exchangeRate()
     */
    function exchangeRate() external view returns(uint256 res);
    // end::exchangeRate[]

    // tag::getTokensIn[]
    /**
     * @custom:sig getTokensIn()
     */
    function getTokensIn() external view returns(address[] memory res);
    // end::getTokensIn[]

    // tag::getTokensOut[]
    /**
     * @custom:sig getTokensOut()
     */
    function getTokensOut() external view returns(address[] memory res);
    // end::getTokensOut[]

    // tag::yieldToken[]
    /**
     * @notice This read-only method returns the underlying yield-bearing token (representing a GYGP) address.
     * @notice MUST return a token address that conforms to the ERC-20 interface, or zero address
     * @notice MUST NOT revert.
     * @notice MUST reflect the exact underlying yield-bearing token address if the SY token is a wrapped token.
     * @notice MAY return 0x or zero address if the SY token is natively implemented, and not from wrapping.
     * @custom:sig yieldToken()
     */
    function yieldToken() external view returns(address);
    // end::yieldToken[]

    // tag::previewDeposit[]
    /**
     * @custom:sig previewDeposit(address,uint256)
     */
    function previewDeposit(
        address tokenIn,
        uint256 amountTokenToDeposit
    ) external view returns(uint256 amountSharesOut);
    // end::previewDeposit[]

    // tag::previewRedeem[]
    /**
     * @custom:sig previewRedeem(address,uint256)
     */
    function previewRedeem(
        address tokenOut,
        uint256 amountSharesToRedeem
    ) external view returns(uint256 amountTokenOut);
    // end::previewRedeem[]
    
}