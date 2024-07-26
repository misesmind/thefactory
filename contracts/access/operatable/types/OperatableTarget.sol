// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "../libs/OperatableLayout.sol";
import "../interface/IOperatable.sol";
import "../../ownable/types/OwnableTarget.sol";

contract OperatableTarget is OwnableTarget, IOperatable {

    using OperatableLayout for OperatableStruct;

    address constant OperatableLayout_ID = address(uint160(uint256(keccak256(type(OperatableLayout).creationCode))));
    bytes32 constant internal OperatableLayout_STORAGE_RANGE_OFFSET = bytes32(uint256(keccak256(abi.encode(OperatableLayout_ID))) - 1);
    bytes32 internal constant OperatableLayout_STORAGE_RANGE = type(IOperatable).interfaceId;
    bytes32 internal constant OperatableLayout_STORAGE_SLOT = OperatableLayout_STORAGE_RANGE ^ OperatableLayout_STORAGE_RANGE_OFFSET;

    function _operatable()
    internal pure virtual returns(OperatableStruct storage) {
        return OperatableLayout._layout(OperatableLayout_STORAGE_SLOT);
    }

    modifier onlyOperator(address query) {
        require(isOperator(query), "Operator: caller is not an operator");
        _;
    }

    modifier onlyOwnerOrOperator(address query) {
        require(isOperator(query) || _isOwner(query));
        _;
    }

    function isOperator(address query) public view virtual returns(bool) {
        return _operatable().isOperator[query];
    }

    function _isOperator(address query, bool approval) internal {
        _operatable().isOperator[query] = approval;
    }

    function setOperator(
        address operator,
        bool status
    ) public virtual onlyOwnerOrOperator(msg.sender) returns(bool) {
        // require(msg.sender == minter, "Operator: caller is not the minter");
        // operators[operator] = status;
        _isOperator(operator, status);
        return true;
    }

}