// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {CodeConstants} from "./HelperConfig.s.sol";
import {LinkToken} from "test/mocks/linkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
  function createSubscriptionUsingConfig() public returns (uint256, address) {
    HelperConfig helperConfig = new HelperConfig();
    address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
    address account = helperConfig.getConfig().account;
    vm.startBroadcast(account);
    (uint256 subscriptionId,) = createSubscription(vrfCoordinator, account);
    vm.stopBroadcast();
    return (subscriptionId, vrfCoordinator);
  }

  function createSubscription(address vrfCoordinator, address account) public returns (uint256, address) {
    vm.startBroadcast(account);
    uint256 subscriptionId = VRFCoordinatorV2_5Mock(vrfCoordinator).createSubscription();
    vm.stopBroadcast();

    return (subscriptionId, vrfCoordinator);
  }
  
  function run() public {
    createSubscriptionUsingConfig();
  }
}

contract FundSubscription is Script, CodeConstants {
  uint256 public constant FUND_AMOUNT = 3 ether; // 3 LINK

  function fundSubscriptionUsingConfig() public {
    HelperConfig helperConfig = new HelperConfig();
    address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
    uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
    address linkToken = helperConfig.getConfig().link;
    address account = helperConfig.getConfig().account;
    fundSubscription(vrfCoordinator, subscriptionId, linkToken, account);
  }

  function fundSubscription(address vrfCoordinator, uint256 subscriptionId, address linkToken, address account) public {
    if (block.chainid == LOCAL_CHAIN_ID) {
      vm.startBroadcast();
      VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(subscriptionId, FUND_AMOUNT * 1000);
      vm.stopBroadcast();
    } else {
      vm.startBroadcast(account);
      LinkToken(linkToken).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subscriptionId));
      vm.stopBroadcast();
    }
  }

  function run() public {
    fundSubscriptionUsingConfig();
  }
}

contract AddConsumer is Script {
  function addConsumerUsingConfig(address mostRecentRaffleDeployment) public {
    HelperConfig helperConfig = new HelperConfig();
    address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
    uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
    address account = helperConfig.getConfig().account;
    addConsumer(vrfCoordinator, subscriptionId, mostRecentRaffleDeployment, account);
  }

  function addConsumer(address vrfCoordinator, uint256 subscriptionId, address mostRecentRaffleDeployment, address account) public {
    vm.startBroadcast(account);
    VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subscriptionId, mostRecentRaffleDeployment);
    vm.stopBroadcast();
  }

  function run() public {
    address mostRecentRaffleDeployment = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
    addConsumerUsingConfig(mostRecentRaffleDeployment);
  }
}