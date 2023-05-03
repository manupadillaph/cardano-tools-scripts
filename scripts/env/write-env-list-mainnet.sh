#INIT PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE 

CARDANO_NODE_NETWORK="Mainnet"
export CARDANO_NODE_NETWORK

CARDANO_NODE_NETWORK_NAME="mainnet"
export CARDANO_NODE_NETWORK_NAME

USER=manuelpadilla
export USER

SOURCE=/home/manuelpadilla/source
export SOURCE

PLUTUS_DEVS=$SOURCE/reposUbuntu/CARDANO
export PLUTUS_DEVS

PLUTUS_DEVS_HASKELL=$PLUTUS_DEVS/cardano-devs-plutus
export PLUTUS_DEVS_HASKELL

PLUTUS_DEVS_SCRIPTS=$PLUTUS_DEVS/cardano-tools-scripts-v1.0/scripts
export PLUTUS_DEVS_SCRIPTS

PLUTUS_DEVS_SCRIPTS_FILES=$PLUTUS_DEVS/cardano-tools-scripts-v1.0/files
export PLUTUS_DEVS_SCRIPTS_FILES

source "$PLUTUS_DEVS_SCRIPTS/env/write-env-list.sh"

#END PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE
