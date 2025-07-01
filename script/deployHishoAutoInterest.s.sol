// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// import {Script, Console} from "forge-std/Script.sol";
import {Script} from "forge-std/Script.sol";
import {HishoGamifiedInterest} from "../src/Automation/hishoInterestAutomation.sol";


contract DeployHishoAutomatedInterest is Script{
    HishoGamifiedInterest public AutomationVrfInterest;

    function run() external returns(HishoGamifiedInterest) {
        vm.startBroadcast();
        AutomationVrfInterest = new HishoGamifiedInterest();
        vm.stopBroadcast();



    }
}
