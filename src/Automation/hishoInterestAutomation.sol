// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity 0.8.25;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.4.0/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts@1.4.0/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";



contract HishoGamifiedInterest is VRFConsumerBaseV2Plus {
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
    event RandomRewardRateGeneration(uint256 request_id);
    event DailyInterestRateGenerated(uint256 interest);

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests; /* requestId --> requestStatus */
    mapping(address => bool) private authorizedAddress;

    // Your subscription ID.
    uint256 public s_subscriptionId;

    // Past request IDs.
    uint256[] public requestIds;
    uint256 public lastRequestId;


    uint256 private interest;

    
    bytes32 public keyHash;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 public callbackGasLimit = 2_500_000;

    // The default is 3, but you can set this higher.
    uint16 public requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2_5.MAX_NUM_WORDS.
    uint32 public numWords = 1;


    modifier onlyAuthorized(){
        require(authorizedAddress[msg.sender], "Not permitted");
        _;
    }

    /**
     * HARDCODED FOR AVALANCHE FUJI
     * COORDINATOR: 0x2eD832Ba664535e5886b75D64C46EB9a228C2610
     * KEYHASH: 0xc799bd1e3bd4d1a41cd4968997a4e03dfd2a3c7c04b695881138580163f42887
     * LINK_TOKEN: 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846
     */
    constructor(
        uint256 subscriptionId,
        address _vrfConsumerBaseV2Address,
        bytes32 _keyHash
    ) VRFConsumerBaseV2Plus(_vrfConsumerBaseV2Address) {
        s_subscriptionId = subscriptionId;
        keyHash = _keyHash;
    }

    function enable(address _address) public onlyOwner{
        authorizedAddress[_address] = true;
    }

    function disable(address _address) public onlyOwner{
        authorizedAddress[_address] = false;
    }

    // Assumes the subscription is funded sufficiently.
    // @param enableNativePayment: Set to `true` to enable payment in native tokens, or
    // `false` to pay in LINK
    function requestRandomWords(
        bool enableNativePayment
    ) internal returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) public view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    
    // Called by Chainlink Time based Automation Functions
    function generateRandomNumber() external onlyAuthorized {
        requestRandomWords(false);
        
        emit RandomRewardRateGeneration(lastRequestId);   
    }

    // Called by Chainlink Timebased Automation Functions
    function updateDailyRate() public onlyAuthorized{
        (bool success, uint256[] memory randomWords) = getRequestStatus(lastRequestId);
        
        require(success,"Not fullfilled");
        uint256 randomdigit = randomWords[0];
        interest = randomdigit % 100;
        emit DailyInterestRateGenerated(interest);

            
    }

    function get_interest() public view returns (uint256) {

        return interest;

    }

    function calculateInterest() internal {

    }
}
