#!/bin/bash

if  [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.id"  ]];
then

    WALLET_ID=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/wallets/$walletName.id)

    DIRECCIONES=$(curl -H "content-type: application/json" \
        -XGET localhost:$CARDANO_WALLET_PORT/v2/wallets/$WALLET_ID/addresses | jq -r '.[]' )

    echo $DIRECCIONES | jq -r '.id' >$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addrs

fi

if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addrs"  ]]
then
    printf "\nNo existe el archivo addrs\n"

    echo; read -rsn1 -p "Press any key to continue . . ."; echo 

else
    while read address
    do
        printf "\nUtxo At Wallet address $address:\n"

        result=$($CARDANO_NODE/cardano-cli query utxo\
        --address $address --$NETWORK_WITH_MAGIC)

        echo "$result" | grep -Po "[a-zA-Z0-9]+ +[0-9]+ +[a-zA-Z0-9 \+\.\"]+" | nl

    done < "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addrs"

    echo; read -rsn1 -p "Press any key to continue . . ."; echo 

fi



         