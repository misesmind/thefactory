// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libs/UniV2AwareLayout.sol";
import {IUniV2Aware} from "../interfaces/IUniV2Aware.sol";
import {IUniswapV2Router02} from "../../interfaces/IUniswapV2Router02.sol";
import {IUniswapV2Factory} from "../../interfaces/IUniswapV2Factory.sol";

abstract contract UniV2AwareStorage {

    /* ------------------------------ LIBRARIES ----------------------------- */

    using UniV2AwareLayout for UniV2Aware;

    /* ------------------------- EMBEDDED LIBRARIES ------------------------- */

    // TODO Replace with address of deployed library.
    // Normally handled by usage for storage slot.
    // Included to facilitate automated audits.
    address constant UNIV2AWARE_LAYOUT_ID = address(uint160(uint256(keccak256(type(UniV2AwareLayout).creationCode))));

    /* ---------------------------------------------------------------------- */
    /*                                 STORAGE                                */
    /* ---------------------------------------------------------------------- */

    /* -------------------------- STORAGE CONSTANTS ------------------------- */
  
    // Defines the default offset applied to all provided storage ranges for use when operating on a struct instance.
    // Subtract 1 from hashed value to ensure future usage of relevant library address.
    bytes32 constant internal UNIV2AWARE_STORAGE_RANGE_OFFSET = bytes32(uint256(keccak256(abi.encode(UNIV2AWARE_LAYOUT_ID))) - 1);

    // The default storage range to use with the Repo libraries consumed by this library.
    // Service libraries are expected to coordinate operations in relation to a interface between other Services and Repos.
    bytes32 internal constant UNIV2AWARE_STORAGE_RANGE = type(IUniV2Aware).interfaceId;
    bytes32 internal constant UNIV2AWARE_STORAGE_SLOT = UNIV2AWARE_STORAGE_RANGE ^ UNIV2AWARE_STORAGE_RANGE_OFFSET;

    function _uniV2()
    internal pure virtual returns(UniV2Aware storage) {
        return UniV2AwareLayout._layout(UNIV2AWARE_STORAGE_SLOT);
    }

    // TODO Deprecate
    function _initUniV2Aware(
        address router
    ) internal {
        _initUniV2Aware(
            IUniswapV2Router02(router),
            IUniswapV2Factory(IUniswapV2Router02(router).factory())
        );
    }

    function _initUniV2Aware(
        IUniswapV2Router02 router
    ) internal virtual {
        _initUniV2Aware(
            router,
            IUniswapV2Factory(IUniswapV2Router02(router).factory())
        );
    }

    function _initUniV2Aware(
        IUniswapV2Router02 router,
        IUniswapV2Factory factory
    ) internal virtual {
        _uniV2Router(router);
        _uniV2Factory(factory);
    }

    function _uniV2Protocol() internal view virtual returns(address factory, address router) {
        return (address(_uniV2Factory()), address(_uniV2Router()));
    }

    function _uniV2Router() internal view virtual returns(IUniswapV2Router02) {
        return IUniswapV2Router02(_uniV2().router);
    }

    function _uniV2Router(IUniswapV2Router02 router) internal virtual {
        _uniV2().router = address(router);
    }

    function _uniV2Factory() internal view virtual returns(IUniswapV2Factory) {
        return IUniswapV2Factory(_uniV2().factory);
    }

    function _uniV2Factory(IUniswapV2Factory factory) internal virtual {
        _uniV2().factory = address(factory);
    }

}