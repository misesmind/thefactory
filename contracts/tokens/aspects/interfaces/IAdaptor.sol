// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @notice Allows an adaptor vault to declare which token is it adapting to another interface.
 */
interface IAdaptor {

    /**
     * @return token The token of which this contract is an adaptor.
     */
    function adaptorOf()
    external view returns(address token);

    /**
     * @return interfaceId The interface this contract consumes to adapt to a different interface.
     */
    function adaptsFrom()
    external view returns(bytes4 interfaceId);

}