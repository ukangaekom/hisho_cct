# Hisho Gamified Randomize Yielding Protocol(HRYP)


#### 1. What Hisho Gamified Randomized Yielding Protocol?
#### 2a. How HRYP works?
#### 3. What is Hisho Token and What is it used for? 
#### 4. Contract Functions and Explanations
#### 5. Dependenceis,Installation and Testng
###



## What is Hisho Randomize Yielding Protocol?
Hisho Gamified Randomized Yielding Protocol is a smart contract for **Hisho** which enable users to earn **Hisho Tokens** by staking **ETH, AVAX or LINK** token.
The staking reward rate(percent) is powered by ```Chainlink VRF``` which generates a percentage reward between ```1% to 10%``` daily for stakers who stakes their assets for a fixed period of 7 day **i.e if $1000 worth of ETH or AVAX or LINK is staked at the current market price and the daily reward rate is 10% for that day, ```100``` Hisho Tokens will be rewarded to the user after the staking period is over for 7 days.**

Hisho Gamified Randomize Yielding Protocol uses ```chainlink priceFeed``` to get the price value of the staked token amount to determine the amount of the rewarded hisho for the staked order based on the daily rate. 

Also, the protocol uses time-based ```chainlink automation``` functions to update daily interest(reward rate) for staking.

Hisho Token ```chainlink CCIP``` token standard. This enables it to be interoperable across chains.




## How HRYP works?

Hisho Gamified Randomize Yielding protocol rewards hisho through staking. Using a gamified simulated interest rate which can cannot be greater than ```10%```, Hisho Tokens Accumulates ```ETH, LINK and AVAX``` in it pools as a security. To control demand and supply, thanks to ```chainlink vrf```, it using undeterministic simulated randomized yields to drive the engagement and daily staking participation. This gives users diverse options and how the amount of assets and types of assets they should stake based on the daily generated reward rate. Also, this method of minting ```Hisho Token``` gives it an economic long term self-sustaining stable value. 


## What is Hisho Token and What is it used for? 

**Hisho Token** is a stable coin for onchain AI agents. While we pay for ```$USD``` in credit to AI platforms and still work to implement our own agents, the blockchain needs a stable coin which crypto projects can pay to infrastructures to get their customized blockchain and crypto related specialized agent via ```apis```.

The blockchain and crypto space is still far away from having powerful and dynamic agents tailored for onchain operations and related services.

Hisho token is the AaaS(Agent as a Service) payment token for hisho platform to provide customized `APIs` tailored for specific projects and their contract. 

It's simple. We provide your customized an tailored agent through an api while you consume the api in your bot or webapp to perform tooling, calling and chat operations tailored for your project.


## Contracts, Functions and Explanations.

### Contract Address

**Price Feed :**
**`PriceFeed/hishoPriceFeed.sol`**

**Contract Address:** `0xba87dD154BC7132A89B4b6632404f819799d997b`

**VRF and Automation Contract:**
**`Automation/hishoInterestAutomation.sol`**
**Contract Address on Fuji_Testnet**:`0xDe74fB2a3B571dAEf0C4786AD294b0F51A03051a`



**Token: HISHO**
**Token Decimal:** **`e18`**

**ERC20 Cross Chain Token Address**

**Avalanche Fuji:** [`0x1c62f73e1c24c29254f3954aca1f9a7aaacb45b5`](https://testnet.snowtrace.io/address/0x1c62f73e1c24c29254f3954aca1f9a7aaacb45b5)

**Scroll Sepolia:** [`0xc6fc21d2511a70d56291c986dcce47380161f698`](https://sepolia.scrollscan.com/address/0xc6fc21d2511a70d56291c986dcce47380161f698)

**ERC721 Dynamic Agentic NFT Address:**

**Avalanche Fuji:** `0x0FBbDfCCfC74682134BF584c46C1f4E2C715Ce4c`

**Opensea**: [Hisho Genesis Avalanche NFT](https://testnets.opensea.io/assets/avalanche_fuji/0x0fbbdfccfc74682134bf584c46c1f4e2c715ce4c/0)
**Opensea**: [Dynamic Agentic NFT](https://testnets.opensea.io/assets/avalanche_fuji/0x0fbbdfccfc74682134bf584c46c1f4e2c715ce4c/1)


**Scroll Sepolia:** `0x0D3A323B40B9b62e25FACb495FEDE396d84C61Ed`

[Scroll Testnet Scan](https://sepolia.scrollscan.com/address/0x0d3a323b40b9b62e25facb495fede396d84c61ed)

**Opensea**: 

[Hisho Genesis Scroll NFT](https://sepolia.scrollscan.com/nft/0x0d3a323b40b9b62e25facb495fede396d84c61ed/0)

[Dynamic Agentic NFT](https://sepolia.scrollscan.com/nft/0x0d3a323b40b9b62e25facb495fede396d84c61ed/1)




## MAIN Defi Contract

**src/hishoOnchain.sol**
**Avalanche_Fuji_Testnet(Hisho DeFi Contract):**`0x14DfF3DC551bBe68e1089F3419eFc9be7b19C7A2`



# Chainlink Service Subscriptions

**VRF**: [Hisho Automation Interest Contract VRF Subscription](https://vrf.chain.link/fuji#/side-drawer/subscription/fuji/33973673007361492444179581756780378375317520279061855542086790202950903222662)

**Automation**:[Hisho Automation Interest Contract Automation Subscription](https://automation.chain.link/fuji/27572808074052681613616845511413181415199168609014367088907226484068358348631)








### Installing Dependencies for Testing
```
forge install openzeppelin/openzeppelin-contracts@v5.1.0 --no-commit
```


```
forge install smartcontractkit/chainlink --no-commit
```