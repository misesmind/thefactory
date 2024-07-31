// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title IGreeter - Interface exposing string based messanger.
 * @title misesmind <misesmind@proton.me>
 */
interface IGreeter {

  function setMessage(
    string memory newMessage
  ) external returns(bool success);

  function getMessage()
  external view returns(string memory message);

}