// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import "thefactory/context/dcdi/interfaces/IDCDIContract.sol";
import "thefactory/aware/create2/libs/Create2AwareService.sol";
import "thefactory/context/dcdi/libs/DCDIContractService.sol";
import "thefactory/introspection/erc165/mutable/types/MutableERC165Target.sol";

contract DCDIContract is MutableERC165Target, IDCDIContract {

    // using Create2AwareService for address;
    using DCDIContractService for address;

    // solhint-disable-next-line var-name-mixedcase
    address internal immutable SELF;

    // solhint-disable-next-line var-name-mixedcase
    address internal immutable ORIGIN;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 internal immutable INIT_CODE_HASH;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 internal immutable SALT;

    constructor() {
        SELF = address(this);
        ORIGIN = address(msg.sender);
        IContract.Metadata memory metadata_ = address(msg.sender)._queryMetadata(address(this));
        INIT_CODE_HASH = metadata_.initCodeHash;
        SALT = metadata_.salt;
        _initERC165();
    }

    /* -------------------------------------------------------------------------- */
    /*                            INTERNAL DECLARATIONS                           */
    /* -------------------------------------------------------------------------- */

    /**
     * @return supportedInterfaces_ The ERC165 interface IDs implemented in this contract that MAY be used via CALL.
     * @custom:context-exec SAFE IDEMPOTENT
     * @custom:context-exec-state SAFE IDEMPOTENT
     */
    function _supportedInterfaces()
    internal pure virtual
    override(MutableERC165Target)
    returns(bytes4[] memory supportedInterfaces_) {
        supportedInterfaces_ = new bytes4[](3);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        supportedInterfaces_[0] = type(IERC165).interfaceId;
        supportedInterfaces_[1] = type(IContract).interfaceId;
        supportedInterfaces_[2] = type(IDCDIContract).interfaceId;
    }

    /**
     * @return functionSelectors_ The function selectors implemented in this contract that MAY be used via CALL.
     */
    function _functionSelectors()
    internal pure virtual
    override(MutableERC165Target)
    returns(bytes4[] memory functionSelectors_) {
        functionSelectors_ = new bytes4[](7);
        // ERC165 support IS Execution Context SAFE and NOT IDEMPOTENT.
        functionSelectors_[0] = IERC165.supportsInterface.selector;
        functionSelectors_[1] = IContract.origin.selector;
        functionSelectors_[2] = IContract.self.selector;
        functionSelectors_[3] = IContract.initCodeHash.selector;
        functionSelectors_[4] = IContract.salt.selector;
        functionSelectors_[5] = IContract.metadata.selector;
        functionSelectors_[6] = IDCDIContract.initData.selector;
    }

    function origin()
    public view virtual
    returns(address origin_) {
        return ORIGIN;
    }

    function self()
    public view virtual
    returns(address self_) {
        return SELF;
    }

    function initCodeHash()
    public view virtual
    returns(bytes32 initCodeHash_) {
        return INIT_CODE_HASH;
    }

    function salt()
    public view virtual
    returns(bytes32 salt_) {
        return SALT;
    }

    function metadata()
    public view returns(IContract.Metadata memory metadata_) {
        metadata_ = IContract.Metadata({
            origin: ORIGIN,
            initCodeHash: INIT_CODE_HASH,
            salt: SALT
        });
    }

    /**
     * @return initData_ The data injected to initialize this contract.
     */
    function initData()
    public view returns(bytes memory initData_) {
        initData_ = SELF._queryInitData(
                ORIGIN,
                INIT_CODE_HASH,
                SALT
            );
    }

}