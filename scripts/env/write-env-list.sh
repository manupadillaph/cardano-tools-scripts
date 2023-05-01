#INIT PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE 

# PLUTUS_APPS11=$SOURCE/tools/plutus-apps-1.1.0/plutus-apps
# PLUTUS_APPS12=$SOURCE/tools/plutus-apps-1.2.0/plutus-apps
# PLUTUS_APPSF8=$SOURCE/tools/plutus-apps-f857624598948749c5721c2173c6d7b10a280862/plutus-apps
# #PLUTUS_APPS=$SOURCE/tools/plutus-apps-7cc060361feba3b396cfbdd90f7003b1c6597606/plutus-apps

# declare -A PLUTUS_APPS
# PLUTUS_APPS["1"]="$PLUTUS_APPS1"
# PLUTUS_APPS["f8"]="$PLUTUS_APPSF8"

# Create array of directories
PLUTUS_APPS_ARR=($(find $PLUTUSAPPS -maxdepth 1 -mindepth 1 -type d))

PLUTUS_APPS=${PLUTUS_APPS_ARR[0]}
export PLUTUS_APPS

# PLUTUS_APPS_ARR=("$PLUTUS_APPS11" "$PLUTUS_APPS12" "$PLUTUS_APPSF8")
export PLUTUS_APPS_LIST=$(IFS='|'; echo "${PLUTUS_APPS_ARR[*]}")
export PLUTUS_APPS_LIST

PLUTUS_APPSX=$PLUTUS_DEVS_SCRIPTS/tools/set-plutus-apps.sh
export PLUTUS_APPSX

PLUTUS_DEVS_SCRIPTS_FILES_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES/config
export PLUTUS_DEVS_SCRIPTS_FILES_CONFIG

MAIN=$PLUTUS_DEVS_SCRIPTS/main.sh
export MAIN

NIX_SHELL=$PLUTUS_DEVS_SCRIPTS/tools/init-nix-shell.sh
export NIX_SHELL

BACK2CWD=$PLUTUS_DEVS_SCRIPTS/tools/cd-back-to-cwd.sh
export BACK2CWD

#CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.0-linux2
#CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.3-testnetonly
#CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.3-testnetonly
#CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.2

if [[ $CARDANO_NODE_NETWORK = "Testnet" ]]; then

    #CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.3-linux
    CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.5-linux
    export CARDANO_NODE

    CARDANO_NODE_PORT=3001
    export CARDANO_NODE_PORT
    
    CARDANO_NODE_DB_PATH=$CARDANO_NODE/db-$CARDANO_NODE_NETWORK_NAME
    export CARDANO_NODE_DB_PATH 

    CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE/db-$CARDANO_NODE_NETWORK_NAME/node.socket
    export CARDANO_NODE_SOCKET_PATH

    CARDANO_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/config.json
    export CARDANO_CONFIG

    CARDANO_TOPOLOGY=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/topology.json
    export CARDANO_TOPOLOGY

    CARDANO_SHELLEY=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/shelley-genesis.json
    export CARDANO_SHELLEY

    CARDANO_BYRON=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/byron-genesis.json
    export CARDANO_BYRON

    CARDANO_ALONZO=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/alonzo-genesis.json
    export CARDANO_ALONZO

    CARDANO_SUBMIT_API_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/submit-api-config.json
    export CARDANO_SUBMIT_API_CONFIG

    CARDANO_DBSYNC_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/db-sync-config.json
    export CARDANO_DBSYNC_CONFIG
    
    if [[ -f "$CARDANO_SHELLEY"  ]];
    then
        #NETWORK_WITH_MAGIC="testnet-magic 1097911063"
        #NETWORK_WITH_MAGIC="testnet-magic 1"  
        NETWORKMAGIC_NRO=$(cat $CARDANO_SHELLEY | jq -r '.networkMagic')
        export NETWORKMAGIC_NRO

        NETWORK_WITH_MAGIC="testnet-magic "$NETWORKMAGIC_NRO
        export NETWORK_WITH_MAGIC
    fi

    #CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-07-01-linux64
    #CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-08-16-linux64
    #CARDANO_WALLET=$SOURCE/tools/cardano-wallet-source
    CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-12-14-linux64

    export CARDANO_WALLET

    CARDANO_WALLET_DB_PATH=$CARDANO_WALLET/db-$CARDANO_NODE_NETWORK_NAME
    export CARDANO_WALLET_DB_PATH

    CARDANO_WALLET_PORT=9091
    export CARDANO_WALLET_PORT

    TOKEN_METADATA_SERVER=https://metadata.cardano-testnet.iohkdev.io/
    export TOKEN_METADATA_SERVER

else 

    CARDANO_NODE=$SOURCE/tools/cardano-node-1.35.5-linux
    export CARDANO_NODE

    CARDANO_NODE_NETWORK_NAME="mainnet"
    export CARDANO_NODE_NETWORK_NAME

    CARDANO_NODE_PORT=3001
    export CARDANO_NODE_PORT

    CARDANO_NODE_DB_PATH=$CARDANO_NODE/db-$CARDANO_NODE_NETWORK_NAME
    export CARDANO_NODE_DB_PATH 

    CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE/db-$CARDANO_NODE_NETWORK_NAME/node.socket
    export CARDANO_NODE_SOCKET_PATH

    CARDANO_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/config.json
    export CARDANO_CONFIG

    CARDANO_TOPOLOGY=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/topology.json
    export CARDANO_TOPOLOGY

    CARDANO_SHELLEY=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/shelley-genesis.json
    export CARDANO_SHELLEY

    CARDANO_BYRON=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/byron-genesis.json
    export CARDANO_BYRON

    CARDANO_ALONZO=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/alonzo-genesis.json
    export CARDANO_ALONZO

    CARDANO_SUBMIT_API_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/submit-api-config.json
    export CARDANO_SUBMIT_API_CONFIG

    CARDANO_DBSYNC_CONFIG=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-node/$CARDANO_NODE_NETWORK_NAME/db-sync-config.json
    export CARDANO_DBSYNC_CONFIG

    NETWORK_WITH_MAGIC="mainnet"
    export NETWORK_WITH_MAGIC

    #CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-07-01-linux64
    #CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-08-16-linux64
    CARDANO_WALLET=$SOURCE/tools/cardano-wallet-v2022-12-14-linux64
    
    export CARDANO_WALLET

    CARDANO_WALLET_DB_PATH=$CARDANO_WALLET/db-$CARDANO_NODE_NETWORK_NAME
    export CARDANO_WALLET_DB_PATH

    CARDANO_WALLET_PORT=9091
    export CARDANO_WALLET_PORT

    TOKEN_METADATA_SERVER=https://metadata.cardano-testnet.iohkdev.io/
    export TOKEN_METADATA_SERVER
fi

CARDANO_CHAIN_INDEX_CONFIG_PATH=$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG/cardano-chain-index
export CARDANO_CHAIN_INDEX_CONFIG_PATH

CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG=$CARDANO_CHAIN_INDEX_CONFIG_PATH/config.TEMPLATE.json
export CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG

CARDANO_CHAIN_INDEX_CONFIG=$CARDANO_CHAIN_INDEX_CONFIG_PATH/config-$CARDANO_NODE_NETWORK_NAME.json
export CARDANO_CHAIN_INDEX_CONFIG

CARDANO_CHAIN_INDEX_PATH=$SOURCE/tools/cardano-chain-index
export CARDANO_CHAIN_INDEX_PATH

CARDANO_CHAIN_INDEX_DB_PATH=$CARDANO_CHAIN_INDEX_PATH/$CARDANO_NODE_NETWORK_NAME
export CARDANO_CHAIN_INDEX_DB_PATH

CARDANO_CHAIN_INDEX_DB=$CARDANO_CHAIN_INDEX_DB_PATH/chain-index.db
export CARDANO_CHAIN_INDEX_DB

CARDANO_CHAIN_INDEX_PORT=9083
export CARDANO_CHAIN_INDEX_PORT

CARDANO_PAB_SERVER_CONFIG_PATH=$PLUTUS_DEVS_SCRIPTS_FILES/config/pab
export CARDANO_PAB_SERVER_CONFIG_PATH

CARDANO_PAB_SERVER_TEMPLATE_CONFIG=$CARDANO_PAB_SERVER_CONFIG_PATH/pab-config.TEMPLATE.yml
export CARDANO_PAB_SERVER_TEMPLATE_CONFIG

CARDANO_PAB_SERVER_CONFIG=$CARDANO_PAB_SERVER_CONFIG_PATH/pab-config.VALIDATOR_SCRIPT_NAME.yml
export CARDANO_PAB_SERVER_CONFIG

CARDANO_PAB_DATABASE_PATH=$PLUTUS_DEVS_SCRIPTS_FILES/pab
export CARDANO_PAB_DATABASE_PATH

CARDANO_PAB_DATABASE=$CARDANO_PAB_DATABASE_PATH/plutus-pab.VALIDATOR_SCRIPT_NAME.db
export CARDANO_PAB_DATABASE

CARDANO_PAB_PORT=9080
export CARDANO_PAB_PORT

CARDANO_TOOLS_TOKEN_METADATA_CREATOR=$SOURCE/tools/token-metadata-creator/token-metadata-creator
export CARDANO_TOOLS_TOKEN_METADATA_CREATOR

#END PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE
