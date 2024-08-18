// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/utils/math/BetterMath.sol";
import "thefactory/tokens/erc20/libs/utils/SafeERC20.sol";
import "thefactory/tokens/erc20/types/ERC20Storage.sol";
import "thefactory/tokens/erc4626/interfaces/IERC4626.sol";
import "thefactory/tokens/erc4626/libs/ERC4626Layout.sol";
// import "contracts/daosys/core/vaults/shares/types/SharesVaultLogic.sol";
// import "contracts/daosys/Logged.sol";
// import "contracts/daosys/core/primitives/Address.sol";
import "thefactory/utils/primitives/Primitives.sol";

/**
 * @title ERC4626Storage ERC4626 Diamond storage contract.
 * @author mises mind <misesmind@proton.me>
 */
abstract contract ERC4626Storage is ERC20Storage {

    /* ------------------------------ LIBRARIES ----------------------------- */

    using Address for address;
    using UInt for uint256;
    using BetterMath for uint256;
    using SafeERC20 for IERC20;

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    // TODO Replace with address of deployed library.
    // Normally handled by usage as storage slot.
    // Included to facilitate automated audits.
    // address constant MATH_ID = address(Array);
    address constant MATH_ID = address(uint160(uint256(keccak256(type(BetterMath).creationCode))));

    // TODO Replace with address of deployed library.
    // Normally handled by usage for storage slot.
    // Included to facilitate automated audits.
    // address constant ERC4626LAYOUT_ID = address(ERC4626Layout);
    address constant ERC4626LAYOUT_ID = address(uint160(uint256(keccak256(type(ERC4626Layout).creationCode))));

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */
  
    // Defines the default offset applied to all provided storage ranges for use when operating on a struct instance.
    // Subtract 1 from hashed value to ensure future usage of relevant library address.
    bytes32 constant internal ERC4626_STORAGE_RANGE_OFFSET = 
        bytes32(uint256(keccak256(abi.encode(ERC4626LAYOUT_ID))) - 1);

    // The default storage range to use for storage related to this interface.
    // Storage contracts are expected to coordinate operations in relation to an interface and a Layout.
    bytes32 internal constant ERC4626_STORAGE_RANGE = type(IERC4626).interfaceId;
    bytes32 internal constant ERC4626_STORAGE_SLOT = ERC4626_STORAGE_RANGE ^ ERC4626_STORAGE_RANGE_OFFSET;

    /* ------------------------------- Layouts ------------------------------ */

    /**
     * @dev internal hook for the default storage range used by this contract.
     * @dev Other contracts will use their default storage range to ensure consistant storage usage.
     * @return The struct for ERC4626 state.
     */
    function _erc4626()
    internal pure virtual returns(ERC4626Struct storage) {
        return ERC4626Layout._layout(ERC4626_STORAGE_SLOT);
    }

    /* ---------------------------------------------------------------------- */
    /*                             INITIALIZATION                             */
    /* ---------------------------------------------------------------------- */

    /**
     * @param asset The ERC20 token that is the underlying asset.
     */
    function _initERC4626(
        address asset
    ) internal virtual {
        // Set the address of the underlying asset.
        _asset(asset);
        // Set the ERC20 metadata based on the underlying asset.
        _initERC20(
            // Reuse the name of the underlying asset.
            string(abi.encodePacked("Shares of ", IERC20(asset).name())),
            // Reuse the symbol of the underelying asset.
            string(abi.encodePacked("s", IERC20(asset).symbol())),
            // Apply the precision offset.
            IERC20(asset)._safeDecimals() + _decimalsOffset()
        );
    }

    /* ---------------------------------------------------------------------- */
    /*                            UTILITY FUNCTIONS                           */
    /* ---------------------------------------------------------------------- */

    // tag::_convertToShares(uint256,uint256)[]
    /**
     * @dev Internal conversion function (from assets to shares) with support for rounding direction.
     * @param assets The amount of assets from which to calculate equivalent shares.
     * @param reserve The reserve amount of which to calculate shares.
     * @return shares The equivalent amount of shares for `assets` of `reserve`.
     */
    function _convertToShares(
        uint256 assets,
        uint256 reserve
    ) internal view virtual returns (uint256 shares) {
        // string memory sig = "_convertToShares(uint256,uint256)";
        // _log(type(ERC4626Storage).name, sig, "Entering functions");
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "assets = ",
        //         assets._toString()
        //     )
        // );
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "reserve = ",
        //         reserve._toString()
        //     )
        // );
        shares = _convertToShares(assets, reserve, BetterMath.Rounding.Floor);
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "shares = ",
        //         shares._toString()
        //     )
        // );
    }
    // end::_convertToShares(uint256,uint256)[]

    // tag::_convertToShares(uint256,uint256,Math.Rounding)[]
    /**
     * @dev Internal conversion function (from assets to shares) with support for rounding direction.
     * @param assets The amount of assets from which to calculate equivalent sharres.
     * @param reserve The reserve amount of which to calculate shares.
     * @param rounding The desired rounding to apply to calculated `shares`
     * @return shares The equivalent amount of shares for `assets` of `reserve`.
     */
    function _convertToShares(
        uint256 assets,
        uint256 reserve,
        BetterMath.Rounding rounding
    ) internal view virtual returns (uint256 shares) {
        // string memory sig = "_convertToShares(uint256,uint256,Math.Rounding)";
        // _log(type(ERC4626Storage).name, sig, "Entering functions");
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "assets = ",
        //         assets._toString()
        //     )
        // );
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "reserve = ",
        //         reserve._toString()
        //     )
        // );
        // Calculate the amount of shares due for a given amount of asset.
        // Multiply asset quote by total shares, then divide by the total reserve.
        // _log(type(ERC4626Storage).name, sig, string.concat("shares = ", shares._toString()));
        shares = assets._mulDiv(
            // Offset the decimals to minimize frontrun attacks.
            _totalShares() + 10 ** _decimalsOffset(),
            reserve + 1,
            rounding
        );
        // _log(type(ERC4626Storage).name, sig, string.concat("shares = ", shares._toString()));
    }
    // end::_convertToShares(uint256,uint256,Math.Rounding)[]

    // tag::_convertToAssets(uint256,uint256)[]
    /**
     * @dev Internal conversion function (from shares to assets) with support for rounding direction.
     * @param shares The amount of shares from which to calculate the equivalent assets.
     * @param reserve The reserve amount of which to calculate assets.
     * @return The equivalent amount of assets for `shares` of `reserve`.
     */
    function _convertToAssets(
        uint256 shares,
        uint256 reserve
    ) internal view virtual returns (uint256) {
        return _convertToAssets(shares, reserve, BetterMath.Rounding.Floor);
    }
    // end::_convertToAssets(uint256,uint256)[]
    
    // tag::_convertToAssets(uint256,uint256,Math.Rounding)[]
    /**
     * @dev Internal conversion function (from shares to assets) with support for rounding direction.
     * @param shares The amount of shares from which to calculate the equivalent assets.
     * @param reserve The reserve amount of which to calculate assets.
     * @param rounding The desired rounding to apply to calculated `shares`
     * @return The equivalent amount of assets for `shares` of `reserve`.
     */
    function _convertToAssets(
        uint256 shares,
        uint256 reserve,
        BetterMath.Rounding rounding
    ) internal view virtual returns (uint256) {
        // Calculate the amount of asset due for a given amount of shares.
        // Multiply the shares quote by the reserve, then divide by the total shares.
        return shares._mulDiv(
            reserve + 1,
            // Undo the precision offset done during shares conversion.
            _totalShares() + 10 ** _decimalsOffset(),
            rounding
        );
    }
    // end::_convertToAssets(uint256,uint256,Math.Rounding)[]

    /**
     * @dev Query the precision of the underlying asset.
     * @return assetDecimals The precision of the underlying asset.
     */
    function _assetDecimals()
    internal view virtual returns(uint8 assetDecimals) {
        // Return the asset precision.
        return _erc4626().assetDecimals;
    }

    /**
     * @dev Set the related member of the related struct.
     * @param assetDecimals The precision to set for the underlying asset.
     */
    function _assetDecimals(
        uint8 assetDecimals
    ) internal virtual {
        // Set the asset precision.
        _erc4626().assetDecimals = assetDecimals;
    }

    // tag::_decimalsOffset()[]
    /**
     * @return The precision offset to use with the underlying asset used as the unit of account.
     */
    function _decimalsOffset()
    internal view virtual returns (uint8) {
        // Return the default precision offset.
        return 0;
        // return 1;
    }
    // end::_decimalsOffset()[]

    function _sharesBalanceOf(
        address account
    ) internal view returns(uint256) {
        return ERC20Storage._balanceOf(account);
    }

    function _sharesBalanceOf(
        address account,
        uint256 newBalance
    ) internal {
        ERC20Storage._balanceOf(account, newBalance);
    }

    // tag::_totalShares()[]
    /**
     * @dev Reuse the total supply to track total shares.
     * @return The total shares minted for this vault.
     */
    function _totalShares()
    internal view virtual returns(uint256) {
        // Return the total supply.
        return ERC20Storage._totalSupply();
    }
    // end::_totalShares()[]

    // tag::_totalShares(uint256)[]
    /**
     * @param newTotalShares The value to set as the total shares minted by this vault.
     */
    function _totalShares(
        uint256 newTotalShares
    ) internal virtual {
        // Reuse total supply to store total shares.
        ERC20Storage._totalSupply(newTotalShares);
    }
    // end::_totalShares(uint256)[]

    // tag::_mintShares(address,uint256)[]
    /**
     * @param account The account to which `amount` shares should be minted.
     * @param amount The amount to mint as shares for `account`.
     */
    function _mintShares(
        uint256 amount,
        address account
    ) internal virtual returns (uint256 mintedAmount) {
        // string memory sig = "_mintShares(uint256,address,uint256,uint256,bool)";
        // _log(type(ERC4626Storage).name, sig, "Entering Function");
        // _log(type(ERC4626Storage).name, sig, string.concat("Minting shares ", amount._toString(), " to ", account._toString()));
        // Reuse the existing mint function for shares.
        return ERC20Storage._mint(amount, account);
    }
    // end::_mintShares(address,uint256)[]

    // tag::_burnShares(address,uint256)[]
    /**
     * @param account The from which `amount` shares should be burned.
     * @param amount The amount to burn as shares from `account`.
     */
    function _burnShares(
        uint256 amount,
        address account
    ) internal virtual {
        // Reuse the existing burn function for shares.
        ERC20Storage._burn(amount, account);
    }
    // end::_burnShares(address,uint256)[]

    function _remainingAssetSupply()
    internal view returns(uint256) {
        return _remainingTokenSupply(address(_asset()));
    }

    function _remainingTokenSupply(
        address token
    ) internal view returns(uint256) {
        return IERC20(token).totalSupply() - IERC20(token).balanceOf(address(this));
    }

    function _potentialTokenSupply(
        address token
    ) internal view returns(uint256) {
        return type(uint256).max - IERC20(token).balanceOf(address(this));
    }

    function _pullDeposit(
        address tokenIn,
        address spender,
        uint256 amountTokenToDeposit
    ) internal virtual {
        IERC20(tokenIn)._safeTransferFrom(spender, address(this), amountTokenToDeposit);
    }

    function _processDeposit(
        address payer,
        address receiver,
        address tokenIn,
        uint256 assetAmount,
        // minSharesOut
        uint256 
    ) internal virtual returns (uint256 amountSharesOut) {
        uint256 maxAssets = _maxDeposit(receiver);
        if (assetAmount >= maxAssets) {
            revert IERC4626.ERC4626ExceededMaxDeposit(receiver, assetAmount, maxAssets);
        }
        // If _asset is ERC777, `transferFrom` can trigger a reentrancy BEFORE the transfer happens through the
        // `tokensToSend` hook. On the other hand, the `tokenReceived` hook, that is triggered after the transfer,
        // calls the vault, which is assumed not malicious.
        //
        // Conclusion: we need to do the transfer before we mint so that any reentrancy would happen before the
        // assets are transferred and before the shares are minted, which is a valid state.
        // slither-disable-next-line reentrancy-no-eth
        // TODO Enforce recevied balance check.
        // Should be fine for now as every production implementation will be overriding this function.
        amountSharesOut = _previewDeposit(assetAmount);
        // IERC20(tokenIn)._safeTransferFrom(payer, address(this), assetAmount);
        _pullDeposit(tokenIn, payer, assetAmount);
        ERC4626Storage._mintShares(amountSharesOut, receiver);
        emit IERC4626.Deposit(payer, receiver, assetAmount, amountSharesOut);
        return amountSharesOut;
    }

    /**
     * @dev Withdraw/redeem common workflow.
     * @param caller The spender of the account.
     * @param receiver The account balance to receive withdrawal.
     * @param owner The account to spend for withdrawal.
     * @param assets The amount of underlying asset desired for withdrawal.
     * param shares The amount of shares to spend for withdrawal.
     */
    function _processWithdrawal(
        address caller,
        address receiver,
        address owner,
        address tokenOut,
        uint256 assets
        // uint256 shares
    ) internal virtual returns(uint256 sharesOut) {
        if (caller != owner) {
            _decreaseAllowance(owner, caller, assets);
        }
        // If _asset is ERC777, `transfer` can trigger a reentrancy AFTER the transfer happens through the
        // `tokensReceived` hook. On the other hand, the `tokensToSend` hook, that is triggered before the transfer,
        // calls the vault, which is assumed not malicious.
        //
        // Conclusion: we need to do the transfer after the burn so that any reentrancy would happen after the
        // shares are burned and after the assets are transferred, which is a valid state.
        // sharesOut = shares;
        sharesOut = _previewWithdraw(assets);
        ERC4626Storage._burnShares(sharesOut, owner);
        IERC20(tokenOut)._safeTransfer(receiver, assets);
        emit IERC4626.Withdraw(msg.sender, receiver, owner, assets, sharesOut);
        return sharesOut;
    }

    /* ---------------------------------------------------------------------- */
    /*                                OVERRIDES                               */
    /* ---------------------------------------------------------------------- */

    /* -------------------------------- ERC20 ------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                  LOGIC                                 */
    /* ---------------------------------------------------------------------- */

    // tag::_asset[]
    /**
     * @notice get the address of the base token used for vault accountin purposes
     * @return base token address
     */
    function _asset()
    internal view virtual returns (IERC20) {
        // Return the asset address as IERC20.
        return IERC20(_erc4626().asset);
    }
    // end::_asset[]

    /**
     * @dev Set the underlying asset.
     * @param asset The ERC20 token that is the underlying asset.
     */
    function _asset(
        address asset
    ) internal virtual {
        // Set the asset address.
        _erc4626().asset = asset;
    }

    // tag::_totalAssets[]
    /**
     * @notice get the total quantity of the base asset currently managed by the vault
     * @return total managed asset amount
     */
    function _totalAssets()
    internal view virtual returns(uint256) {
        // Return the held balance of the underlying asset.
        return _asset().balanceOf(address(this));
    }
    // end::_totalAssets[]

    // tag::_convertToShares[]
    /**
     * @notice calculate the quantity of shares received in exchange
     * @notice for a given quantity of assets, not accounting for slippage
     * @param assetAmount quantity of assets to convert
     * @return shareAmount quantity of shares calculated
     * @custom:sig convertToShares(uint256)
     */
    function _convertToShares(
        uint256 assetAmount
    ) internal view virtual returns (uint256 shareAmount) {
        return _convertToShares(assetAmount, _totalAssets());
    }
    // end::_convertToShares[]

    // tag::convertToAssets[]
    /**
     * @notice calculate the quantity of assets received in exchange
     * @notice for a given quantity of shares, not accounting for slippage
     * @param shareAmount quantity of shares to convert
     * @return assetAmount quantity of assets calculated
     * @custom:sig convertToAssets(uint256)
     */
    function _convertToAssets(
        uint256 shareAmount
    ) internal view virtual returns (uint256 assetAmount) {
        return _convertToAssets(shareAmount, _totalAssets());
    }
    // end::convertToAssets[]

    /**
     * @dev Expects that the underlying asset would have been minted prior to deposit.
     * @return The maximum amount of the underlying asset that MAY BE deposited.
     */
    function _maxDeposit(
        // account
        address
    ) internal view virtual returns (uint256) {
        // It should only be possible to deposit the remaining supply of the underlying asset.
        // return IERC20(_asset()).totalSupply() - IERC20(_asset()).balanceOf(address(this));
        return _remainingAssetSupply();
    }

    /**
     * @return The maximum amount of shares that may be minted.
     */
    function _maxMint(
        // account
        address
    ) internal view virtual returns (uint256) {
        // return type(uint256).max;
        // The maximum amount of shares should be constrained by the circulating supply of the underlying asset.
        return _convertToShares(
            // IERC20(_asset()).totalSupply() - IERC20(_asset()).balanceOf(address(this))
            _remainingAssetSupply()
        );
    }

    /**
     * @param owner The account for which to query the maximum amount of the underlying asset they may withdraw.
     */
    function _maxWithdraw(
        address owner
    ) internal view virtual returns (uint256) {
        // Convert account's balance to underlying asset.
        return _convertToAssets(ERC4626Storage._sharesBalanceOf(owner));
    }

    /**
     * @param owner The accout for which to query the maximum amount of shares that may be redeemed.
     */
    function _maxRedeem(
        address owner
    ) internal view virtual returns (uint256) {
        // Maximum redemption limit is the account's balance.
        return _sharesBalanceOf(owner);
    }

    /**
     * @notice simulate a deposit of given quantity of assets
     * @param assetAmount quantity of assets to deposit
     * @return shareAmount quantity of shares to mint
     */
    function _previewDeposit(
        uint256 assetAmount
    ) internal view virtual returns (uint256 shareAmount) {
        // string memory sig = "_previewDeposit(address)";
        // _log(type(ERC4626Storage).name, sig, "Entering functions");
        // _log(type(ERC4626Storage).name, 
        //     sig,
        //     string.concat(
        //         "assetAmount = ",
        //         assetAmount._toString()
        //     )
        // );
        return _convertToShares(assetAmount);
    }

    /**
     * @notice simulate a minting of given quantity of shares
     * @param shareAmount quantity of shares to mint
     * @return assetAmount quantity of assets to deposit
     */
    function _previewMint(
        uint256 shareAmount
    ) internal view virtual returns (uint256 assetAmount) {
        return _convertToAssets(shareAmount);
    }

    /**
     * @notice simulate a withdrawal of given quantity of assets
     * @param assetAmount quantity of assets to withdraw
     * @return shareAmount quantity of shares to redeem
     */
    function _previewWithdraw(
        uint256 assetAmount
    ) internal view virtual returns (uint256 shareAmount) {
        return _convertToShares(assetAmount);
    }

    /**
     * @notice simulate a redemption of given quantity of shares
     * @param shareAmount quantity of shares to redeem
     * @return assetAmount quantity of assets to withdraw
     */
    function _previewRedeem(
        uint256 shareAmount
    ) internal view virtual returns (uint256 assetAmount) {
        return _convertToAssets(shareAmount);
    }

    function _deposit(
        uint256 assets,
        address receiver
    ) internal virtual returns (uint256 shares) {
        shares = _processDeposit(
            msg.sender,
            receiver,
            address(_asset()),
            assets,
            0
        );
        // return shares;
    }

    /**
     * @dev REQUIRES ability to take deposit of underlying asset.
     * @param shares The desired shares to mint for the `receiver`.
     * @param receiver The account to be credited with `shares`.
     */
    function _mint(
        uint256 shares,
        address receiver
    ) internal virtual override(ERC20Storage) returns (uint256 assets) {
        assets = _previewMint(shares);
        _processDeposit(
            msg.sender,
            receiver,
            address(_asset()),
            assets,
            0
        );
        return assets;
    }

    function _withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) internal virtual returns (uint256 sharesOut) {
        return _processWithdrawal(
            msg.sender,
            receiver,
            owner,
            address(_asset()),
            assets
        );
    }

    /**
     * @param shares The amount of shares to redeem for withdrawal.
     * @param receiver The account to receive the withdrawal of the underlying asset.
     * @param owner The account to spend shares for redemption.
     */
    function _redeem(
        uint256 shares,
        address receiver,
        address owner
    ) internal virtual returns (uint256 assets) {
        // Quote the value of provided `shares` as underlying asset.
        assets = _previewRedeem(shares);
        _processWithdrawal(
            msg.sender,
            receiver,
            owner,
            address(_asset()),
            assets
        );
        // emit IERC4626.Withdraw(msg.sender, receiver, owner, assets, shares);
        return assets;
    }

}