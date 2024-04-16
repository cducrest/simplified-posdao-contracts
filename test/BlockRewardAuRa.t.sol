// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {BlockRewardAuRa} from "../src/BlockRewardAuRa.sol";
import {AdminUpgradeabilityProxy} from "../src/upgradeability/AdminUpgradeabilityProxy.sol";

interface Vm {
    function prank(address) external;

    function expectRevert() external;

    function load(address target, bytes32 slot) external view returns (bytes32 data);
}

contract BlockRewardAuRaTest is Test {

    event AddedReceiver(uint256 amount, address indexed receiver, address indexed bridge);
    event MintedNative(address[] receivers, uint256[] rewards);

    BlockRewardAuRa public blockRewardAuRa = BlockRewardAuRa(payable(0x481c034c6d9441db23Ea48De68BCAe812C5d39bA));
    AdminUpgradeabilityProxy public proxy = AdminUpgradeabilityProxy(payable(0x481c034c6d9441db23Ea48De68BCAe812C5d39bA));
    address public proxyAdmin = 0x7a48Dac683DA91e4faa5aB13D91AB5fd170875bd;
    address public system = 0xffffFFFfFFffffffffffffffFfFFFfffFFFfFFfE;
    address public bridge = 0x7301CFA0e1756B71869E93d4e4Dca5c7d0eb0AA6;

    uint internal amount = 123456;
    address internal receiver = makeAddr("receiver");

    function setUp() public {
        BlockRewardAuRa newImplementation = new BlockRewardAuRa();
        vm.prank(proxyAdmin);
        proxy.upgradeTo(address(newImplementation));
        assertEq(proxy.implementation(), address(newImplementation));
    }

    function test_addExtraReceiver() public {
        uint queuSize = blockRewardAuRa.extraReceiversQueueSize();

        vm.expectEmit(address(blockRewardAuRa));
        emit AddedReceiver(amount, receiver, bridge);

        vm.prank(bridge);
        blockRewardAuRa.addExtraReceiver(amount, receiver);

        assertEq(queuSize, blockRewardAuRa.extraReceiversQueueSize() - 1);
    }

    function test_mintReward() public {
        addER();

        address[] memory benefactors = new address[](1);
        uint16[] memory kind = new uint16[](1);
        benefactors[0] = address(0);
        kind[0] = 0;

        address[] memory receivers = new address[](1);
        uint256[] memory rewards = new uint256[](1);
        receivers[0] = receiver;
        rewards[0] = amount;

        uint queuSize = blockRewardAuRa.extraReceiversQueueSize();
        
        vm.expectEmit(address(blockRewardAuRa));
        emit MintedNative(receivers, rewards);

        vm.prank(system);
        blockRewardAuRa.reward(benefactors, kind);

        assertEq(queuSize, blockRewardAuRa.extraReceiversQueueSize() + 1);
    }

    function addER() public {
        vm.prank(bridge);
        blockRewardAuRa.addExtraReceiver(amount, receiver);
    }
}
