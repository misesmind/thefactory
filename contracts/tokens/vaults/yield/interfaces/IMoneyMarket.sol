// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc20/interfaces/IERC20.sol";
import "thefactory/tokens/erc6909/interfaces/IERC6909MetadataEnumerated.sol";

/**
 * @notice Extends ERC6909 to behave similar to ERC5115.
 * @notice Unifies deposit, withdraw, and swap operations.
 * @notice Token IDs are intended to map to tokens and pool properties,
 * @notice  this allows for complex pool definitions.
 * @notice If `yieldSource` IS a token, it MUST be included in `getTokensIn` and `getTokensOut`.
 * @notice If `yieldSource` IS a token, MUST map to token ID 0.
 * @notice If `yieldSource` is NOT a token, it MUST NOT be included in `getTokensIn` and `getTokensOut`.
 * @notice If `yieldSource` IS NOT a token, token ID 0 MUST NOT be mapped to ANY token.
 * @notice Uses adaptor contracts to conform with other token types.
 * @notice Adaptors hold this token and expose another token interface.
 * @notice Can be implemented as a DEX pool.
 */
interface IMoneyMarket is IERC6909MetadataEnumerated {

    /**
     * @notice MAY BE a LP token, vault (i.e. CDP, MDP), and/or protocol.
     * @return source The address this contract interacts with as the primary yield bearing position.
     */
    function yieldSource()
    external view returns(address source);

    // /**
    //  * @notice MAY return self to indicate embedded logic.
    //  * @notice Adaptor will typically be used with DELEGATECALL.
    //  * @return sourceAdaptor_ The contract used to interact with the `yieldSource()`.
    //  */
    // function sourceAdaptor()
    // external view returns(address sourceAdaptor_);

    /**
     * @param tokenId A token ID for which to query the adaptor contract.
     * @return adaptor The adaptor address for the `tokenId`.
     */
    function adaptorOf(uint256 tokenId)
    external view returns(address adaptor);

    /**
     * @dev Token ID 0 is invalid, reserve to indicate adaptor non-existence.
     * @dev `tokenId` 1 is reserved for a ERC5115 adaptor for the yieldToken().
     * @param adaptor The adaptor address for which to query the tokenId.
     * @return tokenId A token ID for the `adaptor`.
     */
    function tokenIdOf(address adaptor)
    external view returns(uint256 tokenId);

    // tag::getTokensIn[]
    /**
     * @custom:sig getTokensIn()
     */
    function getTokensIn()
    external view returns(address[] memory res);
    // end::getTokensIn[]

    // tag::getTokensOut[]
    /**
     * @custom:sig getTokensOut()
     */
    function getTokensOut()
    external view returns(address[] memory res);
    // end::getTokensOut[]

    // // tag::exchangeRate[]
    // /**
    //  * @dev This method updates and returns the latest exchange rate, which is the exchange rate from SY token amount
    //  * @dev into asset amount, scaled by a fixed scaling factor of 1e18.
    //  * @custom:sig exchangeRate()
    //  */
    // function exchangeRate(address tokenIn, address tokenOut)
    // external view returns(uint256 res);
    // // end::exchangeRate[]

    // function exchangeRateTokenToToken(address tokenIn, address tokenOut)
    // external view returns(uint256 res);

    // function exchangeRateIdToId(uint256 tokenIdIn, uint256 tokenIdOut)
    // external view returns(uint256 res);

    // function exchangeRateTokenToId(address tokenIn, uint256 tokenIdOut)
    // external view returns(uint256 res);

    // function exchangeRateIdToToken(uint256 tokenIdIn, address tokenOut)
    // external view returns(uint256 res);

    /**
     * @notice Serves as a general deposit/withdraw/swap function.
     * @param tokenIn The token to be provided for processing by this contract.
     * @param amountIn The amount desired to be taken for processing.
     * @param tokenOut The desired token from processing the `tokenIn`.
     * @param minAmountOut The minimal amount of `tokenOut` accepted after processing `tokenIn`.
     * @param recipient The account to receive `tokenOut` for processing `tokenIn`.
     * @param amtInPreTransfered Flag indicating if the `tokenIdIn` has been transfered to this contract.
     * @return amountOut The amount of `tokenOut` credited to the `receipient`.
     */
    function exchangeTokenToToken(
        IERC20 tokenIn,
        uint256 amountIn,
        IERC20 tokenOut,
        uint256 minAmountOut,
        address recipient,
        bool amtInPreTransfered
    ) external returns(uint256 amountOut);

    // /**
    //  * @notice Serves as a general deposit/withdraw/swap function.
    //  * @param tokenIdIn The token Id to be provided for processing by this contract.
    //  * @param amountIn The amount desired to be taken for processing.
    //  * @param tokenIdOut The desired token ID of this contract from processing the `tokenIn`.
    //  * @param minAmountOut The minimal amount of this token accepted after processing `tokenIn`.
    //  * @param recipient The account to receive credit for processing `tokenIn`.
    //  * @param amtInPreTransfered Flag indicating if the `tokenIn` has been transfered to this contract.
    //  * @return amountOut The amount of `tokenIdOut` credited to the `receipient`.
    //  */
    // function exchangeIdToId(
    //     uint256 tokenIdIn,
    //     uint256 amountIn,
    //     uint256 tokenIdOut,
    //     uint256 minAmountOut,
    //     address recipient,
    //     bool amtInPreTransfered
    // ) external returns(uint256 amountOut);

    /**
     * @notice Serves as a general deposit/withdraw/swap function.
     * @param tokenIn The token to be provided for processing by this contract.
     * @param amountIn The amount desired to be taken for processing.
     * @param tokenIdOut The desired token ID of this contract from processing the `tokenIn`.
     * @param minAmountOut The minimal amount of this token accepted after processing `tokenIn`.
     * @param recipient The account to receive credit for processing `tokenIn`.
     * @param amtInPreTransfered Flag indicating if the `tokenIn` has been transfered to this contract.
     * @return amountOut The amount of `tokenIdOut` credited to the `receipient`.
     */
    function exchangeTokenToId(
        address tokenIn,
        uint256 amountIn,
        uint256 tokenIdOut,
        uint256 minAmountOut,
        address recipient,
        bool amtInPreTransfered
    ) external returns(uint256 amountOut);

    // /**
    //  * @notice Serves as a general deposit/withdraw/swap function.
    //  * @param tokenIdIn The token Id to be provided for processing by this contract.
    //  * @param amountIn The amount desired to be taken for processing.
    //  * @param tokenOut The desired token from processing the `tokenIn`.
    //  * @param minAmountOut The minimal amount of `tokenOut` accepted after processing `tokenIn`.
    //  * @param recipient The account to receive `tokenOut` for processing `tokenIn`.
    //  * @param amtInPreTransfered Flag indicating if the `tokenIdIn` has been transfered to this contract.
    //  * @return amountOut The amount of `tokenOut` credited to the `receipient`.
    //  */
    // function exchangeIdToToken(
    //     uint256 tokenIdIn,
    //     uint256 amountIn,
    //     address tokenOut,
    //     uint256 minAmountOut,
    //     address recipient,
    //     bool amtInPreTransfered
    // ) external returns(uint256 amountOut);

}