// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

// Openzeppelin Functions
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";




/*
* @title Hisho Token
* @author Ekomabasi Ukanga
* @notice This encourages users to deposit into a vault and gains interest in hisho
* @notice The interest rate in the smart contract can only decrease
* @notice Each user will own their own interest rate.
*/

contract HishoToken is ERC20{

    // Declaration of Variables
    uint256 public s_InterestRate = 5e10;

    constructor() ERC20("Hisho Token", "Hisho"){


    }


    // Modifiers


    function setInterestRate(uint256 _newInterestRate) external {

    }


}