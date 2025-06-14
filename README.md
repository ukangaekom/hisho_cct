# Hisho Randomize Yielding Protocol


1. Hisho Protocol enables users to deposit into the vault and in return receive rebase tokens.

2. Rebase Tokens -> balanceOf  function is dynamic to show changing balance with time

    -Balance increases linearly with time.
    -Mint tokens to our users every time they perform the action (minting, burning, transferring, or ... bridging)


3. Interest Rate 
    -Set Individual Interest rate for users based on global interest rate for the protocol at the time of deposit.
    -This global interest rate can only decrease to incentivise/reward early adoptors.
    -It is going to increase adoption. 

### Installing Openzeppelin
```
forge install openzeppelin/openzeppelin-contracts@v5.1.0 --no-commit
```


```
forge install smartcontractkit/chainlink --no-commit
```