#!/bin/bash


if [ -z "$1" ]; then
  echo "Ingrese wallet name:"
  read file
else
  file=$1
fi

echo "JSON2:"  $PLUTUS_DEVS_SCRIPTS_FILES/wallets/$file.json


echo "-H \"content-type: application/json\" -XPOST \
  -d @$PLUTUS_DEVS_SCRIPTS_FILES/wallets/$file.json \
  localhost:$CARDANO_WALLET_PORT/v2/wallets"

curl -H "content-type: application/json" -XPOST \
  -d @$PLUTUS_DEVS_SCRIPTS_FILES/wallets/$file.json \
  localhost:$CARDANO_WALLET_PORT/v2/wallets

echo ""
echo ""
