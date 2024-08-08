// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/introspection/erc165/mutable/types/MutableERC165Target.sol";
import "thefactory/tokens/erc6909/interfaces/IERC6909.sol";
import "thefactory/tokens/erc6909/interfaces/IERC6909MetadataEnumerated.sol";

struct ERC6909Layout {
    mapping(uint256 tokenId => uint256 supply) totalSupplyFor;
    mapping(uint256 tokenId => mapping(address account => uint256 balance)) balanceForOf;
    mapping(uint256 tokenId => mapping(address account => mapping(address spender => uint256 spendingLimit))) allowanceOfFor;
    mapping(address account => mapping(address spender => bool)) isOperator;
}

library ERC6909Repo {

    // tag::slot[]
    /**
     * @dev Provides the storage pointer bound to a Struct instance.
     * @param table Implicit "table" of storage slots defined as this Struct.
     * @return slot_ The storage slot bound to the provided Struct.
     * @custom:sig slot(ERC6909Layout storage)
     */
    function slot(
        ERC6909Layout storage table
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
        ERC6909Layout storage table
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
     */
    function layout(
        bytes32 slot_
    ) external pure returns(ERC6909Layout storage layout_) {
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
    ) internal pure returns(ERC6909Layout storage layout_) {
        assembly{layout_.slot := slot_}
    }
    // end::_layout[]

}

abstract contract ERC6909Storage {

    using ERC6909Repo for ERC6909Layout;

    address constant ERC6909Repo_ID =
        address(uint160(uint256(keccak256(type(ERC6909Repo).creationCode))));
    bytes32 constant internal ERC6909Repo_STORAGE_RANGE_OFFSET =
        bytes32(uint256(keccak256(abi.encode(ERC6909Repo_ID))) - 1);
    bytes32 internal constant ERC6909Repo_STORAGE_RANGE =
        type(IERC6909).interfaceId;
    bytes32 internal constant ERC6909Repo_STORAGE_SLOT =
        ERC6909Repo_STORAGE_RANGE ^ ERC6909Repo_STORAGE_RANGE_OFFSET;

    function _erc6909()
    internal pure virtual returns(ERC6909Layout storage) {
        return ERC6909Repo._layout(ERC6909Repo_STORAGE_SLOT);
    }

    function _transfer(address sender, address receiver, uint256 id, uint256 amount)
    internal {
        _erc6909().balanceForOf[id][sender] -= amount;
        _erc6909().balanceForOf[id][receiver] += amount;
        emit IERC6909.Transfer(sender, receiver, id, amount);
    }

}

contract ERC6909Target
is
MutableERC165Target,
ERC6909Storage,
IERC6909
{

    /**
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via CALL.
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE IDEMPOTENT
     */
    function _supportedInterfaces()
    internal pure virtual
    override(MutableERC165Target)
    returns(bytes4[] memory supportedInterfaces_) {
        supportedInterfaces_ = new bytes4[](2);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        supportedInterfaces_[0] = type(IERC165).interfaceId;
        supportedInterfaces_[1] = type(IERC6909).interfaceId;
    }

    /**
     * @return functionSelectors_ The function selectors implemented in this contract that MAY be used via CALL.
     */
    function _functionSelectors()
    internal pure virtual
    override(MutableERC165Target)
    returns(bytes4[] memory functionSelectors_) {
        functionSelectors_ = new bytes4[](9);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        functionSelectors_[0] = IERC165.supportsInterface.selector;
        functionSelectors_[1] = IERC6909.totalSupply.selector;
        functionSelectors_[2] = IERC6909.balanceOf.selector;
        functionSelectors_[3] = IERC6909.allowance.selector;
        functionSelectors_[4] = IERC6909.isOperator.selector;
        functionSelectors_[5] = IERC6909.transfer.selector;
        functionSelectors_[6] = IERC6909.transferFrom.selector;
        functionSelectors_[7] = IERC6909.approve.selector;
        functionSelectors_[8] = IERC6909.setOperator.selector;
    }

    function totalSupply(uint256 id)
    public view returns (uint256 amount) {
        return _erc6909().totalSupplyFor[id];
    }

    function balanceOf(address owner, uint256 id)
    public view returns (uint256 amount) {
        return _erc6909().balanceForOf[id][owner];
    }
    function allowance(address owner, address spender, uint256 id)
    public view returns (uint256 amount) {
        return _erc6909().allowanceOfFor[id][owner][spender];
    }

    function isOperator(address owner, address spender)
    public view returns (bool approved) {
        return _erc6909().isOperator[owner][spender];
    }

    function transfer(address receiver, uint256 id, uint256 amount)
    public returns (bool) {
        _transfer(msg.sender, receiver, id, amount);
        return true;
    }

    function transferFrom(address sender, address receiver, uint256 id, uint256 amount)
    public returns (bool) {
        // Accounts can transferFrom their own tokens from themselves.
        if(sender != msg.sender) {
            if(!_erc6909().isOperator[sender][msg.sender]) {
                uint256 spendingLimit_ = _erc6909().allowanceOfFor[id][sender][msg.sender];
                require(spendingLimit_ >= amount);
                _erc6909().allowanceOfFor[id][sender][msg.sender] = spendingLimit_ - amount;
            }
        }
        _transfer(msg.sender, receiver, id, amount);
        return true;
    }

    function approve(address spender, uint256 id, uint256 amount)
    public returns (bool) {
        _erc6909().allowanceOfFor[id][msg.sender][spender] += amount;
        return true;
    }

    function setOperator(address spender, bool approved)
    public returns (bool) {
        _erc6909().isOperator[msg.sender][spender] = approved;
        return true;
    }

}