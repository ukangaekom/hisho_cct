// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
// Chainlink Functions


import {VRFConsumerBaseV2Plus} from "@chainlink/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";


contract HishoInterestAutomation is VRFConsumerBaseV2Plus{


    // EVENTS
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId,  uint256[] randomWords);  


    // STRUCTS

    struct RequestStatus{
        bool fulfilled // Whether the request has been successfully fulfilled
        bool exists; // Whether a requestId exists  
        uint256[] randomWords
    }

    // VARIABLES

    uint256 interestPercentRate = 1;
    // @notice This is subscription Id this contract uses for funding request. It is initialized in constructor
    uint256 s_subscriptionId;

    // @notice This is the address of the Chainlink VRF Coordinator contract
    address vrfCoordinator = "";

    // @notice This is the maximum gas value you are willing to pay for request in wei
    bytes32 s_keyHash = "";

    // @notice This is the limit of how much gas to use for callback
    uint32 callbackGasLimit = 2500000;

    // @notice This is the number of confirmation that chainlink node should wait before responding
    uint16 requestConfirmatin = 3;

    // @notice This is how many random values you can request in a callback
    uint32 numWords = 1;


    // Keeping Tracks of addresses that rolls the dice throught mapping

    mapping(address=>address) private s_rollers;
    mapping(address=>uint256) private s_results;
    

    constructor(uint256 subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinator){

        s_subscriptionId = subscriptionId;
    }
    
    function updateInterest()   view returns (uint256){


    }
}