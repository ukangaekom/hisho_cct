// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


// Interface

interface IHishoGamifiedInterest {
    function get_interest() external view returns (uint256);
}





/*
* @title HishoOnchain
* @author Ekomabasi Martin Ukanga
* @notice This encourages user to claim their hisho tokens onchain when they stake their NFTs, AVAX, LINK, or Native Chain Tokens
* @notice The daily interest rate is randomized by Chainlink VRF
* @notice The daily interest rate is called by Chainlink Automation
*/

contract HishoOnchain {

    using SafeERC20 for IERC20;
    

    IHishoGamifiedInterest public hishoAutoInterest;
    AggregatorV3Interface internal nativeAssetDataFeed;
    
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
        uint256 assetRewardRate;
        uint256 hisho_reward;
        address tokenAddress;
        bool claimed;
    }



    // VARIABLES

    IERC20 private HishoToken;

    uint256 private counter_id = 0;
    address internal hisho_token_address; //For any of the supported blockchains. E.g Avalanche
    

    /*
    * @note The monthly reward rate ranges from to 1% to 10%
    * @note The value of the dailyReward ranges from 10 to 100 in number so it is basically maxed at 1000 which is 100%
    */ 
    uint256 public dailyRewardRate = 0;

    address private owner;

    // MAPPINGS

    mapping(address token => address _priceFeed) public priceFeed;
    mapping(uint256 id => Stake orderDetail) public stakedOrderDetail;

    //Order ids
    mapping(address user => uint256[] order_ids) public openedStakeOrders;
    mapping(address user => uint256[] order_ids) public closedStakeOrders;


    // Token Balances
    mapping(address user => mapping(address token => uint256 amount)) private WithdrawableAsset;
    // Locked Balances
    mapping(address user => mapping(address token => uint256 amount)) private LockedAsset;

    mapping(address => uint256) public withdrawableBalances;
    mapping(address => uint256) public lockedBalances;

   
    // Social Media
    mapping(address user =>bytes32) public Telegram; //Registering telegram username
    mapping(bytes32 user =>address) public TelegramReverse; //Registering telegram username
    mapping(address user =>bytes32) public X_app; //Registering twitter username
    mapping(bytes32 user =>address) public X_appReverse; //Registering twitter username
    mapping(address user =>bytes32) public Email; //Register with email
    mapping(bytes32 user =>address) public EmailReverse; //Register with email

    mapping(address=> bool) private AuthorizedCaller; //Authorized Caller Address


    // EVENTS
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed receiver, uint256 amount);
    event AssetRedrawn(address indexed receiver, address assetAddress, uint256 amount);
    

    // @param address _hishoToken -> This is the ERC\ 
    constructor(address _nativeTokenAddress, address _hishoToken){
        nativeAssetDataFeed = AggregatorV3Interface(_nativeTokenAddress);
        owner = msg.sender;
        hisho_token_address = _hishoToken;
        HishoToken = IERC20(_hishoToken);


    }



    // MODIFIERS

    modifier onlyOwner(){
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyAuthorized(){
        require(AuthorizedCaller[msg.sender] == true, "You are not authorized to call this function");
        _;
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
    function registerTelegramUsername(string memory _telegramUserName) public {
        bytes32 user = stringToBytes(_telegramUserName);
        require(Telegram[msg.sender] == bytes32(0) || TelegramReverse[user] == address(0),"Username Unavailable");
        Telegram[msg.sender] = user;
        TelegramReverse[user] = msg.sender;
        

    }

    function registerXUsername(string memory _xUserName) public{
        bytes32 user = stringToBytes(_xUserName);
        require(X_app[msg.sender] == bytes32(0) || X_appReverse[user] == address(0),"Username Unavailable");
        X_app[msg.sender] = user;
        X_appReverse[user] = msg.sender;

    }
    


    function registerEmailUsername(string memory _emailUserName) public{
        bytes32 user = stringToBytes(_emailUserName);
        require(Email[msg.sender] == bytes32(0) || EmailReverse[user] == address(0),"Username Unavailable");
        Email[msg.sender] = user;
        EmailReverse[user] = msg.sender;


    }



    // GETTER FUNCTIONS

    // Get Social Platforms Functions
    function getTelegramName(address _user) public view returns(bytes32){

        return Telegram[_user];
    }


    function getXName(address _user) public view returns (bytes32) {
        return X_app[_user];

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

    function getAllOpenedStakeOrder(address _user) public view returns(uint256[] memory){
        return openedStakeOrders[_user];
    }

    function getAllClosedStakeOrder(address _user) public view returns (uint256[] memory) {
        return closedStakeOrders[_user];
    }



    //SETTER FUNCTIONS 


    /* 
    * @notice The contracts has an onlyAuthorized Modifier. 
      Chainlink Automation Functions is Authorized in the contract to call the function.
    * @notice Chainlink Automation Function is to call this function every month.
    * @notice Chainlink VRF is also called in the function set the random daily interest
    */
    function setDailyRewardRate(uint8 _dailyRate) public onlyAuthorized{
        if(_dailyRate > 10 && _dailyRate < 100){

            dailyRewardRate = _dailyRate;
        }   

    }

    function setAutomatedCaller(address _hishoAddress) public onlyOwner{
        hishoAutoInterest = IHishoGamifiedInterest(_hishoAddress);
    }



    // CLAIM FUNCTIONS

    function claimReward(uint256 _id) public {
         Stake storage order = stakedOrderDetail[_id];
        // Check if it is the owner of the staked order
        require(order.staker == msg.sender, "You are not the owner");
        // Check if the stake order is already claimed
         require(order.claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= order.end_time,"Not due");

        
        // Change state to claimed
        order.claimed = true;

        // Declare Tempoary variables
        address staker = order.staker;
        address token = order.tokenAddress;
        uint256 amount = order.assetAmount;
        uint256 reward = order.hisho_reward;
        // Unlock the Staked Asset
        LockedAsset[staker][token] -= amount;

        WithdrawableAsset[staker][token] += amount;

        // Transfer The Required Hisho Tokens to the staker address

        HishoToken.safeTransferFrom(address(this),staker, reward);

    }


    function claim_media(address _user, uint256 _id) public onlyAuthorized{
         Stake storage order = stakedOrderDetail[_id];
        // Check if it is the owner of the staked order
        require(order.staker == _user, "You are not the owner");
        require(order.claimed == true, "Order already claimed");
        // Check if staking is due
        require(block.timestamp >= order.end_time,"Not due");

        
        // Change state to claimed
        order.claimed = true;

        // Declare Tempoary variables
        address staker = order.staker;
        address token = order.tokenAddress;
        uint256 amount = order.assetAmount;
        uint256 reward = order.hisho_reward;
        // Unlock the Staked Asset
        LockedAsset[staker][token] -= amount;

        WithdrawableAsset[staker][token] += amount;
        
        // Transfer The Required Hisho Tokens to the staker address

        HishoToken.safeTransferFrom(address(this),staker, reward);

    }


    //  STAKE RELATED FUNCTIONS

    function stake(address _tokenAddress, uint256 _amount) public {
        require(priceFeed[_tokenAddress] != address(0), "Token not Supported");
        require(WithdrawableAsset[msg.sender][_tokenAddress] > _amount,"Insufficient Funds");
        //  Lock the Asset Staked;
        WithdrawableAsset[msg.sender][_tokenAddress] -= _amount;
        LockedAsset[msg.sender][_tokenAddress] += _amount;

        uint256 reward = getReward(_tokenAddress,_amount);
        
        Stake memory stake_order = Stake({
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

        openedStakeOrders[msg.sender].push(counter_id);

        counter_id += 1;

    }

    function stake_media(address _user, address _tokenAddress, uint256 _amount) public onlyAuthorized{
        
        // Check if Token is supported
        require(priceFeed[_tokenAddress] != address(0), "Token not Supported");
        require(WithdrawableAsset[_user][_tokenAddress] > _amount,"Insufficient Funds");
         // Lock the Asset Staked
        WithdrawableAsset[_user][_tokenAddress] -= _amount;
        LockedAsset[_user][_tokenAddress] += _amount;
        
        uint256 reward = getReward(_tokenAddress,_amount);

        Stake memory stake_order = Stake({
            staker:_user,
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

        openedStakeOrders[msg.sender].push(counter_id);

        counter_id += 1;

    }

    
    /*
    * I know this isn't suppose to be here. This is testnet
    * This is the safe button for withdrawing assets incase something goes wrong.
    * It's for testing purposes
    */


    function withdrawAsset(address _asset) public onlyOwner{
        uint256 totalAmount = IERC20(_asset).balanceOf(address(this));

        IERC20(_asset).safeTransferFrom(address(this), msg.sender, totalAmount);
        emit AssetRedrawn(msg.sender, _asset, totalAmount);

    }

    function withdraw() public onlyOwner{
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH available");
        
        (bool success, ) = (msg.sender).call{value: balance}("");
        require(success, "Transfer failed");
        emit Withdrawn(msg.sender, balance);
    }

    function buy_hisho(uint256 _amount) public {
        require(withdrawableBalances[msg.sender] > _amount, "Insufficient Balance");
        withdrawableBalances[msg.sender] -= _amount;

        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = nativeAssetDataFeed.latestRoundData();
        uint256 hisho_amount = (uint256(answer) * _amount / 1e8);
        HishoToken.safeTransferFrom(address(this),msg.sender,hisho_amount);
        

    }

    function buy_hisho_media(address _user, uint256 _amount) public onlyAuthorized{
        require(withdrawableBalances[_user] > _amount, "Insufficient Balance");
        withdrawableBalances[_user] -= _amount;
        
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = nativeAssetDataFeed.latestRoundData();
        uint256 hisho_amount = (uint256(answer) * _amount / 1e8);
        HishoToken.safeTransferFrom(address(this),_user,hisho_amount);


    }

    function lend(uint256 _amount) public { 
        require(withdrawableBalances[msg.sender] > _amount, "Insufficient Balance");
        withdrawableBalances[msg.sender] -= _amount;
        lockedBalances[msg.sender] += _amount;

        HishoToken.safeTransferFrom(address(this),msg.sender,_amount);
    }
    
    function lend_hisho_media(address _user, uint256 _amount) public onlyAuthorized{ 
        require(withdrawableBalances[_user] > _amount, "Insufficient Balance");
        withdrawableBalances[_user] -= _amount;
        lockedBalances[_user] += _amount;

        HishoToken.safeTransferFrom(address(this),_user,_amount);
    }

    
    function updateDailyRewardRate() public onlyAuthorized{
        dailyRewardRate = hishoAutoInterest.get_interest();
    }


    // UTITLITY FUNCTIONS 

    function getReward(address _tokenAddress, uint256 _amount) public view returns (uint256) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = AggregatorV3Interface(priceFeed[_tokenAddress]).latestRoundData();
        return (uint256(answer) * _amount * dailyRewardRate)/(1e11);
    }

    function stringToBytes(string memory _username) internal pure returns(bytes32 result){
        bytes memory temp = bytes(_username);

        require(temp.length <= 32, "Too long");
        assembly {
            result := mload(add(_username, 32))


        }

    }

    receive() external payable {
        _handleDeposit();
    }

    fallback() external payable {
        _handleDeposit();
    }

    function _handleDeposit() private {
        require(msg.value > 0, "Amount must be > 0");
        withdrawableBalances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }


    



}