#!/bin/bash

# Load environment variables
set -a
source .env
set +a

# Check if required environment variables are set
for var in ETHERSCAN_API_KEY RPC_URL PRIVATE_KEY; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set in the .env file"
        exit 1
    fi
done

# Read the JSON configuration file
CONFIG_FILE="drop_config.json"
DROPS=$(cat "$CONFIG_FILE")

# Loop through each drop in the configuration
echo "$DROPS" | jq -c '.[]' | while read -r drop; do
    NAME=$(echo "$drop" | jq -r '.name')
    SYMBOL=$(echo "$drop" | jq -r '.symbol')
    SUPPLY=$(echo "$drop" | jq -r '.supply')
    BASE_URI=$(echo "$drop" | jq -r '.baseURI')
    DROP_ID=$(echo "$drop" | jq -r '.dropId')

    echo "Deploying and verifying contract for $NAME (Drop ID: $DROP_ID)..."

    # Set environment variables for the Solidity script
    export NFT_NAME="$NAME"
    export NFT_SYMBOL="$SYMBOL"
    export NFT_SUPPLY="$SUPPLY"
    export NFT_BASE_URI="$BASE_URI"
    export DROP_ID="$DROP_ID"
    # Deploy and verify the contract using environment variables
    COMMAND="forge script script/DeployCRNFT.s.sol:DeployCRNFT \
        --rpc-url $RPC_URL \
        --broadcast \
        --verify \
        --etherscan-api-key ${ETHERSCAN_API_KEY} \
        --private-key ${PRIVATE_KEY}"
    
    echo "Executing command: $COMMAND"
    eval $COMMAND

    echo "Deployment and verification process completed for $NAME (Drop ID: $DROP_ID)."
    echo "----------------------------------------"
done

echo "All deployments and verifications completed."