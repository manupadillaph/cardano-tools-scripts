#!/bin/bash


echo " "
echo "Elija tx in: "

tokens=()
tokensTotal=()
lovelaceTotal=0

source "$PLUTUS_DEVS_SCRIPTS/main/main_elegir_utxo_wallet.sh"

if [[ $lovelaceTotal = 0 ]]; then

    echo "Error en utxos elegidas: No se encuentran fondos para usar"
    echo; read -rsn1 -p "Press any key to continue . . ."; echo
else

    echo "Txin Elegidas: "

    results=""
    while IFS= read -r txin
    do
        results="$results\n$($CARDANO_NODE/cardano-cli query utxo\
        --tx-in $txin --$NETWORK_WITH_MAGIC)"
    done < "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.utxo"

    echo "$results" | grep -Po "[a-zA-Z0-9]+ +[0-9]+ +[a-zA-Z0-9 \+\.\"]+" | nl 
        
    echo " "
    echo "Elija cual desea usar para collateral: "
    read collateralIx

    walletTxIn=$(cat "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.utxo" | sed -n ${collateralIx}p)

    echo "walletTxIn: "$walletTxIn
    echo "walletTxInArray: "$walletTxInArray

    # tokens=()
    # tokensTotal=()
    # NO INICIO LOS TOTALES DE TOKENS POR QUE SE SUMAN CON LOS INPUTS DE LA BILETERA Y LOS NECESITO ABAJO PARA LA walletTxOutArrayForChangeOfTokens
    # EN CAMBIO SI INICIO lovelaceTotal POR QUE ME SIRVE PARA CONTROLAR SI ELIGIO ALGO CORRECTO Y TAMPOCO NECESITO EL TOTAL QUE VIENE DE LA BILLETERA.
    lovelaceTotal=0

    echo " "
    echo "Elija tx para redeem: "

    source "$PLUTUS_DEVS_SCRIPTS/main/main_elegir_utxo_script.sh"

    if [[ $lovelaceTotal = 0 ]]; then

        echo "Error en utxos: No se encuentran fondos para redeem"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    else

        read -r scriptTxIn  < $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.utxo
        echo "scriptTxIn: "$scriptTxIn
        echo "scriptTxInArray: "$scriptTxInArray

        swChangeTokens=0
        #walletTxOutArrayForChangeOfTokens="$walletAddr $minimoADA lovelace"
        walletTxOutArrayForChangeOfTokens="addr_test1qzw3nd0m4cnzkfxe738clcpywhsujh7myrdu8yngkat8yqssdh2l2jjgrlre52sj0ldwu9q04f0j8xp7amqwg5duy6pq3tf9fd $minimoADA lovelace"

        for i in ${!tokens[@]}; do
            txout="${tokensTotal[$i]} ${tokens[$i]}"
            walletTxOutArrayForChangeOfTokens="$walletTxOutArrayForChangeOfTokens + $txout "
            swChangeTokens=1
        done

        if [[ $swChangeTokens = 1 ]]; then

            printf "\nwallet TxOutArray For Change Of Tokens:\n"
            echo $walletTxOutArrayForChangeOfTokens

        fi 

        source "$PLUTUS_DEVS_SCRIPTS/tools/get-tx-protocols.sh"

        $CARDANO_NODE/cardano-cli query tip --$NETWORK_WITH_MAGIC | jq -r .slot >$PLUTUS_DEVS_SCRIPTS_FILES/config/tx/tip.slot

        tipSlot=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/config/tx/tip.slot)

        source "$PLUTUS_DEVS_SCRIPTS/main/main_datum_elegir_crear.sh"


        printf "\nRedeemer ---- \n"

        redeemerFile=""

        until [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json"  ]]
        do
            printf "\nIngrese nombre para el archivo Redeemer (DEF): "
            read redeemerFile
            if [[ $redeemerFile = "" ]]; then 
                redeemerFile="DEF"
            fi

            if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json"  ]]
            then
                printf "\nRedeemer file $redeemerFile.json no existe\n"
            fi
            
            printf "\nDesea crear Redeemer file (y/n):\n"
            read -n 1 -s opcion
            if [[ $opcion = "y" ]]; then 

                printf "\nIngrese redeemer (55): "
                read redeemerOpcion
                if [[ $redeemerOpcion = "" ]]; then 
                    redeemerOpcion="55"
                fi

                #Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
                CWD=$(pwd)
                cd $PLUTUS_DEVS_HASKELL

                printf "%s\n%s\n%s\n" "2" "$PLUTUS_DEVS_SCRIPTS_FILES/redeemers" "$redeemerFile" "$redeemerOpcion" | cabal exec deploy-auto
                
                cd $CWD

            fi

        done

        printf "\n\nRealizando transferencia...\n\n"


        if [[ $swChangeTokens = 1 ]]; then

            echo --babbage-era \
                --$NETWORK_WITH_MAGIC \
                --change-address $walletAddr \
                $walletTxInArray \
                --tx-in $scriptTxIn \
                --tx-in-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/$scriptName.plutus \
                --tx-in-datum-file  $PLUTUS_DEVS_SCRIPTS_FILES/datums/$datumFile.json \
                --tx-in-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json  \
                --tx-in-collateral $walletTxIn \
                --tx-out "$walletTxOutArrayForChangeOfTokens" \
                --tx-out "$walletAddr 2500000 lovelace" \
                --required-signer-hash $walletSig \
                --required-signer=$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
                --protocol-params-file $ppFile \
                --invalid-before ${tipSlot} \
                --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.body 
       
            echo ""

            printf "\n\nCon Change...\n\n"
            echo ""

            $CARDANO_NODE/cardano-cli transaction build \
                --babbage-era \
                --$NETWORK_WITH_MAGIC \
                --change-address addr_test1qzw3nd0m4cnzkfxe738clcpywhsujh7myrdu8yngkat8yqssdh2l2jjgrlre52sj0ldwu9q04f0j8xp7amqwg5duy6pq3tf9fd \
                $walletTxInArray \
                --tx-in $scriptTxIn \
                --tx-in-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/$scriptName.plutus \
                --tx-in-datum-file  $PLUTUS_DEVS_SCRIPTS_FILES/datums/$datumFile.json \
                --tx-in-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json  \
                --tx-in-collateral $walletTxIn \
                --tx-out "$walletTxOutArrayForChangeOfTokens" \
                --tx-out "$walletAddr 2500000 lovelace" \
                --required-signer-hash $walletSig \
                --required-signer=$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
                --protocol-params-file $ppFile \
                --invalid-before ${tipSlot} \
                --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.body 
        else
            echo --babbage-era \
                --$NETWORK_WITH_MAGIC \
                --change-address $walletAddr \
                $walletTxInArray \
                --tx-in $scriptTxIn \
                --tx-in-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/$scriptName.plutus \
                --tx-in-datum-file  $PLUTUS_DEVS_SCRIPTS_FILES/datums/$datumFile.json \
                --tx-in-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json  \
                --tx-in-collateral $walletTxIn \
                --required-signer-hash $walletSig \
                --required-signer=$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
                --protocol-params-file $ppFile \
                --invalid-before ${tipSlot} \
                --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.body 

            echo ""
            
            $CARDANO_NODE/cardano-cli transaction build \
                --babbage-era \
                --$NETWORK_WITH_MAGIC \
                --change-address $walletAddr \
                $walletTxInArray \
                --tx-in $scriptTxIn \
                --tx-in-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/$scriptName.plutus \
                --tx-in-datum-file  $PLUTUS_DEVS_SCRIPTS_FILES/datums/$datumFile.json \
                --tx-in-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/$redeemerFile.json  \
                --tx-in-collateral $walletTxIn \
                --required-signer-hash $walletSig \
                --required-signer=$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
                --protocol-params-file $ppFile \
                --invalid-before ${tipSlot} \
                --out-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.body 
        fi

        if [ "$?" == "0" ]; then

            $CARDANO_NODE/cardano-cli transaction sign \
                --tx-body-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.body \
                --signing-key-file $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey \
                --$NETWORK_WITH_MAGIC \
                --out-file  $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.signed

            if [ "$?" == "0" ]; then

                $CARDANO_NODE/cardano-cli transaction submit \
                    --$NETWORK_WITH_MAGIC \
                    --tx-file $PLUTUS_DEVS_SCRIPTS_FILES/transacciones/${scriptName}.signed


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
fi