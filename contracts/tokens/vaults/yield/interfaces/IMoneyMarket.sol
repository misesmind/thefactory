// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc6909/interfaces/IERC6909MetadataEnumerated.sol";

/**
 * @notice Extends ERC6909 to behave similar to ERC5115.
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

    /**
     * @notice MAY return self to indicate embedded logic.
     * @notice Adaptor will typically be used with DELEGATECALL.
     * @return sourceAdaptor_ The contract used to interact with the `yieldSource()`.
     */
    function sourceAdaptor()
    external view returns(address sourceAdaptor_);

    /**
     * @param tokenId A token ID for which to query the adaptor contract.
     * @return adaptor The adaptor address for the `tokenId`.
     */
    function adaptorOf(uint256 tokenId)
    external view returns(address adaptor);

    /**
     * @dev `tokenId` 0 is reserved for a ERC5115 adaptor for the yieldToken().
     * @param adaptor The adaptor address for which to query the tokenId.
     * @return tokenId A token ID for the `adaptor`.
     */
    function tokenIdOf(address adaptor)
    external view returns(uint256 tokenId);

    /**
     * @notice Serves as a general deposit function.
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

    /**
     * @notice Serves as a general deposit function.
     * @param tokenIdIn The token Id to be provided for processing by this contract.
     * @param amountIn The amount desired to be taken for processing.
     * @param tokenOut The desired token from processing the `tokenIn`.
     * @param minAmountOut The minimal amount of `tokenOut` accepted after processing `tokenIn`.
     * @param recipient The account to receive `tokenOut` for processing `tokenIn`.
     * @param amtInPreTransfered Flag indicating if the `tokenIdIn` has been transfered to this contract.
     * @return amountOut The amount of `tokenOut` credited to the `receipient`.
     */
    function exchangeIdToToken(
        uint256 tokenIdIn,
        uint256 amountIn,
        address tokenOut,
        uint256 minAmountOut,
        address recipient,
        bool amtInPreTransfered
    ) external returns(uint256 amountOut);

    /**
     * @notice Serves as a general deposit function.
     * @param tokenIn The token to be provided for processing by this contract.
     * @param amountIn The amount desired to be taken for processing.
     * @param tokenOut The desired token from processing the `tokenIn`.
     * @param minAmountOut The minimal amount of `tokenOut` accepted after processing `tokenIn`.
     * @param recipient The account to receive `tokenOut` for processing `tokenIn`.
     * @param amtInPreTransfered Flag indicating if the `tokenIdIn` has been transfered to this contract.
     * @return amountOut The amount of `tokenOut` credited to the `receipient`.
     */
    function exchangeTokenToToken(
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 minAmountOut,
        address recipient,
        bool amtInPreTransfered
    ) external returns(uint256 amountOut);

    /**
     * @notice Serves as a general deposit function.
     * @param tokenIdIn The token Id to be provided for processing by this contract.
     * @param amountIn The amount desired to be taken for processing.
     * @param tokenIdOut The desired token ID of this contract from processing the `tokenIn`.
     * @param minAmountOut The minimal amount of this token accepted after processing `tokenIn`.
     * @param recipient The account to receive credit for processing `tokenIn`.
     * @param amtInPreTransfered Flag indicating if the `tokenIn` has been transfered to this contract.
     * @return amountOut The amount of `tokenIdOut` credited to the `receipient`.
     */
    function exchangeIdToId(
        uint256 tokenIdIn,
        uint256 amountIn,
        uint256 tokenIdOut,
        uint256 minAmountOut,
        address recipient,
        bool amtInPreTransfered
    ) external returns(uint256 amountOut);

}