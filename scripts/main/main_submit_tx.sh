#!/bin/bash


echo " "
echo "Elija tx para enviar: "

read txFile

printf "\n\nRealizando Transferencia...\n\n"

$CARDANO_NODE/cardano-cli transaction submit \
    --$NETWORK_WITH_MAGIC \
    --tx-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/$txFile

if [ "$?" == "0" ]; then
    printf "\nTransferencia Realidada!\n"
    echo; read -rsn1 -p "Press any key to continue . . ."; echo
else
    printf "\nError en submit Transferencia\n"
    echo; read -rsn1 -p "Press any key to continue . . ."; echo
fi
