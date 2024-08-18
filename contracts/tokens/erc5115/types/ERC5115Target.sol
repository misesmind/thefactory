// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/erc5115/types/ERC5115Storage.sol";
import "thefactory/tokens/erc20/types/ERC20Target.sol";
import "thefactory/tokens/erc5115/interfaces/IERC5115.sol";
import "thefactory/utils/primitives/Primitives.sol";

abstract contract ERC5115Target is ERC20Target, ERC5115Storage, IERC5115 {

    using Address for address;
    using UInt for uint256;

    // function _contName() internal pure virtual override(ERC20Storage, ERC4626Storage) returns(string memory) {
    //     return type(ERC5115Target).name;
    // }

    /* ------------------------------ LIBRARIES ----------------------------- */

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */

    /* --------------------------- INITIALIZATION --------------------------- */

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

    /* ---------------------------------------------------------------------- */
    /*                        REFACTORED CODE IS ABOVE                        */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------- ! --------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                        REFACTORED CODE IS ABVOE                        */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                         REFACTORING ABOVE HERE                         */
    /* ---------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------- */
    /*                             OLD CODE BELOW                             */
    /* ---------------------------------------------------------------------- */

    function _mint(
        uint256 shareAmount,
        address receiver
    ) internal virtual override(ERC20Storage, ERC4626Storage) returns (uint256 assetAmount) {
        return ERC4626Storage._mint(
            shareAmount,
            receiver
        );
    }

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
    ) external virtual returns (uint256 amountSharesOut) {
        return _deposit(
            receiver,
            tokenIn,
            amountTokenToDeposit,
            minSharesOut,
            depositFromInternalBalance
        );
    }
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
    ) external virtual returns (uint256 amountTokenOut) {
        // string memory sig = "redeem(address,uint256,address,uint256,bool)";
        // string memory name_ = type(ERC5115Target).name;
        // _log(name_, sig, "Entering Function");
        // _log(name_, sig, string.concat("receiver = ", receiver._toString()));
        // _log(name_, sig, string.concat("amountSharesToRedeem = ", amountSharesToRedeem._toString()));
        // _log(name_, sig, string.concat("tokenOut = ", tokenOut._toString()));
        // _log(name_, sig, string.concat("minTokenOut = ", minTokenOut._toString()));
        return _redeem(
            receiver,
            amountSharesToRedeem,
            tokenOut,
            minTokenOut,
            burnFromInternalBalance
        );
    }
    // end::redeem[]

    // tag::exchangeRate[]
    /**
     * @custom:sig exchangeRate()
     */
    function exchangeRate()
    external view virtual returns (uint256 res) {
        return _exchangeRate();

    }
    // end::exchangeRate[]

    // tag::getTokensIn[]
    /**
     * @custom:sig getTokensIn()
     */
    function getTokensIn()
    external view virtual returns (address[] memory res) {
        return _tokensIn();
    }
    // end::getTokensIn[]

    // tag::getTokensOut[]
    /**
     * @custom:sig getTokensOut()
     */
    function getTokensOut()
    external view virtual returns (address[] memory res) {
        return _tokensOut();
    }
    // end::getTokensOut[]

    // tag::yieldToken[]
    /**
     * @notice This read-only function returns the underlying yield-bearing token (representing a GYGP) address.
     * @notice MUST return a token address that conforms to the ERC-20 interface, or zero address
     * @notice MUST NOT revert.
     * @notice MUST reflect the exact underlying yield-bearing token address if the SY token is a wrapped token.
     * @notice MAY return 0x or zero address if the SY token is natively implemented, and not from wrapping.
     * @custom:sig yieldToken()
     */
    function yieldToken() public view virtual returns (address) {
        return address(_yieldToken());
    }
    // end::yieldToken[]

    // tag::previewDeposit[]
    /**
     * @custom:sig previewDeposit(address,uint256)
     */
    function previewDeposit(
        address tokenIn,
        uint256 amountTokenToDeposit
    ) external view virtual returns (uint256 amountSharesOut) {
        return _previewDeposit(
            tokenIn,
            amountTokenToDeposit
        );
    }
    // end::previewDeposit[]

    // tag::previewRedeem[]
    /**
     * @custom:sig previewRedeem(address,uint256)
     */
    function previewRedeem(
        address tokenOut,
        uint256 amountSharesToRedeem
    ) external view virtual returns (uint256 amountTokenOut) {
        return _previewRedeem(
            tokenOut,
            amountSharesToRedeem
        );
    }
    // end::previewRedeem[]
    
}