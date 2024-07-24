// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/tokens/erc4626/types/ERC4626Storage.sol";
import "thefactory/tokens/erc5115/interfaces/IERC5115.sol";
import "thefactory/tokens/erc5115/libs/ERC5115Layout.sol";
import "thefactory/collections/Collections.sol";

/**
 * @dev We interpert ERC5115 as a sufficient overlap with ERC4626 to reuse storage logic.
 */
abstract contract ERC5115Storage is ERC4626Storage {

    /* ------------------------------ LIBRARIES ----------------------------- */

    using AddressSetLayout for AddressSet;

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    address constant AddressSetLayout_ID = address(uint160(uint256(keccak256(type(AddressSetLayout).creationCode))));
    address constant ERC5115SLAYOUT_ID = address(uint160(uint256(keccak256(type(ERC4626Layout).creationCode))));

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */
  
    // TODO Replace with address of deployed layout library.
    // Defines the default offset applied to all provided storage ranges for use with operating on a storage layout struct.
    bytes32 constant internal ERC5115S_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(ERC5115SLAYOUT_ID))) - 1);

    // The default storage range to use with the Repo libraries consumed by this library.
    // Service libraries are expected to coordinate operations in relation to a interface between other Services and Repos.
    bytes32 internal constant ERC5115S_STORAGE_RANGE = type(IERC5115).interfaceId;
    bytes32 internal constant ERC5115S_STORAGE_SLOT = ERC5115S_STORAGE_RANGE ^ ERC5115S_STORAGE_RANGE_OFFSET;

    /* ------------------------------- Layouts ------------------------------ */

    /**
     * @dev Internal hook for the default storage range used by this library.
     * @dev Other services will use their default storage range to ensure consistant storage usage.
     * @return storageRange_ The default storage range used with repos.
     */
    function _erc5115()
    internal pure virtual returns(ERC5115Struct storage) {
        return ERC5115Layout._layout(ERC5115S_STORAGE_SLOT);
    }

    /* ---------------------------------------------------------------------- */
    /*                             INITIALIZATION                             */
    /* ---------------------------------------------------------------------- */

    /**
     * @dev Initialize the ERC5115 configuration.
     * @dev DOES NOT presume the yieldToken is acceptable for deposit or withdrawal.
     * @param yieldToken The underlying asset providing the yield for the vault.
     * @param tokensIn The set of ERC20 tokens to accept for deposit.
     * @param tokensOut The set of ERC20 tokens that may be withdrawn.
     */
    function _init5115(
        address yieldToken,
        address[] memory tokensIn,
        address[] memory tokensOut
    ) internal {
        _initERC4626(yieldToken);
        _tokensIn(tokensIn);
        _tokensOut(tokensOut);
    }
    
    function _init5115(
        address yieldToken
    ) internal {
        _initERC4626(yieldToken);
        _tokensIn(yieldToken);
        _tokensOut(yieldToken);
    }

    function _init5115(
        address[] memory tokensIn,
        address[] memory tokensOut
    ) internal {
        _tokensIn(tokensIn);
        _tokensOut(tokensOut);
    }

    /* ---------------------------------------------------------------------- */
    /*                                MODIFIERS                               */
    /* ---------------------------------------------------------------------- */

    modifier onlyTokenIn(address tokenIn) {
        require(_isTokenIn(tokenIn));
        _;
    }

    modifier onlyTokenOut(address tokenOut) {
        require(_isTokenOut(tokenOut));
        _;
    }

    /* ---------------------------------------------------------------------- */
    /*                            UTILITY FUNCTIONS                           */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                OVERRIDES                               */
    /* ---------------------------------------------------------------------- */

    /* -------------------------------- ERC20 ------------------------------- */

    /* ------------------------------- ERC4626 ------------------------------ */

    /* ------------------------------- ERC5115 ------------------------------ */

    /* ---------------------------- IndexedYield ---------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                  LOGIC                                 */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------- MUST OVERRIDE --------------------------- */

    // tag::_deposit(address,address,uint256,uint256,bool)[]
    /**
     * @dev Override to define how to accept and value the deposit of `tokenIn`.
     * @param receiver The account to be credit for the deposit.
     * @param tokenIn The token to provide for deposit.
     * @param amountTokenToDeposit The amount of `tokenIn` to deposit.
     * @param depositFromInternalBalance Flag to indicate whether deposit was pre-transfered.
     */
    function _deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut,
        bool depositFromInternalBalance
    ) internal virtual returns (uint256 amountSharesOut);
    // end::_deposit(address,address,uint256,uint256,bool)[]

    // tag::_redeem(address,uint256,address,uint256,bool)[]
    /**
     * @dev Override to define how to value and provide `tokenOut` for remdpetion.
     * @param receiver The account to receive the redemption for `tokenOut`.
     * @param amountSharesToRedeem The amount of shares to spend for remdeption of `tokenOut`.
     * @param minTokenOut The minimum amount of `tokenOut` to accept for redemption. Allows for constraining slippage.
     * @param burnFromInternalBalance Flag to indicate if redemption should be honored from pre-transfer to self.
     */
    function _redeem(
        address receiver,
        uint256 amountSharesToRedeem,
        address tokenOut,
        uint256 minTokenOut,
        bool burnFromInternalBalance
    ) internal virtual returns (uint256 amountTokenOut);
    // end::_redeem(address,uint256,address,uint256,bool)[]

    /**
     * @dev Override to define how `tokenIn` will be valued for deposit.
     * @param tokenIn The token for which to quote deposit value.
     * @param amountTokenToDeposit The amount of `tokenIn` for which to quote deposit value.
     */
    function _previewDeposit(
        address tokenIn,
        uint256 amountTokenToDeposit
    ) internal view virtual returns (uint256 amountSharesOut);

    /**
     * @dev Override to define how `tokenOut` and amount provided on redemption of `amountSharesToRedeem`.
     * @param tokenOut The token to quote on redemption of `amountSharesToRedeem`.
     * @param amountSharesToRedeem The amount of shares to quote for redemption of `tokenOut`.
     */
    function _previewRedeem(
        address tokenOut,
        uint256 amountSharesToRedeem
    ) internal view virtual returns (uint256 amountTokenOut);

    // tag::_exchangeRate[]
    /**
     * @dev Provides the exchange rates of this token to yieldToken.
     * @dev Allows for deriving the value of a contribution to the reserve based on increasing yieldToken balance.
     * @dev It is up the caller to be familiar with how any given tokenIn will be processed into the yieldToken.
     */
    function _exchangeRate()
    internal view virtual returns (uint256 res) {
        // return _totalShares() / _totalAssets();
        // Load the total shares.
        uint256 totalShares = _totalShares();
        // load the reserve of underlying asset.
        uint256 totalAssets = _totalAssets();
        // console.log("totalAssets", totalAssets);
        // console.log("totalShares", totalShares);
        return
            // Check if either shares or reserve is 0.
            (totalAssets == 0 || totalShares == 0)
                // If either is 0, the exchange rate WILL be 1.
                ? 1e18
                // With a prior claim in shares OR a reserve the exchange rate is the linear price.
                // SHOULD be 1, but allows for distribution to holders via direct transfer of underlying asset.
                : (1e18*totalShares) / totalAssets;
    }
    // end::_exchangeRate[]

    /**
     * @return res The set of tokens accept for deposit.
     */
    function _tokensIn()
    internal view virtual returns (address[] memory res) {
        res = _erc5115().tokensIn._values();
    }

    /**
     * @dev DOES NOT presume the yieldToken is accepted for deposit.
     * @param tokensIn The set of tokens to add as accepted for deposit.
     */
    function _tokensIn(
        address[] memory tokensIn
    ) internal {
        _erc5115().tokensIn._add(tokensIn);
    }

    /**
     * @dev DOES NOT presume the yieldToken is accepted for deposit.
     * @param tokenIn The token to add to the set accepted for deposit.
     */
    function _tokensIn(
        address tokenIn
    ) internal {
        _erc5115().tokensIn._add(tokenIn);
    }

    /**
     * @dev Query if `token` is accepted for deposit.
     * @param token The token to check for deposit acceptance.
     * @return Boolean indicating if token is accepted for deposit.
    */
    function _isTokenIn(
        address token
    ) internal view virtual returns(bool) {
        return _erc5115().tokensIn._contains(token);
    }

    /**
     * @return res The tokens available for redemption.
     */
    function _tokensOut()
    internal view virtual returns (address[] memory res) {
        res = _erc5115().tokensOut._values();
    }

    /**
     * @dev DOES NOT presume the yieldToken is valid for redemption.
     * @param tokensOut The set of tokens to add as valid for redemption.
     */
    function _tokensOut(
        address[] memory tokensOut
    ) internal virtual {
        _erc5115().tokensOut._add(tokensOut);
    }

    function _tokensOut(
        address tokenOut
    ) internal virtual {
        _erc5115().tokensOut._add(tokenOut);
    }

    /**
     * @dev Query if `token` is valid for redemption.
     * 
     */
    function _isTokenOut(
        address token
    ) internal view virtual returns(bool isTokenOut) {
        return _erc5115().tokensOut._contains(token);
    }

    // tag::yieldToken[]
    /**
     * @notice This read-only method returns the underlying yield-bearing token (representing a GYGP) address.
     * @notice MUST return a token address that conforms to the ERC-20 interface, or zero address
     * @notice MUST NOT revert.
     * @notice MUST reflect the exact underlying yield-bearing token address if the SY token is a wrapped token.
     * @notice MAY return 0x or zero address if the SY token is natively implemented, and not from wrapping.
     * @custom:sig yieldToken()
     */
    function _yieldToken()
    internal view virtual returns (IERC20) {
        // Reuse the ERC46626 asset as the yieldToken.
        return _asset();
    }
    // end::yieldToken[]

    /**
     * @param asset The token to set as the underlying yield source.
     */
    function _yieldToken(
        address asset
    ) internal virtual {
        // Reuse ERC4626 asset.
        _asset(asset);
    }

}