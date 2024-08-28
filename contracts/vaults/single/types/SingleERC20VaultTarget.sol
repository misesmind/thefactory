// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/tokens/erc20/interfaces/IERC20.sol";
import "thefactory/tokens/erc20/libs/utils/SafeERC20.sol";

interface ISingleAssetVault {

    error NoDepositReceived(IERC20 token, uint256 declaredDeposit);

    function baseToken()
    external view returns(IERC20);

}

struct SingleERC20VaultLayout {
    // Stores the common token held in escrow.
    IERC20 baseToken;
    // Stores the total held balance of `baseToken`
    uint256 baseTokenBal;
}

library SingleERC20VaultRepo {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC20Struct storage)
     * @custom:selector 0x5bbea693
     */
    function slot(
        SingleERC20VaultLayout storage table
    ) external pure returns(bytes32 slot_) {
        return _slot(table);
    }
    // end::slot[]

    // tag::_slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     */
    function _slot(
        SingleERC20VaultLayout storage table
    ) internal pure returns(bytes32 slot_) {
        assembly{slot_ := table.slot}
    }
    // end::_slot[]

    // tag::layout[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     * @custom:sig layout(bytes32)
     * @custom:selector 0x81366cef
     */
    function layout(
        bytes32 slot_
    ) external pure returns(SingleERC20VaultLayout storage layout_) {
        return _layout(slot_);
    }
    // end::layout[]

    // tag::_layout[]
    /**
     * @dev "Binds" this struct to a storage slot.
     * @param slot_ The first slot to use in the range of slots used by the struct.
     * @return layout_ A struct from a Layout library bound to the provided slot.
     */
    function _layout(
        bytes32 slot_
    ) internal pure returns(SingleERC20VaultLayout storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::_layout[]

}

library SingleERC20VaultService {

}

abstract contract SingleERC20VaultStorage {

    using SafeERC20 for IERC20;

    // using UInt256SetRepo for UInt256Set;
    // using UInt256SetRepo for UInt256Set;
    using SingleERC20VaultRepo for SingleERC20VaultLayout;

    address constant SingleERC20VaultRepo_ID =
        address(uint160(uint256(keccak256(type(SingleERC20VaultRepo).creationCode))));
    bytes32 constant internal SingleERC20VaultRepo_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(SingleERC20VaultRepo_ID))) - 1);
    bytes32 internal constant SingleERC20VaultRepo_STORAGE_RANGE =
        type(ISingleAssetVault).interfaceId;
    bytes32 internal constant SingleERC20VaultRepo_STORAGE_SLOT =
        SingleERC20VaultRepo_STORAGE_RANGE ^ SingleERC20VaultRepo_STORAGE_RANGE_OFFSET;

    function _erc20Vault()
    internal pure virtual returns(SingleERC20VaultLayout storage) {
        return SingleERC20VaultRepo._layout(SingleERC20VaultRepo_STORAGE_SLOT);
    }

    function _initERC20Vault(
        IERC20 baseToken
    ) internal {
        _erc20Vault().baseToken = baseToken;
    }

    /**
     * @dev Allows for validating ANY token transfer.
     * @dev Ensures token deposit is received by vault.
     * @dev Will transfer token if required to ensure deposit.
     * @dev Will sync local reserve amount IF `tokenIn_` == baseToken.
     */
    function _validateDeposit(
        IERC20 tokenIn_,
        uint256 depositAmt,
        bool fromInternal_
    ) internal returns(uint256) {
        if(!fromInternal_) {
            IERC20(tokenIn_)._safeTransferFrom(msg.sender, address(this), depositAmt);
        }
        uint256 curBal = tokenIn_.balanceOf(address(this));
        if(curBal < depositAmt) {
            revert ISingleAssetVault.NoDepositReceived(tokenIn_, depositAmt);
        }
        if(address(tokenIn_) == address(_erc20Vault().baseToken)) {
            uint256 baseTokenBal_ = _erc20Vault().baseTokenBal;
            if(curBal < (baseTokenBal_ + depositAmt)) {
                revert ISingleAssetVault.NoDepositReceived(tokenIn_, depositAmt);
            }
            depositAmt = curBal - baseTokenBal_;
            _erc20Vault().baseTokenBal = baseTokenBal_;
        }
        return depositAmt;
    }

    function _sendToken(
        IERC20 tokenOut,
        uint256 amountOut,
        address recipient
    ) internal {
        tokenOut._safeTransfer(recipient, amountOut);
        IERC20 baseToken_ = _erc20Vault().baseToken;
        if(address(tokenOut) == address(baseToken_)) {
            _erc20Vault().baseTokenBal = baseToken_.balanceOf(address(this));
        }
    }

    /**
     * @return The underlying ERC20 held by this vault.
     */
    function _baseToken()
    internal view returns(IERC20) {
        return _erc20Vault().baseToken;
    }


}

contract SingleERC20VaultTarget
is
SingleERC20VaultStorage,
ISingleAssetVault
{

    function baseToken()
    public view returns(IERC20) {
        return _erc20Vault().baseToken;
    }

}