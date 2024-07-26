// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "./ERC721Storage.sol";
import "thefactory/utils/primitives/UInt.sol";
import "thefactory/introspection/erc165/mutable/types/MutableERC165Target.sol";
import {IERC721Metadata} from "../interfaces/IERC721Metadata.sol";

abstract contract ERC721Target is MutableERC165Target, ERC721Storage, IERC721, IERC721Metadata, IERC721Errors {

    using UInt for uint256;

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual returns (uint256) {
        if (owner == address(0)) {
            revert ERC721InvalidOwner(address(0));
        }
        // return _balances[owner];
        return _balanceOf(owner);
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        return _requireOwned(tokenId);
    }

    function name() public view virtual returns (string memory) {
        // return _name;
        return _name();
    }

    function symbol() public view virtual returns (string memory) {
        // return _symbol;
        return _symbol();
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId._toString()) : "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual {
        _approve(to, tokenId, msg.sender);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual returns (address) {
        _requireOwned(tokenId);

        return _getApproved(tokenId);
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        // return _operatorApprovals[owner][operator];
        return _isOperator(owner, operator);
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual {
        // if (to == address(0)) {
        //     revert ERC721InvalidReceiver(address(0));
        // }
        // // Setting an "auth" arguments enables the `_isAuthorized` check which verifies that the token exists
        // // (from != 0). Therefore, it is not needed to verify that the return value is not 0 here.
        // address previousOwner = _update(to, tokenId, msg.sender);
        // if (previousOwner != from) {
        //     revert ERC721IncorrectOwner(from, tokenId, previousOwner);
        // }
        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual {
        _safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual {
        // transferFrom(from, to, tokenId);
        // _transferFrom(from, to, tokenId);
        // _checkOnERC721Received(from, to, tokenId, data);
        _safeTransferFrom(from, to, tokenId, data);
    }
    
}