pragma solidity 0.8.22;

import "./BaseAdminUpgradeabilityProxy.sol";


/**
 * @title AdminUpgradeabilityProxy
 * @dev Extends from BaseAdminUpgradeabilityProxy with a constructor for 
 * initializing the implementation, admin, and init data.
 */
contract AdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, UpgradeabilityProxy {
    /**
     * Contract constructor.
     * @param _logic address of the initial implementation.
     * @param _admin Address of the proxy administrator.
     */
    constructor(address _logic, address _admin) UpgradeabilityProxy(_logic, new bytes(0)) payable {
        assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
        _setAdmin(_admin);
    }
}
