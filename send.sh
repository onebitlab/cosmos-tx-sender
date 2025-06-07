#!/bin/bash

# Load variables from external file
CONFIG_FILE="./config.env"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⛔ Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Export variables
set -o allexport
source "$CONFIG_FILE"
set +o allexport

# Colors
light_green='\033[92m'
red='\033[91m'
blank='\033[0m'

# Logging function with timestamp
log() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "[$TIMESTAMP] $1" | tee -a "$LOG"
}

# Check required variables
missing_vars=0
check_var() {
    if [ -z "${!1}" ]; then
        echo -e "${red}❌ Missing variable: $1 (check $CONFIG_FILE)${blank}"
        missing_vars=1
    fi
}

echo -e "${light_green}🔍 Checking configuration variables...${blank}"
check_var BINARY
check_var LOG
check_var PWD
check_var TX_COUNT
check_var FROM_WALLET_ADDRESS
check_var TO_WALLET_ADDRESS
check_var TX_AMOUNT
check_var DELAY
check_var NODE_CHAIN
check_var TX_FEES

if [ $missing_vars -eq 1 ]; then
    echo -e "${red}⛔ Script aborted due to missing variables.${blank}"
    exit 1
fi

# Auto-detect binary path
BINARY_PATH=$(which "$BINARY" 2>/dev/null)
if [ -z "$BINARY_PATH" ]; then
    echo -e "${red}⛔ Binary '$BINARY' not found in PATH.${blank}"
    exit 1
fi
log "🔍 Using binary: $BINARY_PATH"

# Create log file
touch "$LOG"
log "🔧 Script initialized. Sending $TX_COUNT transactions..."

# Main loop
c=1
while [ $c -le $TX_COUNT ]; do
    TX_STATUS=$(echo "$PWD" | "$BINARY_PATH" tx bank send "$FROM_WALLET_ADDRESS" "$TO_WALLET_ADDRESS" "$TX_AMOUNT" \
      --chain-id="$NODE_CHAIN" --gas=auto --fees="$TX_FEES" -y 2>/dev/null)

    TX_HASH=$(echo "$TX_STATUS" | jq -r .txhash)

    if [ "$TX_HASH" == "null" ] || [ -z "$TX_HASH" ]; then
        echo -e "${red}⚠️ TX #$c failed${blank}"
        log "❌ TX $c: Failed to send. Response: $TX_STATUS"
    else
        echo -e "${light_green}✅ TX $c${blank} - $TX_HASH"
        log "✅ TX $c: Sent successfully. Hash: $TX_HASH"
    fi

    ((c=c+1))
    sleep "$DELAY"
done

log "🏁 Script completed. Total transactions sent: $TX_COUNT."