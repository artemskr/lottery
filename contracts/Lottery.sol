// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

error Lottery_NotEnoughETHEntered();

contract Lottery is VRFConsumerBaseV2 {
    /* State variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCooordinator;
    bytes32 private immutable i_gasLane;

    /* Events */
    event LotteryEnter(address indexed player);

    constructor(address vrfCoordinatorV2, uint256 entranceFee, bytes32 gasLane) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCooordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
    }

    function enterLottery() public payable {
        if (msg.value < i_entranceFee) {
            revert Lottery_NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
        emit LotteryEnter(msg.sender);
    }

    function requestRandomWinner() external {
        // requirest random number
        // Once we get it. do something with it
        // 2 transaction process
        i_vrfCooordinator.requestRandomWords(
          i_gasLane, // gasLane 14.18.55
          s_subscriptionId,
          requestConfirmation,
          callbackGasLimit,
          numWords
        );
    }

    function fulfillRandomWords(uint256 requiestId, uint256[] memory randomWords) internal override {
      
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
