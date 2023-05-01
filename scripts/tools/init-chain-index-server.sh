#!/bin/bash

#en [NIX-SHELL], para abrir ejecutar antes: bash $NIX_SHELL 

echo "Creando Config File desde TEMPLATE: "
echo " "
echo "--template config: "$CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG
# cat $CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG
# echo ""

if [[ -f "$CARDANO_CHAIN_INDEX_CONFIG"  ]]; then
    unBlockNo=$(cat $CARDANO_CHAIN_INDEX_CONFIG | yq .cicStoreFrom.unBlockNo)
fi

if [[ -z "$unBlockNo" ]]; then 
    echo "Consultando en NODO ultimo BlockNo ...";
    unBlockNo=$($CARDANO_NODE/cardano-cli query tip --$NETWORK_WITH_MAGIC | jq -r '.block') 
    echo "Usando BlockNo: $unBlockNo";
else 
    echo "Encontrados en ConfigFile BlockNo: $unBlockNo, deseas usarlo (y/n)?";

    read -n 1 -s opcion
    if ! [[ $opcion = "y" ]]; then 
        echo "Consultando en NODO ultimo BlockNo ...";
        unBlockNo=$($CARDANO_NODE/cardano-cli query tip --$NETWORK_WITH_MAGIC | jq -r '.block') 
        echo "Usando BlockNo: $unBlockNo";
    fi
fi


cp $CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG $CARDANO_CHAIN_INDEX_CONFIG

sed -i 's,$CARDANO_NODE_SOCKET_PATH,'"$CARDANO_NODE_SOCKET_PATH"',' $CARDANO_CHAIN_INDEX_CONFIG
sed -i 's,$CARDANO_CHAIN_INDEX_PORT,'"$CARDANO_CHAIN_INDEX_PORT"',' $CARDANO_CHAIN_INDEX_CONFIG
sed -i 's,$CARDANO_CHAIN_INDEX_DB,'"$CARDANO_CHAIN_INDEX_DB"',' $CARDANO_CHAIN_INDEX_CONFIG 
sed -i 's,$NETWORKMAGIC_NRO,'$NETWORKMAGIC_NRO',' $CARDANO_CHAIN_INDEX_CONFIG
sed -i 's,$CARDANO_NODE_NETWORK,'$CARDANO_NODE_NETWORK',' $CARDANO_CHAIN_INDEX_CONFIG
sed -i 's,$unBlockNo,'$unBlockNo',' $CARDANO_CHAIN_INDEX_CONFIG

# cecho "--config: "$CARDANO_CHAIN_INDEX_CONFIG
# cat $CARDANO_CHAIN_INDEX_CONFIG
echo " "
echo "Iniciando chain-index con: "
echo " "
echo "--config: "$CARDANO_CHAIN_INDEX_CONFIG
echo " "
echo; read -rsn1 -p "Press any key to continue . . ."; echo

IFS='|'; PLUTUS_APPS_ARR=($PLUTUS_APPS_LIST); unset IFS

length=${#PLUTUS_APPS_ARR[@]}
for (( j=1; j<=${length}; j++ ));
do
    printf "${j}: ${PLUTUS_APPS_ARR[${j}-1]}\n"
done
echo "-----"

echo "Opcion: "
read opcionPLUTUS_APPS
echo "-----"

PLUTUS_APPS_SELECTED=${PLUTUS_APPS_ARR[${opcionPLUTUS_APPS}-1]}

cd $PLUTUS_APPS_SELECTED

#cabal exec -- plutus-chain-index --config $CARDANO_CHAIN_INDEX_CONFIG start-index --verbose
cabal exec -- plutus-chain-index --config $CARDANO_CHAIN_INDEX_CONFIG start-index 