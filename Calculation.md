## Calculation of price Fetching

LINK, ETH and AVAX has 18 decimal point i.e 1e18

LINK -> $13.130 -> 13 13072138

ETH ->  $2440.51 ->  2440 51000000

AVAX -> $17.4  -> 17 40000000


**Note:**`Chainlink's price Feed returns the price of the token * 1e8


## Calculation of interest rate for hisho token
Hisho Decimals -> 18 (The same as the assets) there is no need of involving `1e18` in the calculation as they cancel
```daily_reward = 1% to 10% which last for a month. ```
Given that the daily reward rate is given as uint8 which ranges ```from 10 to 100```. The ```100% is represented as 1000```.


```
Hisho_Reward = (PriceFeed * Amount_of_StakedTokens * daily_reward)/(1e8 * 1e3)

```

## Final Calculation Output
```

Hisho_Reward = (PriceFeed * Amount_of_StakeTokens * daily_reward)/(1e11)
```
