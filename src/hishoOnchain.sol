// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;


import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {HishoInterestAutomation} from "./hishoCrossChain.sol";
import {MyToken as Hisho} from "./CCIP/hishoCCT.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";



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
    error HishoOnchain_FailedMintingHisho();


    
    // Structs
    struct Stake{
        address staker;
        uint256 id;
        uint256 start_time;
        uint256 end_time;
        uint256 assetAmount;
        uint8 assetRewardRate;
        uint256 hisho_reward;
        address tokenAddress
        bool claimed;
    }



    // VARIABLES

    uint256 private counter_id = 0;
    address public hisho_token_address; //For any of the supported blockchains. E.g Avalanche
    

    /*
    * @note The monthly reward rate ranges from to 1% to 10%
    * @note The value of the dailyReward ranges from 10 to 100 in number so it is basically maxed at 1000 which is 100%
    */ 
    uint8 private dailyRewardRate = 0;

    // MAPPINGS

    mapping(address token => address _priceFeed) public priceFeed;
    mapping(uint256 id => Stake orderDetail) public stakedOrderDetail;

    //Order ids
    mapping(address user => uint256[] order_ids) public openedStakeOrders;
    mapping(address user => uint256[] order_ids) public closedStakeOrders;


    mapping(address user => uint256 balance) private HishoBalance;

    // Token Balances
    mapping(address user => mapping(address token => uint256 amount)) private WithdrawableAsset;
    

    // Locked Balances
    mapping(address user => mapping(address token => uint256 amount)) private LockedAsset;
   
    // Social Media
    mapping(address user =>bytes) public Telegram; //Registering telegram username
    mapping(bytes user =>address) public TelegramReverse; //Registering telegram username
    mapping(address user =>bytes) public X_app; //Registering twitter username
    mapping(bytes user =>address) public X_appReverse; //Registering twitter username
    mapping(address user =>bytes) public Email; //Register with email
    mapping(bytes user =>address) public EmailReverse; //Register with email

    mapping(address=> bool) private AuthorizedCaller; //Authorized Caller Address

    

    // @param address _hishoToken -> This is the ERC\ 
    constructor(address _hishoToken){

        hisho_token_address = _hishoToken;

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

    function registerBaseAssets(address _tokenAddress, address _priceFeed) public onlyOwner{
        require(_tokenAddress != address(0),"address not supported");
        priceFeed[_tokenAddress] = _priceFeed;

    }



    

    // REGISTER FUNCTIONS
    functions registerTelegramUsername(string memory _telegramUserName) public{
        bytes user = stringToBytes(_telegramUserName);
        require(Telegram[msg.sender] == bytes32(0) || TelegramReverse[user] == address(0),"Username Unavailable");
        Telegram[msg.sender] = user;
        TelegramReverse[user] = msg.sender;
        

    }

    function registerXUsername(string memory _xUserName) public{
        bytes user = stringToBytes(_telegramUserName);
        require(X_app[msg.sender] == bytes32(0) || X_appReverse[user] == address(0),"Username Unavailable");
        X_app[msg.sender] = user;
        X_appReverse[user] = msg.sender;

    }
    


    function registerEmailUsername(string memory _emailUserName) public{
        bytes user = stringToBytes(_telegramUserName);
        require(Email[msg.sender] == bytes32(0) || EmailReverse[user] == address(0),"Username Unavailable");
        Email[msg.sender] = user;
        EmailReverse[user] = msg.sender;


    }



    // GETTER FUNCTIONS

    // Get Social Platforms Functions
    function getTelegramName(address _user) public view returns(bytes32){

        return Telegram[_user];
    }


    function getXName(address _user) public view returns returns(bytes32) {
        return X_app[user];

    }

    function getEmailName(address _user) public view returns(bytes32) {
        return Email[_user];

    }

    //Get Balance and Reward Functions 

    function getStakeRewardBalance(uint256 _orderId) public view returns (uint256){
        return stakedOrderDetail[_orderId].hisho_reward;
    }


    function getDailyRewardRate() public view returns (uint256) {
        return dailyRewardRate;
    }
    
    function getWithdrawableAsset(address _user, address _tokenAddress) public view returns (uint256) {

        return WithdrawableAsset[_user][_tokenAddress];

    }

   
    function getLockedAsset(address _user, address _tokenAddress) public view returns (uint256) {

        return LockedAsset[_user][_tokenAddress];

    }


    // Get Order Functions

    function getStakedOrderDetail(uint256 _id) public view returns (Stake memory) {

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
    * @notice The contracts has an onlyAuthorized Modifier. 
      Chainlink Automation Functions is Authorized in the contract to call the function.
    * @notice Chainlink Automation Function is to call this function every month.
    * @notice Chainlink VRF is also called in the function set the random daily interest
    */
    function setDailyRewardRate(uint8 _dailyRate) public onlyAuthorized{
        if(_dailyRate > 10 && _daily < 100){

            dailyRewardRate = _dailyRate;
        }
        
        

    }



    // CLAIM FUNCTIONS

    function claimReward(uint256 _id) public {

        // Check if it is the owner of the staked order
        require(stakedOrderDetail[_id].staker == msg.sender, "You are not the owner");
        // Check if the stake order is already claimed
        require(stakedOrderDetail[_id].claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= stakedOrderDetail[_id].end_time,"Not due")

        
        // Change state to claimed
        stakedOrderDetail[_id].claimed = true;
        // Unlock the Staked Asset

        // 
        
        // Mint The Required Hisho Tokens to the staker address

        Hisho(hisho_token_address).mint(stakedOrderDetail[_id].staker,
         stakedOrderDetail[_id].hisho_reward);

        

    }

    function claimRewardX(uint256 _id, string memory _x_username) public onlyAuthorized{

        // Check if it is the owner of the staked order
        require(stakedOrderDetail[_id].staker == X_app[stringToBytes(_x_username)], "You are not the owner");
        // Check if the stake order is already claimed
        require(stakedOrderDetail[_id].claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= stakedOrderDetail[_id].end_time,"Not due")

        
        // Change state to claimed
        stakedOrderDetail[_id].claimed = true;
        // Unlock the Staked Asset

        // 
        
        // Mint The Required Hisho Tokens to the staker address

        Hisho(hisho_token_address).mint(stakedOrderDetail[_id].staker, stakedOrderDetail[_id].hisho_reward);
    }

    function claimRewardTelegram(uint256 _id, string memory _telegram_username) public onlyAuthorized{

        // Check if it is the owner of the staked order
        require(stakedOrderDetail[_id].staker == Telegram[stringToBytes(_telegram_username)], "You are not the owner");
        // Check if the stake order is already claimed
        require(stakedOrderDetail[_id].claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= stakedOrderDetail[_id].end_time,"Not due")

        
        // Change state to claimed
        stakedOrderDetail[_id].claimed = true;
        // Unlock the Staked Asset

        // 
        
        // Mint The Required Hisho Tokens to the staker addres
        Hisho(hisho_token_address).mint(stakedOrderDetail[_id].staker, stakedOrderDetail[_id].hisho_reward);
    }



    function claimRewardEmail(uint256 _id, string memory _email_username) public onlyAuthorized{

        // Check if it is the owner of the staked order
        require(stakedOrderDetail[_id].staker == Telegram[stringToBytes(_email_username)], "You are not the owner");
        // Check if the stake order is already claimed
        require(stakedOrderDetail[_id].claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= stakedOrderDetail[_id].end_time,"Not due")

        
        // Change state to claimed
        stakedOrderDetail[_id].claimed = true;
        // Unlock the Staked Asset

        // 
        
        // Mint The Required Hisho Tokens to the staker addres
        Hisho(hisho_token_address).mint(stakedOrderDetail[_id].staker, stakedOrderDetail[_id].hisho_reward);

    }


    //  STAKE RELATED FUNCTIONS

    function stake(address _tokenAddress, uint256 _amount) public onlyAuthorized{
        require(priceFeed[_tokenAddress], "Token not Supported");

        //  Lock the Asset Staked;


        uint256 hisho_reward = getReward(_tokenAddress,_amount);
        
        Stake memory stake_order = new Stake({
            staker:msg.sender,
            id: counter_id,
            start_time: block.timestamp,
            end_time: (block.timestamp + 7 days),
            assetAmount: _amount,
            assetRewardRate: dailyRewardRate,
            hisho_reward: reward,
            tokenAddress:_tokenAddress,
            claimed:false
        });

        stakedOrderDetail[counter_id] = stake_order;    

        openedStakeOrders[msg.sender].

        counter_id += 1

    }

    function stakeOnX(address _tokenAddress, uint256 _amount) public onlyAuthorized{
        // Get the username, decrypt and check if he is registered

        // Lock the Asset Staked


        // Check if Token is supported
        require(priceFeed[_tokenAddress], "Token not Supported");
        
        uint256 hisho_reward = getReward(_tokenAddress,_amount);

        Stake memory stake_order = new Stake({
            staker://enter the alias X address,
            id: counter_id,
            start_time: block.timestamp,
            end_time: (block.timestamp + 7 days),
            assetAmount: _amount,
            assetRewardRate: dailyRewardRate,
            hisho_reward: reward,
            tokenAddress:_tokenAddress,
            claimed:false
        });

        stakedOrderDetail[counter_id] = stake_order;    

        openedStakeOrders[msg.sender].

        counter_id += 1



    }
    function stakeonTelegram(address _tokenAddress, uint256 _amount) public onlyAuthorized{
        // Get the username, decrypt and check if he is registered
        // Check if Token is supported
        require(priceFeed[_tokenAddress], "Token not Supported");


        
        // Lock the Asset Staked



        uint256 hisho_reward = getReward(_tokenAddress,_amount);

         Stake memory stake_order = new Stake({
            staker://enter the alias Telegram address,
            id: counter_id,
            start_time: block.timestamp,
            end_time: (block.timestamp + 7 days),
            assetAmount: _amount,
            assetRewardRate: dailyRewardRate,
            hisho_reward: reward,
            tokenAddress:_tokenAddress,
            claimed:false
        });

        stakedOrderDetail[counter_id] = stake_order;    

        openedStakeOrders[msg.sender].

        counter_id += 1

    }

    


    function unstake() public onlyAuthorized{

    }

    



    // UTITLITY FUNCTIONS 

    function deleteClosedStakeOrders() {

    }

    function getReward(address _tokenAddress, uint256 _amount) public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(priceFeed[_tokenAddress]).latestRoundData();
        return (answer * _amount * dailyRewardRate)/(1e11);
    }

    function stringToBytes(string memory _username) internal pure returns(bytes32 result){
        bytes memory temp = bytes(_username);

        require(temp.length <= 32, "Too long");
        assembly {
            result := mload(add(username, 32))


        }

    }





}