// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract DataConsumerV3 {
    AggregatorV3Interface internal eth_dataFeed;
    AggregatorV3Interface internal avax_dataFeed;
    AggregatorV3Interface internal link_dataFeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    /**
     * Network: Fuji Testnet
     * Aggregator: ETH/USD
     * Address: 0x86d67c3D38D2bCeE722E601025C25a575021c6EA
     */
    /**
     * Network: Fuji Testnet
     * Aggregator: AVAX/USD
     * Address: 0x5498BB86BC934c8D34FDA08E81D444153d0D06aD
     */
    /**
     * Network: Fuji Testnet
     * Aggregator: LINK/USD
     * Address: 0x34C4c526902d88a3Aa98DB8a9b802603EB1E3470
     */
    constructor() {
        eth_dataFeed = AggregatorV3Interface(
            0x86d67c3D38D2bCeE722E601025C25a575021c6EA
        );

        avax_dataFeed = AggregatorV3Interface(
            0x5498BB86BC934c8D34FDA08E81D444153d0D06aD
        );

        link_dataFeed = AggregatorV3Interface(
            0x34C4c526902d88a3Aa98DB8a9b802603EB1E3470
        );
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkEthDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = eth_dataFeed.latestRoundData();
        return answer;
    }
    function getChainlinkAvaxDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = avax_dataFeed.latestRoundData();
        return answer;
    }
    function getChainlinkLinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = link_dataFeed.latestRoundData();
        return answer;
    }
}
