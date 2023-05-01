#!/bin/bash

echo "Wallet Address:" $walletAddr
            
result=$($CARDANO_NODE/cardano-cli query utxo\
    --address $walletAddr --$NETWORK_WITH_MAGIC)

printf "\nUtxo at Wallet:\n"

echo "$result" 

echo; read -rsn1 -p "Press any key to continue . . ."; echo 


   

   