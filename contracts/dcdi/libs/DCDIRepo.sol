// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

import {ImmutableRepo} from "thefactory/storage/immutable/ImmutableRepo.sol";

/**
 * @title DCDIRepo - A Repository Library executing DCDI storage operations.
 * @author mises mind
 * @dev Provides the main integration for injecting data.
 */
library DCDIRepo {

  using ImmutableRepo for address;
  using ImmutableRepo for bytes;

  using DCDIRepo for address;
  using DCDIRepo for bytes;
  using DCDIRepo for bytes32;

  /* -------------------------------------------------------------------------- */
  /*                          Arbitrary DCDI Injection                          */
  /* -------------------------------------------------------------------------- */

  /**
   * @notice Checks for the presence of bytecode that may store data.
   * @param writer The address that wrote the injected data.
   * @param consumer The address of the intended consumer of the injected data.
   * @param key The value used as the CREATE2 salt for storing the injected data.
   * @return isInjected Boolean indicating if bytecode is present.
   */
  function _isInjected(
    address writer,
    address consumer,
    bytes32 key
  ) internal view returns(bool isInjected) {
    isInjected = writer._isPresentFrom(keccak256(abi.encode(consumer, key)));
  }

  /**
   * @param data The encoded data to be injected for any domain specific process.
   * @param consumer The address of the intended consumer of the injected data.
   * @param key The value used as the CREATE2 salt for storing the injected data.
   * @return pointer The address under which the the injected data has been stored.
   */
  function _injectData(
    bytes memory data,
    address consumer,
    bytes32 key
  ) internal returns(address pointer) {
    pointer = data._mapBlob(keccak256(abi.encode(consumer, key)));
  }

  /**
   * @param writer The address that wrote the injected data.
   * @param consumer The address of the intended consumer of the injected data.
   * @param key The value used as the CREATE2 salt for storing the injected data.
   */
  function _queryInjectedData(
    address writer,
    address consumer,
    bytes32 key
  ) internal view returns(bytes memory initData) {
    initData = writer._queryBlobFromOf(keccak256(abi.encode(consumer, key)));
  }

  /* -------------------------------------------------------------------------- */
  /*                               IDLDAP.initData                              */
  /* -------------------------------------------------------------------------- */

//   /**
//    * @param lu The LogicUnit of the consumer of the injected data.
//    * @param id The UniqueId of the consumer of the injected data.
//    * @return key The key that will be used as part of the CREATE2 salt with the ImmutableRepo to store the injected data.
//    */
//   function _initDataKey(
//     bytes32 lu,
//     bytes32 id
//   ) internal pure returns(bytes32 key) {
//     key = keccak256(abi.encode(lu, id));
//   }

//   /**
//    * @dev Intenal function format is to use the value to be stored as the first paramater.
//    * @param initData The data to be injected using the ImmutableRepo.
//    * @param dnInitDataKey The key to use with the ImmutableRepo to store the initData.
//    */
//   function _injectInitData(
//     bytes memory initData,
//     bytes32 dnInitDataKey
//   ) private returns(address pointer) {
//     pointer = initData._mapBlob(dnInitDataKey);
//   }

//   /**
//    * @dev To be used to inject the initialization data to be consumed by a new Domain Member inside it's own constrcutor.
//    * @dev Init data for TargetPkgs should use the _injectData() function.
//    * @param lu The Logic Unit of the consumer of the initialization data to be injected.
//    * @param id The UniqueId of the consumer of the injected data.
//    * @return pointer The address under which the the injected data has been stored.
//    */
//   function _injectInitData(
//     bytes32 lu,
//     bytes32 id,
//     bytes memory initData
//   ) internal returns(address pointer) {
//     pointer = _injectInitData(initData, lu._initDataKey(id));
//   }

//   /**
//    * @param dc The DomainController from which the DomainMember was deployed.
//    * @param key The SSTORE2 key used to inject the initialization data into the context.
//    * @return initData The data that was injected into the Chain Context to initialize a new DomainMember.
//    */
//   function _queryInitData(
//     address dc,
//     bytes32 key
//   ) private view returns(bytes memory initData) {
//     initData = dc._queryBlobFromOf(key);
//   }

//   /**
//    * @param dc The DomainController from which the DomainMember was deployed.
//    * @param lu The DLDAP Logic Unit of the DomainMember whose initialization data is being loaded.
//    * @return initData The DomainMember initialization data loaded using SSTORE2.
//    */
//   function _queryInitData(
//     address dc,
//     bytes32 lu,
//     bytes32 id
//   ) internal view returns(bytes memory initData) {
//     initData = _queryInitData(dc, lu._initDataKey(id));
//   }

}