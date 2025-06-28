// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;
// Chainlink Functions


import {VRFConsumerBaseV2Plus} from "@chainlink/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";


contract HishoInterestAutomation is VRFConsumerBaseV2Plus{


    


    // STRUCTS

    struct RequestStatus{
        bool fulfilled; // Whether the request has been successfully fulfilled
        bool exists; // Whether a requestId exists  
        uint256[] randomWords;
    }

    // VARIABLES

    uint256 interestPercentRate = 1;
    // @notice This is subscription Id this contract uses for funding request. It is initialized in constructor
    uint256 public s_subscriptionId;

    // @notice This is the address of the Chainlink VRF Coordinator contract for AVALANCHE TESTNET
    address vrfCoordinatorV2Plus = 0x5C210eF41CD1a72de73bF76eC39637bB0d3d7BEE;

    // @notice This is the maximum gas value you are willing to pay for request in wei in AVALANCHE TESTNET
    bytes32 s_keyHash = 0xc799bd1e3bd4d1a41cd4968997a4e03dfd2a3c7c04b695881138580163f42887;

    // @notice This is the max limit of how much gas to use for callback
    uint32 callbackGasLimit = 2500000;

    // @notice This is the number of confirmation that chainlink node should wait before responding
    uint16 requestConfirmatin = 3;

    // @notice This is how many random values you can request in a callback
    uint32 numWords = 1;


    // Request Id
    uint256 public s_requestId;


    // Keeping Tracks of addresses that rolls the dice throught mapping

    mapping (uint256 requestId => uint256 Interest) public request;



    // EVENTS
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId,  uint256[] randomWords);  
    

    constructor(uint256 subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinatorV2Plus){

        s_subscriptionId = subscriptionId;
        s_vrfCoordinator = IVRFCoordinatorV2Plus(vrfCoordinatorV2Plus);
    }

    function fulfilledRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords

    ) internal override {

        // requesting for only 1 random word from 10 to 200
        s_randomRange = (randomWords[0] % 200) + 10;

    }
    
    function updateInterest()   view returns (uint256){


    }
}