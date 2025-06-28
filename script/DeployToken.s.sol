// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Script, Console} from "forge-std/Script.sol";
import {MyToken} from "../src/CCIP/hishoCCT.sol";


contract DeployToken is Script{
    function run external returns(MyToken) {
        vm.startBroadCast();
        MyToken HishoToken = new MyToken()
        vm.stopBroadCast();



    }
}
