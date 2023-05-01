

# lo uso en docker para configurar acceso a el toolkit de scripts
# todo este repositorio lo monto en /sources/repos/Plutus-Devs/cardano-devs-scripts/scripts/
# para eso monto la carpera source directamente en el docker-compose.yml

CARDANO_NODE_NETWORK="Testnet"
export CARDANO_NODE_NETWORK

CARDANO_NODE_NETWORK_NAME="testnet-preview"
export CARDANO_NODE_NETWORK_NAME

# USUARIO=plutus
# export USUARIO

# SOURCE=/home/plutus/source
# export SOURCE

PLUTUS_DEVS=$SOURCE
export PLUTUS_DEVS

PLUTUS_DEVS_SCRIPTS=${SCRIPTS}
export PLUTUS_DEVS_SCRIPTS

PLUTUS_DEVS_SCRIPTS_FILES=${SCRIPTS}/../files
export PLUTUS_DEVS_SCRIPTS_FILES

# PLUTUS_DEVS_HASKELL=$PLUTUS_DEVS/cardano-devs-plutus
# export PLUTUS_DEVS_HASKELL

# PLUTUS_DEVS_SCRIPTS=$PLUTUS_DEVS/tools/scripts
# export PLUTUS_DEVS_SCRIPTS

# PLUTUS_DEVS_SCRIPTS_FILES=$PLUTUS_DEVS/tools/files
# export PLUTUS_DEVS_SCRIPTS_FILES

source "$PLUTUS_DEVS_SCRIPTS/env/write-env-list.sh"