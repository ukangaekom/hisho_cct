// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import  "@openzeppelin/contracts/token/ERC721/ERC721.sol";



contract HishoCharacter is ERC721{

    using Counters for Counters.Counter;

    Counters.Counter public tokenIdCounter;

}