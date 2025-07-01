// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// import {Script, Console} from "forge-std/Script.sol";
import {Script} from "forge-std/Script.sol";
import { HishoOnchain} from "../src/hishoOnchain.sol";


contract DeployHishoGamifiedStaking is Script{
    HishoOnchain public HishoGamifiedStaking;

    function run() external returns(HishoOnchain) {
        vm.startBroadcast();
        HishoGamifiedStaking = new HishoOnchain(

        );
        vm.stopBroadcast();



    }
}
