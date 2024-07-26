// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

interface IOperatable {

    function isOperator(address query) external view returns(bool);

    function setOperator(address newOperator, bool approval) external returns(bool);

}