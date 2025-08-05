// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/linkToken.sol";

abstract contract CodeConstants {
    // VRF mock values
    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;

    // LINK / ETH price
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    uint256 public constant SEPOLIA_ETH_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    address public constant SEPOLIA_VRF_COORDINATOR = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 public constant SEPOLIA_VRF_KEYHASH = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    address public constant SEPOLIA_LINK_TOKEN = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
}

contract HelperConfig is Script, CodeConstants {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        uint256 subscriptionId;
        address link;
        address account;
    }

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[SEPOLIA_ETH_CHAIN_ID] = getSepoliaEthConfig();
    }

    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].vrfCoordinator != address(0)) {
          return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
          return getOrCreateAnvilEthConfig();
        } else {
          revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public returns (NetworkConfig memory) {
      return getConfigByChainId(block.chainid);
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether, // 1e16
            interval: 30,
            vrfCoordinator: CodeConstants.SEPOLIA_VRF_COORDINATOR,
            gasLane: CodeConstants.SEPOLIA_VRF_KEYHASH,
            callbackGasLimit: 500000, // 500,000 gas
            subscriptionId: 42413237520757747426443148567620756609004699828021571667330481450197398366578,
            link: CodeConstants.SEPOLIA_LINK_TOKEN,
            account: 0xb6af18eD7a44686805f2d622d16195ca8F379804
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
      // check to see if we set an active network config
      if (localNetworkConfig.vrfCoordinator != address(0)) {
        return localNetworkConfig;
      }

      // Deploy mocks
      vm.startBroadcast();
      VRFCoordinatorV2_5Mock vrfCoordinatorMock = new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UNIT_LINK);
      LinkToken linkToken = new LinkToken();
      vm.stopBroadcast();

      localNetworkConfig = NetworkConfig({
        entranceFee: 0.01 ether,
        interval: 30,
        vrfCoordinator: address(vrfCoordinatorMock),
        gasLane: CodeConstants.SEPOLIA_VRF_KEYHASH,
        callbackGasLimit: 500000,
        subscriptionId: 0,
        link: address(linkToken),
        account: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
      });

      return localNetworkConfig;
    }
}
