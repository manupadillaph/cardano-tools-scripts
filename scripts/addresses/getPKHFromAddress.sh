#!/bin/bash

if [ -z "$1" ]; then
    echo "Address:"
    read address
else
  address=$1
fi


echo $address | $CARDANO_WALLET/cardano-address address inspect 

#| jq -r '.stake_address_hash'
echo " "
echo; read -rsn1 -p "Press any key to continue . . ."; echo
