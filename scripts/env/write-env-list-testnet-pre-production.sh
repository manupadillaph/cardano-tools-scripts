#INIT PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE 

CARDANO_NODE_NETWORK="Testnet"
export CARDANO_NODE_NETWORK

CARDANO_NODE_NETWORK_NAME="testnet-pre-production"
export CARDANO_NODE_NETWORK_NAME

USUARIO=manuelpadilla
export USUARIO

SOURCE=/home/manuelpadilla/source
export SOURCE

PLUTUS_DEVS=$SOURCE/copyRepos/Plutus-Devs
export PLUTUS_DEVS

PLUTUS_DEVS_HASKELL=$PLUTUS_DEVS/cardano-devs-plutus
export PLUTUS_DEVS_HASKELL

PLUTUS_DEVS_SCRIPTS=$PLUTUS_DEVS/cardano-devs-scripts/scripts
export PLUTUS_DEVS_SCRIPTS

PLUTUS_DEVS_SCRIPTS_FILES=$PLUTUS_DEVS/cardano-devs-scripts/files
export PLUTUS_DEVS_SCRIPTS_FILES

source "$PLUTUS_DEVS_SCRIPTS/env/write-env-list.sh"

#END PLUTUS ENVS ~/.bashrc - DONT DELETE THIS LINE
