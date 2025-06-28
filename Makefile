-include .env

SHELL := /bin/bash

.PHONY: install load-env deploy-token-etherum-sepolia deploy-token-avalanche_fuji deploy-token-polygon-amoy deploy-token-scroll-sepolia deploy-token-arbitrium-sepolia 

install:
	@forge install OpenZeppelin/openzeppelin-contracts --no-commit;
	@forge install smartcontractkit/foundry-chainlink-toolkit --no-commit;



load-env:
	@source .env

deploy-token-local:
	@forge script script/DeployToken.s.sol --rpc-url $(LOCAL_RPC) --private-key $(ANVIL_PRIVATE_KEY) --broadcast --verify

deploy-token-etherum-sepolia:
	@forge script script/DeployToken.s.sol --rpc-url $(POLYGON_AMOY_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify


deploy-token-avalanche_fuji:
	@forge script script/DeployToken.s.sol --rpc-url $(AVLANCHE_FUJI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify


deploy-token-polygon-amoy:
	@forge script script/DeployToken.s.sol --rpc-url $(POLYGON_AMOY_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify


deploy-token-scroll-sepolia:
	@forge script script/DeployToken.s.sol --rpc-url $(SCROLL_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify


deploy-token-arbitrium-sepolia:
	@forge script script/DeployToken.s.sol --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify












