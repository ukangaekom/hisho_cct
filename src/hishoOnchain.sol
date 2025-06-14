// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {HishoInterestAutomation} from "./hishoCrossChain.sol";


/*
* @title HishoOnchain
* @author Ekomabasi Martin Ukanga
* @notice This encourages user to claim their hisho tokens onchain when they stake their NFTs, AVAX, LINK, or Native Chain Tokens
* @notice The daily interest rate is randomized by Chainlink VRF
* @notice The daily interest rate is called by Chainlink Automation
*/

contract HishoOnchain is Ownable{

    // Errors
    error HishoOnchain_maxStringLengthExceeded();
    error HishoOnchain_wrongStakedOrderId();
    error HishoOnchain_notEnoughEthBalance();
    error HishoOnchain_notEnoughAvaxBalance();
    error HishoOnchain_notEnoughLinkBalance();
    error HishoOnchain_notAuthorized();
    error HishoOnchain_stakeTimeNotExceeded();
    error HishoOnchain_destinationChainNotSupported();
    error HishoOnchain_zeroOrInvalidAddress();

    // Structs
    struct Stake{
        uint256 id;
        uint256 start_time;
        uint256 end_time;
        uint256 amount;
        uint256 hisho_reward;
        uint256 number_of_days;
        address tokenType;
        bool claimed;
    }



    // VARIABLES

    uint256 private counter_id = 0;

    /*
    * @note The monthly reward rate ranges from to 10 to 20%
    * @note The value of the dailyReward ranges from 100 to 200 in number so it is basically maxed at 1000 which is 100%
    */ 
    uint8 private dailyRewardRate = 0;

    // MAPPINGS
    mapping(uint256 id => Stake orderDetail) public stakedOrderDetail;

    //Order ids
    mapping(address user => uint256[] order_ids) public openedStakeOrders;
    mapping(address user => uint256[] order_ids) public closedStakeOrders;


    mapping(address user => uint256 balance) private HishoBalance;

    // Token Balances
    mapping(address user => uint256 balance) private RedrawableEthBalance;
    mapping(address user => uint256 balance) private RedrawableAvaxBalance;
    mapping(address user => uint256 balance) private RedrawableLinkBalance;

    // Locked Balances
    mapping(address user => uint256 balance) private LockedEthBalance;
    mapping(address user => uint256 balance) private LockedAvaxBalance;
    mapping(address user => uint256 balance) private LockedLinkBalance;

    // Social Media
    mapping(address user =>bytes) public Telegram; //Registering telegram username
    mapping(address user =>bytes) public X_app; //Registering twitter username
    mapping(address user =>bytes) public Email; //Register with email

    mapping(address=> bool) private AuthorizedCaller; //Authorized Caller Address



    constructor(){

    }


    // MODIFIERS

    modifier onlyAuthorized(){
        require(AuthorizedCaller[msg.sender] == true, "You are not authorized to call this function");
        _;
    }



    // CONSTRUCTOR

    constructor() {

    }



    // ADMIN FUNCTIONS

    function enableAuthorization(address _caller) public onlyOwner{
        AuthorizedCaller[_caller] = true;


    }

    function disableAuthorization(address _caller) public onlyOwner{
        AuthorizedCaller[_caller] = false;
    }



    

    // REGISTER FUNCTIONS
    functions registerTelegramUsername(string memory _telegramUserName) public{

        Telegram[msg.sender] = abi.encode(_telegramUserName);
        

    }

    function registerXUsername(string memory _xUserName) public{
        X_app[msg.sender] = abi.encode(_xUserName);

    }
    


    function registerEmailUsername(string memory _emailUserName) public{
        Email[msg.sender] = abi.encode(_emailUserName);

    }



    // GETTER FUNCTIONS

    // Get Social Platforms Functions
    function getTelegramName() public{}


    function getXName() public{

    }

    function getEmailName() public {

    }

    //Get Balance and Reward Functions 

    function getStakeRewardBalance(uint256 _orderId) public view returns (uint256){
        return stakedOrderDetail[_orderId][hisho_reward];
    }


    function getDailyRewardRate() public view returns (uint256) {
        return dailyRewardRate;
    }

    function getRedrawableEthBalance(address _user) public view returns (uint256) {

        return RedrawableEthBalance[_user];

    }
    
    function getRedrawableAvaxBalance(address _user) public view returns (uint256) {

        return RedrawableAvaxBalance[_user];

    }

    function getRedrawableLinkBalance(address _user) public view returns (uint256) {

        return RedrawableLinkBalance[_user];

    }

    function getLockedEthBalance(address _user) public view returns (uint256) {

        return LockedEthBalance[_user];

    }

    function getLockeAvaxBalance(address _user) public view returns (uint256) {
        return LockedAvaxBalance[_user];


    }
    function getLockedLinkBalance(address _user) public view returns (uint256) {
        return LockedLinkBalance[_user];

    }


    // Get Order Functions

    function getStakedOrderDetail(uint256 _id) public view returns (memory Stake) {

        return stakedOrderDetail[_id];

    }

    function getAllOpenedStakeOrder(address _user) public view returns(uint256[]){
        return openedStakeOrders[_user];
    }

    function getAllClosedStakeOrder(address _user) public view returns (uint256[]) {

        return closedStakeOrders[_user]

    }




    //SETTER FUNCTIONS 


    /* 
    * @notice The contracts has an onlyAuthorized Modifier. Chainlink Automation Functions is Authorized in the contract to call the function.
    * @notice Chainlink Automation Function is to call this function every month.
    * @notice Chainlink VRF is also called in the function set the random daily interest
    */
    function setDailyRewardRate() public onlyAuthorized{
        

    }



    // CLAIM FUNCTIONS

    function claimReward() public {

    }

    function claimRewardX() public onlyAuthorized{

    }

    function claimRewardTelegram() public onlyAuthorized{

    }



    function claimRewardEmail() public onlyAuthorized{

    }


    //  STAKE RELATED FUNCTIONS

    function stake() public onlyAuthorized{

    }

    function stakeOnX() public onlyAuthorized{

    }
    function stakeonTelegram() public onlyAuthorized{

    }

    


    function unstake() public onlyAuthorized{

    }

    // REDRAW RELATED FUNCTIONS

    function redraw() public payable{

    }

    function fund() payable payable{

    }




    // UTITLITY FUNCTIONS 

    function deleteCloseStakeOrders() {

    }



}