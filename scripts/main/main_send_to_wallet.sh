#!/bin/bash


printf "\nWallet Address a donde enviar: "
sentToAddr=
while [[ $sentToAddr = "" ]]; do
    read sentToAddr
done

echo " "
echo "Elija tx in para enviar: "

tokens=()
tokensTotal=()
lovelaceTotal=0

source "$PLUTUS_DEVS_SCRIPTS/main/main_elegir_utxo_wallet.sh"

if [[ $lovelaceTotal = 0 ]]; then

    echo "Error en utxos elegidas: No se encuentran fondos para enviar"
    echo; read -rsn1 -p "Press any key to continue . . ."; echo
else

    echo "walletTxIn: "$walletTxIn
    echo "walletTxInArray: "$walletTxInArray

    printf "\nCantidad ADA (Max: $lovelaceTotal sin tener en cuenta Fee, ni $minimoADA ADA para txo de change si sobran Tokens): "
    read cantidad
    if [[ $cantidad = "" ]]; then 
        cantidad="$lovelaceTotal"
    fi


    walletTxOutMultiAssets="$sentToAddr $cantidad lovelace"

    swChangeTokens=0
    walletTxOutArrayForChangeOfTokens="$walletAddr $minimoADA lovelace"

    for i in ${!tokens[@]}; do
        printf "\nCantidad Token ${tokens[$i]} (Max: ${tokensTotal[$i]}): "
        read cantidadToken
        if [[ $cantidadToken = "" ]]; then 
            cantidadToken="${tokensTotal[$i]}"
        fi
        
        tokensTotal[$i]=$((${tokensTotal[$i]}-$cantidadToken))

        txout="$cantidadToken ${tokens[$i]}"
        walletTxOutMultiAssets="$walletTxOutMultiAssets + $txout "

        if [[ ${tokensTotal[$i]} > 0 ]];then
            printf "\nSobran: ${tokensTotal[$i]}\n"

            txout="${tokensTotal[$i]} ${tokens[$i]}"
            walletTxOutArrayForChangeOfTokens="$walletTxOutArrayForChangeOfTokens + $txout "
            swChangeTokens=1
        fi

    done

    printf "\nwalletTxOutMultiAssets:\n"
    echo $walletTxOutMultiAssets

    printf "\nwalletTxOutArrayForChangeOfTokens:\n"
    echo $walletTxOutArrayForChangeOfTokens


    printf "\n\nRealizando Transferencia...\n\n"

    if [[ $swChangeTokens = 0 ]]; then
        $CARDANO_NODE/cardano-cli transaction build \
            --babbage-era \
            --$NETWORK_WITH_MAGIC \
            --change-address $walletAddr \
            $walletTxInArray \
            --tx-out "$walletTxOutMultiAssets" \
            --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/sendTo.body 
    else

        $CARDANO_NODE/cardano-cli transaction build \
            --babbage-era \
            --$NETWORK_WITH_MAGIC \
            --change-address $walletAddr \
            $walletTxInArray \
            --tx-out "$walletTxOutMultiAssets" \
            --tx-out "$walletTxOutArrayForChangeOfTokens" \
            --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/sendTo.body 
    fi

    if [ "$?" == "0" ]; then

        $CARDANO_NODE/cardano-cli transaction sign \
            --tx-body-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/sendTo.body \
            --signing-key-file $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
            --$NETWORK_WITH_MAGIC \
            --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/sendTo.signed

        if [ "$?" == "0" ]; then

            $CARDANO_NODE/cardano-cli transaction submit \
                --$NETWORK_WITH_MAGIC \
                --tx-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/sendTo.signed

            if [ "$?" == "0" ]; then
                 printf "\nTransferencia Realidada!\n"
                echo; read -rsn1 -p "Press any key to continue . . ."; echo
            else
                printf "\nError en submit Transferencia\n"
                echo; read -rsn1 -p "Press any key to continue . . ."; echo
            fi
        else
            printf "\nError en sign Transferencia\n"
            echo; read -rsn1 -p "Press any key to continue . . ."; echo
        fi
    else
        printf "\nError en build Transferencia\n"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

fi