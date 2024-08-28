// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

// import "hardhat/console.sol";
import "forge-std/console.sol";
// import "forge-std/console2.sol";

import "thefactory/utils/primitives/Primitives.sol";
import "thefactory/collections/Collections.sol";
import "thefactory/tokens/erc20/libs/utils/SafeERC20.sol";
import "thefactory/tokens/erc721/types/ERC721Storage.sol";
import "thefactory/tokens/erc721/types/ERC721Target.sol";
import "thefactory/access/operatable/types/OperatableTarget.sol";
// import "thefactory/vaults/single/types/SingleERC20VaultTarget.sol";
import "thefactory/tokens/erc721/types/NFTDescriptor.sol";

interface IERC721EscrowNFT {

    struct Position {
        IERC20 baseToken;
        uint256 depositAmount;
        address creator;
        uint256 creationTimestamp;
        uint256 liquidityOwned;
        uint256 lockPeriod;
        uint256 unlockTimestamp;
    }

    // TODO Move to Operatable.
    error NotOwnerOperator(address challenger);
    error NotOperator(address challenger);

    error NoDepositReceived(IERC20 token, uint256 declaredDeposit);

    error NotMatured(uint256 currentTime, uint256 unlockTime);

}

struct ERC721EscrowNFTLayout {
    // bool withdrawEnabled;
    IERC20 baseToken;
    uint256 baseTokenBal;
    mapping(uint256 tokenId => uint256 initialBal) initBalOfID;
    mapping(uint256 tokenId => uint256 escrowedBal) balOfId;
    mapping(uint256 tokenId => uint256 unlockTimestanp) unlockTimeOfId;
    mapping(uint256 tokenId => uint256 lockPeriod) lockPeriodOfId;

    mapping(uint256 tokenId => IERC721EscrowNFT.Position) positionOf;
    // TODO move to ERC721Enumerated
    mapping(uint256 tokenId => address creator) creatorOfId;
    mapping(uint256 tokenId => uint256 creationTimestanp) createTimeOfId;
    mapping(address account => UInt256Set ownedTokenIds) ownedTokenIds;
}

library ERC721EscrowNFTRepo {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC20Struct storage)
     * @custom:selector 0x5bbea693
     */
    function slot(
        ERC721EscrowNFTLayout storage table
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
        ERC721EscrowNFTLayout storage table
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
    ) external pure returns(ERC721EscrowNFTLayout storage layout_) {
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
    ) internal pure returns(ERC721EscrowNFTLayout storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::_layout[]

}

abstract contract ERC721EscrowNFTStorage
is
// SingleERC20VaultStorage,
OperatableStorage,
ERC721Storage
{

    // using UInt256SetRepo for UInt256Set;
    using UInt256SetRepo for UInt256Set;
    using ERC721EscrowNFTRepo for ERC721EscrowNFTLayout;

    address constant ERC721EscrowNFTRepo_ID =
        address(uint160(uint256(keccak256(type(ERC721EscrowNFTRepo).creationCode))));
    bytes32 constant internal ERC721EscrowNFTRepo_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(ERC721EscrowNFTRepo_ID))) - 1);
    bytes32 internal constant ERC721EscrowNFTRepo_STORAGE_RANGE =
        type(IERC721EscrowNFT).interfaceId;
    bytes32 internal constant ERC721EscrowNFTRepo_STORAGE_SLOT =
        ERC721EscrowNFTRepo_STORAGE_RANGE ^ ERC721EscrowNFTRepo_STORAGE_RANGE_OFFSET;

    function _escrowNFT()
    internal pure virtual returns(ERC721EscrowNFTLayout storage) {
        return ERC721EscrowNFTRepo._layout(ERC721EscrowNFTRepo_STORAGE_SLOT);
    }

    function _initEscrowNFT(
        address owner_,
        IERC20 baseToken
    ) internal {
        _initOwner(owner_);
        // _initERC20Vault(baseToken);
        _escrowNFT().baseToken = baseToken;
    }

    /**
     * @return The underlying ERC20 held by this vault.
     */
    function _baseToken()
    internal view returns(IERC20) {
        return _escrowNFT().baseToken;
    }

    function _ownedTokenIds(address account) internal view returns(uint256[] storage) {
        return _escrowNFT().ownedTokenIds[account]._values();
    }

    function _amountOfOwnedTokenIds(
        address account
    ) internal view returns(uint256) {
        return _escrowNFT().ownedTokenIds[account]._length();
    }

    function _addOwnedTokenId(
        address account,
        uint256 tokenId
    ) internal {
        _escrowNFT().ownedTokenIds[account]._add(tokenId);
    }

    function _removeOwnedTokenId(
        address account,
        uint256 tokenId
    ) internal {
        _escrowNFT().ownedTokenIds[account]._remove(tokenId);
    }

    function _isTokenIdOwned(
        address account,
        uint256 tokenId
    ) internal view returns(bool) {
        return _escrowNFT().ownedTokenIds[account]._contains(tokenId);
    }

    function _positionOf(uint256 tokenId) internal view returns(IERC721EscrowNFT.Position storage) {
        return _escrowNFT().positionOf[tokenId];
    }

    function _positionOf(uint256 tokenId, IERC721EscrowNFT.Position memory position) internal {
        _escrowNFT().positionOf[tokenId] = position;
    }

    function _transferOwnedTokenId(
        address account,
        address recipient,
        uint256 tokenId
    ) internal {
        require(_isTokenIdOwned(account, tokenId));
        _removeOwnedTokenId(account, tokenId);
        _addOwnedTokenId(recipient, tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        _transferOwnedTokenId(from, to, tokenId);
        ERC721Storage._transfer(from, to, tokenId);
    }

    function _transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        _transferOwnedTokenId(from, to, tokenId);
        ERC721Storage._transferFrom(from, to, tokenId);
    }

    function _mint(
        address to,
        uint256 tokenId
    ) internal virtual override returns (uint256 mintedAmount) {
        _addOwnedTokenId(to, tokenId);
        return ERC721Storage._mint(to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual override {
        address owner_ = _owner(tokenId);
        _removeOwnedTokenId(owner_, tokenId);
        ERC721Storage._burn(tokenId);
    }

}

contract ERC721EscrowNFTTarget
is
ERC721EscrowNFTStorage,
OperatableTarget,
ERC721Target,
IERC721EscrowNFT
{

    using Address for address;
    using SafeERC20 for IERC20;

    function _mint(
        address to,
        uint256 tokenId
    ) internal virtual
    override(ERC721Storage, ERC721EscrowNFTStorage)
    returns (uint256 mintedAmount) {
        return ERC721EscrowNFTStorage._mint(to, tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual 
    override(ERC721Storage, ERC721EscrowNFTStorage)
    {
        ERC721EscrowNFTStorage._transfer(from, to, tokenId);
    }

    function _transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual 
    override(ERC721Storage, ERC721EscrowNFTStorage)
    {
        ERC721EscrowNFTStorage._transferFrom(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
    internal virtual 
    override(ERC721Storage, ERC721EscrowNFTStorage)
    {
        ERC721EscrowNFTStorage._burn(tokenId);
    }

    function position(uint256 tokenId)
    public view returns(Position memory) {
        uint256 creationTimestamp = _escrowNFT().createTimeOfId[tokenId];
        uint256 unlockTimeStamp = _escrowNFT().unlockTimeOfId[tokenId];
        return IERC721EscrowNFT.Position({
            baseToken: _baseToken(),
            depositAmount: _escrowNFT().initBalOfID[tokenId],
            creator: _escrowNFT().creatorOfId[tokenId],
            creationTimestamp: creationTimestamp,
            liquidityOwned: _escrowNFT().balOfId[tokenId],
            lockPeriod: _escrowNFT().lockPeriodOfId[tokenId],
            unlockTimestamp: unlockTimeStamp
        });
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);
        Position memory position_ = position(tokenId);
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    isLocked: (position_.unlockTimestamp > block.timestamp ),
                    positionValue: position_.liquidityOwned
                })
            );
    }

    function allOwnedURIs(
        address account
    ) external view returns(string[] memory uris) {
        uint256 ownedTokenIdLen = _amountOfOwnedTokenIds(account);
        uris = new string[](ownedTokenIdLen);
        for(uint256 cursor = 0; cursor < ownedTokenIdLen; cursor++) {
            uint256 tokenId = _ownedTokenIds(account)[cursor];
            Position memory position_ = position(tokenId);
            uris[cursor] = NFTDescriptor.constructTokenURI(
                NFTDescriptor.ConstructTokenURIParams({
                    tokenId: tokenId,
                    isLocked: (position_.unlockTimestamp > block.timestamp ),
                    positionValue: position_.liquidityOwned
                })
            );
        }
    }

    function deposit(
        uint256 amountIn,
        uint256 unlockTimeStamp,
        address recipient,
        bool preTransfered
    ) public returns(uint256 tokenId) {
        _isOperator(recipient, msg.sender, true);
        IERC20 baseToken_ = _baseToken();
        uint256 depositAmt;
        if(!preTransfered) {
            IERC20(baseToken_)._safeTransferFrom(msg.sender, address(this), depositAmt);
        }
        uint256 curBal = baseToken_.balanceOf(address(this));
        if(curBal < depositAmt) {
            revert IERC721EscrowNFT.NoDepositReceived(baseToken_, depositAmt);
        }
        if(address(baseToken_) == address(_escrowNFT().baseToken)) {
            uint256 baseTokenBal_ = _escrowNFT().baseTokenBal;
            if(curBal < (baseTokenBal_ + depositAmt)) {
                revert IERC721EscrowNFT.NoDepositReceived(baseToken_, depositAmt);
            }
            depositAmt = curBal - baseTokenBal_;
            _escrowNFT().baseTokenBal = baseTokenBal_;
        }
        // uint256 creationTimestamp = _escrowNFT().createTimeOfId[tokenId];
        // uint256 unlockTimeStamp = _escrowNFT().unlockTimeOfId[tokenId];
        tokenId = _nextTokenId();
        _escrowNFT().initBalOfID[tokenId] = amountIn;
        _escrowNFT().creatorOfId[tokenId] = msg.sender;
        _escrowNFT().createTimeOfId[tokenId] = block.timestamp;
        _escrowNFT().balOfId[tokenId] = amountIn;
        _escrowNFT().unlockTimeOfId[tokenId] = unlockTimeStamp;
        _escrowNFT().lockPeriodOfId[tokenId] = block.timestamp + unlockTimeStamp;
        _mint(recipient, tokenId);
        return tokenId;
    }

    function redeem(
        uint256 tokenId,
        address recipient
    ) public returns(uint256 amountOut) {
        address owner_ = _owner(tokenId);
        if(
            msg.sender != owner_
            || !_isOperator(owner_, msg.sender)
        ) {
            revert NotOwnerOperator(msg.sender);
        }
        uint256 unlockTimeStamp = _escrowNFT().unlockTimeOfId[tokenId];
        if(unlockTimeStamp > block.timestamp) {
            revert NotMatured(unlockTimeStamp, block.timestamp);
        }
        amountOut = _escrowNFT().balOfId[tokenId];
        _escrowNFT().balOfId[tokenId] = 0;
        IERC20 baseToken_ = _escrowNFT().baseToken;
        // _sendToken(baseToken_, escrowedBal, recipient);
        baseToken_._safeTransfer(recipient, amountOut);
        _escrowNFT().baseTokenBal = baseToken_.balanceOf(address(this));
    }

    function borrow(
        uint256 tokenId,
        // bool sendToken,
        bytes memory callBack
        // bool pullDeposit
    ) public returns(uint256 newTokenId) {
        address owner_ = _owner(tokenId);
        if(
            !_isOperator(owner_, msg.sender)
        ) {
            revert NotOperator(msg.sender);
        }
        IERC20 baseToken_ = _escrowNFT().baseToken;
        uint256 escrowedBal = _escrowNFT().balOfId[tokenId];
        _escrowNFT().balOfId[tokenId] = 0;
        baseToken_._safeTransfer(msg.sender, escrowedBal);
        _escrowNFT().baseTokenBal = baseToken_.balanceOf(address(this));
        msg.sender._functionCall(callBack);
        uint256 curBal = baseToken_.balanceOf(address(this));
        uint256 baseTokenBal_ = _escrowNFT().baseTokenBal;
        if(curBal < (baseTokenBal_)) {
            revert IERC721EscrowNFT.NoDepositReceived(baseToken_, baseTokenBal_);
        }
        uint256 redepositAmt = curBal - baseTokenBal_;
        // uint256 creationTimestamp = _escrowNFT().createTimeOfId[tokenId];
        // uint256 unlockTimeStamp = _escrowNFT().unlockTimeOfId[tokenId];
        return deposit(
            redepositAmt,
            block.timestamp + _escrowNFT().lockPeriodOfId[tokenId],
            owner_,
            true
        );
    }

}

contract ERC721EscrowNFTTargetStub
is
ERC721EscrowNFTTarget
{

    constructor(
        address owner_,
        IERC20 baseToken
    ) {
        _initEscrowNFT(
            owner_,
            baseToken
        );
    }

}