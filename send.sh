#!/bin/bash

#  --- SCRIPT CONFIGURATION SETTINGS ---
# FILENAME FOR LOG FILE
LOG=
# YOUR WALLET PASSOWORD
PWD=
# TOTAL TX COUNT
TX_COUNT=
# WALLET SENDING TX FROM
FROM_WALLET_ADDRESS=
# WALLET SENDINF TX TO
TO_WALLET_ADDRESS=
# AMOUNT OF EACH TX (EXAMPLE: "10000uumee")
TX_AMOUNT=
# DURATION BETWEEN TRANSACTIONS IN SECONDS
DELAY=
# NETWORK CHAIN-ID
NODE_CHAIN=
# TRANSACTION FEES (EXAMPLE: "300uumee")
TX_FEES=
# --- END ---
light_green='\033[92m'
blank='\033[0m'
c=1
printf "$light_green Sending $TX_COUNT TX:$blank\n"
(
  while [ $c -le $TX_COUNT ]
  do
      TX_STATUS=$(echo $PWD | umeed tx bank send $FROM_WALLET_ADDRESS $TO_WALLET_ADDRESS $TX_AMOUNT --chain-id=$NODE_CHAIN --gas=auto --fees=$TX_FEES -y)
      TX_HASH=$(echo $TX_STATUS | jq -r .txhash)
      echo -e "$light_green TX $c $blank- $TX_HASH"
      echo $TX_HASH >> $LOG
        sleep $DELAY
      ((c=c+1))
  done
)
