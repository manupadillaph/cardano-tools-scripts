#!/bin/bash


ppFile=$PLUTUS_DEVS_SCRIPTS_FILES/config/tx/protocol-$CARDANO_NODE_NETWORK_NAME.json

if [[ -f "$ppFile" ]]
then
    echo "Protocol File: $ppFile"
    echo "Existe... desea actualizarlo (y/n)?"
    read -n 1 -s opcion
    if [[ $opcion = "y" ]]; then 
        $CARDANO_NODE/cardano-cli query protocol-parameters \
                --out-file $ppFile --$NETWORK_WITH_MAGIC 
    fi
else
    echo "Protocol File: $ppFile"
    echo "No Existe... Creandolo..."

    $CARDANO_NODE/cardano-cli query protocol-parameters \
                --out-file $ppFile --$NETWORK_WITH_MAGIC 
fi
