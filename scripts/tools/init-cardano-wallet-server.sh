#!/bin/bash

echo "Iniciando wallet con en: $CARDANO_NODE_NETWORK"

if [[ $CARDANO_NODE_NETWORK = "Testnet" ]]; then

    echo "--port: $CARDANO_WALLET_PORT" 
    echo "--testnet: "$CARDANO_BYRON 
    echo "--node-socket $CARDANO_NODE_SOCKET_PATH" 
    echo "--database $CARDANO_WALLET_DB_PATH"
    echo "--token-metadata-server $TOKEN_METADATA_SERVER"

    echo; read -rsn1 -p "Press any key to continue . . ."; echo

    # para inciiar la wallet compilada
    # CWD=$(pwd)
    # cd $PLUTUS_DEVS_HASKELL

    # cabal run cardano-wallet:exe:cardano-wallet -- serve \
    #     --port $CARDANO_WALLET_PORT \
    #     --testnet "$CARDANO_BYRON"\
    #     --node-socket "$CARDANO_NODE_SOCKET_PATH" \
    #     --database "$CARDANO_WALLET_DB_PATH" 

    # cd $CWD

    $CARDANO_WALLET/cardano-wallet serve \
        --port $CARDANO_WALLET_PORT \
        --testnet "$CARDANO_BYRON"\
        --node-socket "$CARDANO_NODE_SOCKET_PATH" \
        --database "$CARDANO_WALLET_DB_PATH" 
        \
        --token-metadata-server $TOKEN_METADATA_SERVER


else

    echo "--port: $CARDANO_WALLET_PORT" 
    echo "--mainnet"
    echo "--node-socket $CARDANO_NODE_SOCKET_PATH" 
    #echo "--light"
    #echo "--blockfrost-token-file $PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/blockfrost/blockfrost-mainnet.key"
    echo "--database $CARDANO_WALLET_DB_PATH"
    echo "--token-metadata-server $TOKEN_METADATA_SERVER"

    echo; read -rsn1 -p "Press any key to continue . . ."; echo

    $CARDANO_WALLET/cardano-wallet serve \
        --port $CARDANO_WALLET_PORT \
        --mainnet \
        --node-socket $CARDANO_NODE_SOCKET_PATH \
        --database $CARDANO_WALLET_DB_PATH \
        --token-metadata-server $TOKEN_METADATA_SERVER

fi



