pragma solidity 0.5.10;

import "./BlockRewardAuRaBase.sol";
import "../interfaces/IBlockRewardAuRaTokens.sol";
import "../interfaces/IStakingAuRaTokens.sol";
import "../interfaces/ITokenMinter.sol";


contract BlockRewardAuRaTokens is BlockRewardAuRaBase, IBlockRewardAuRaTokens {

    // =============================================== Storage ========================================================

    // WARNING: since this contract is upgradeable, do not remove
    // existing storage variables, do not change their order,
    // and do not change their types!

    mapping(address => bool) internal _ercToErcBridgeAllowed;
    mapping(address => bool) internal _nativeToErcBridgeAllowed;
    address[] internal _ercToErcBridgesAllowed;
    address[] internal _nativeToErcBridgesAllowed;

    /// @dev The current bridge's total fee/reward amount of staking tokens accumulated by
    /// the `addBridgeTokenRewardReceivers` function.
    uint256 public bridgeTokenReward;

    /// @dev The reward amount to be distributed in staking tokens among participants (the validator and their
    /// delegators) of the specified pool for the specified staking epoch.
    /// The first parameter is a number of staking epoch. The second one is a pool id.
    mapping(uint256 => mapping(uint256 => uint256)) public epochPoolTokenReward;

    /// @dev The total reward amount in staking tokens which is not yet distributed among pools.
    uint256 public tokenRewardUndistributed;

    /// @dev The address of the minting contract. If it's zero, the address returned by
    /// IStakingAuRaTokens(_stakingContract).erc677TokenContract() is used.
    ITokenMinter public tokenMinterContract;
}
