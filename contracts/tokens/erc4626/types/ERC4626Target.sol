// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc4626/types/ERC4626Storage.sol";
import "thefactory/tokens/erc20/types/ERC20Target.sol";
import "thefactory/tokens/erc4626/interfaces/IERC4626.sol";

contract ERC4626Target is ERC20Target, ERC4626Storage, IERC4626
{

    // function _contName() internal pure virtual override(ERC20Storage, ERC4626Storage) returns(string memory) {
    //     return type(ERC4626Target).name;
    // }

    /* ------------------------------ LIBRARIES ----------------------------- */

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */

    /* ------------------------------- Layouts ------------------------------ */

    /* ---------------------------------------------------------------------- */
    /*                             INITIALIZATION                             */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                            UTILITY FUNCTIONS                           */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                OVERRIDES                               */
    /* ---------------------------------------------------------------------- */

    /* -------------------------------- ERC20 ------------------------------- */

    /**
     * @dev REQUIRES ability to take deposit of underlying asset.
     * @param shares The desired shares to mint for the `receiver`.
     * @param receiver The account to be credited with `shares`.
     */
    function _mint(
        uint256 shares,
        address receiver
    ) internal virtual override(ERC20Storage, ERC4626Storage) returns (uint256) {
        return ERC4626Storage._mint(shares, receiver);
    }

    /* ------------------------------- ERC4626 ------------------------------ */

    /* ------------------------------- ERC5115 ------------------------------ */

    /* ---------------------------- IndexedYield ---------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                  LOGIC                                 */
    /* ---------------------------------------------------------------------- */

    /* ------------------------------- ERC4626 ------------------------------ */

    // tag::asset[]
    /**
     * @notice get the address of the base token used for vault accountin purposes
     * @return base token address
     * @custom:sig asset()
     */
    function asset()
    external view virtual override returns (address) {
        return address(_asset());
    }
    // end::asset[]

    // tag::totalAssets[]
    /**
     * @notice get the total quantity of the base asset currently managed by the vault
     * @return total managed asset amount
     * @custom:sig totalAssets()
     */
    function totalAssets() external view virtual override returns (uint256) {
        return _totalAssets();
    }
    // end::totalAssets[]

    // tag::convertToShares[]
    /**
     * @notice calculate the quantity of shares received in exchange
     * @notice for a given quantity of assets, not accounting for slippage
     * @param assetAmount quantity of assets to convert
     * @return shareAmount quantity of shares calculated
     * @custom:sig convertToShares(uint256)
     */
    function convertToShares(
        uint256 assetAmount
    ) external view virtual returns (uint256 shareAmount) {
        return _convertToShares(assetAmount);
    }
    // end::convertToShares[]

    // tag::convertToAssets[]
    /**
     * @notice calculate the quantity of assets received in exchange
     * @notice for a given quantity of shares, not accounting for slippage
     * @param shareAmount quantity of shares to convert
     * @return assetAmount quantity of assets calculated
     * @custom:sig convertToAssets(uint256)
     */
    function convertToAssets(
        uint256 shareAmount
    ) external view virtual returns (uint256 assetAmount) {
        return _convertToAssets(shareAmount);
    }
    // end::convertToAssets[]

    function maxDeposit(
        address account
    ) external view virtual returns (uint256) {
        return _maxDeposit(account);
    }

    function maxMint(
        address account
    ) external view virtual returns (uint256) {
        return _maxMint(account);
    }

    function maxWithdraw(
        address owner
    ) external view virtual returns (uint256) {
        return _maxWithdraw(owner);
    }

    function maxRedeem(
        address owner
    ) external view virtual returns (uint256) {
        return _maxRedeem(owner);
    }

    /**
     * @inheritdoc IERC4626
     */
    function previewDeposit(
        uint256 assetAmount
    ) external view virtual returns (uint256 shareAmount) {
        return _previewDeposit(assetAmount);
    }

    /**
     * @inheritdoc IERC4626
     */
    function previewMint(
        uint256 shareAmount
    ) external view virtual returns (uint256 assetAmount) {
        return _previewMint(shareAmount);
    }

    /**
     * @inheritdoc IERC4626
     */
    function previewWithdraw(
        uint256 assets
    ) external view virtual returns (uint256) {
        return _previewWithdraw(assets);
    }

    /**
     * @inheritdoc IERC4626
     */
    function previewRedeem(
        uint256 shares
    ) external view virtual returns (uint256) {
        return _previewRedeem(shares);
    }

    /**
     * @inheritdoc IERC4626
     */
    function deposit(
        uint256 assets,
        address receiver
    ) external virtual returns (uint256 shares) {
        return _deposit(
            assets,
            receiver
        );
    }

    // tag::mint[]
    /**
     * @notice execute a minting of shares on behalf of given address
     * @param shares quantity of shares to mint
     * @param receiver recipient of shares resulting from deposit
     * @return assetAmount quantity of assets deposited.
     * @custom:sig mint(uint256,address)
     * @custom:emits Deposit(address indexed,address indexed,uint256,uint256)
     */
    function mint(
        uint256 shares,
        address receiver
    ) external virtual returns (uint256 assetAmount) {
        return _mint(shares, receiver);
    }
    // end::mint[]

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external virtual returns (uint256) {
        return _withdraw(
            assets,
            receiver,
            owner
        );
    }

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external virtual returns (uint256) {
        uint256 maxShares = _maxRedeem(owner);
        if (shares > maxShares) {
            revert ERC4626ExceededMaxRedeem(owner, shares, maxShares);
        }
        return _redeem(shares, receiver, owner);
    }

}