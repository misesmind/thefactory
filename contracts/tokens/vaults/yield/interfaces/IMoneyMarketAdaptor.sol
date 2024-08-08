// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "thefactory/tokens/aspects/interfaces/IAdaptor.sol";

interface IMoneyMarketAdaptor is IAdaptor {

    /**
     * @return tokenId The token ID this contract adapts to another interface.
     */
    function adaptedTokenId()
    external view returns(uint256 tokenId);

}