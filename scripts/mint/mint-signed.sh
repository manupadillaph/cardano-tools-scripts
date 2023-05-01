#!/bin/bash


addrFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr"
skeyFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey"


# echo "walletTxIn: $walletTxIn"
# echo "amt: $amt"
# echo "tn: $tn"
# echo "address file: $addrFile"
# echo "signing key file: $skeyFile"
# echo "payment key hash: $walletSig"

walletAddr=$(cat $addrFile)

token_name=""

scriptPolicyName=""
until [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1/Signed-${scriptPolicyName}.plutus"  ]]
do

    printf "\nNombre de archivo de Minting Policy Signed: "

    scriptPolicyName=
    while [[ $scriptPolicyName = "" ]]; do
        read scriptPolicyName
    done

    if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1/Signed-${scriptPolicyName}.plutus" ]]
    then
        printf "\nMinting Policiy file Signed-${scriptPolicyName}.plutus no existe\n"
    fi

    printf "\nDesea crear files Signed.plutus de la policy en haskell (y/n)\n"
    read -n 1 -s opcion
    if [[ $opcion = "y" ]]; then 

        echo "Polcy en base de: $walletSig"
        
        #Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
        CWD=$(pwd)
        cd $PLUTUS_DEVS_HASKELL

        #printf "%s\n%s\n%s\n" "18" "$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1" "Signed-${scriptPolicyName}" "$walletAddr" | cabal exec deploy-auto
        printf "%s\n%s\n%s\n" "19" "$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1" "Signed-${scriptPolicyName}" "$walletSig" | cabal exec deploy-auto

        cd $CWD
    fi

done

policyFile="$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1/Signed-${scriptPolicyName}.plutus"

source "$PLUTUS_DEVS_SCRIPTS/mint/token-metadata-creator.sh"

printf "\nDesea Mint Signed token ahora (y/n)?\n"
read -n 1 -s opcion
if [[ $opcion = "y" ]]; then 

    printf "\nNombre del Token: "
    token_name=
    while [[ $token_name = "" ]]; do
        read token_name
    done
    
    printf "\nCantidad que desea acuñar: "
    token_cantidad=
    while [[ $token_cantidad = "" ]]; do
        read token_cantidad
    done

    source "$PLUTUS_DEVS_SCRIPTS/tools/get-tx-protocols.sh"

    unsignedFile=$PLUTUS_DEVS_SCRIPTS_FILES/transacciones/Signed.unsigned
    signedFile=$PLUTUS_DEVS_SCRIPTS_FILES/transacciones/Signed.signed

    pid=$($CARDANO_NODE/cardano-cli transaction policyid --script-file $policyFile)

    #Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
    CWD=$(pwd)
    cd $PLUTUS_DEVS_HASKELL

    tnHex=$(cabal exec utils-token-name -- $token_name)

    cd $CWD

    addr=$(cat $addrFile)

    v="$token_cantidad $pid.$tnHex"

    echo "currency symbol: $pid"

    echo "token name (hex): $tnHex"

    echo "minted value: $v"

    # echo "address: $addr"

    printf "\n\nRealizando transferencia...\n\n"

     if [[ $swChangeTokens = 1 ]]; then

        $CARDANO_NODE/cardano-cli transaction build \
            --babbage-era \
            --$NETWORK_WITH_MAGIC \
            $walletTxInArray \
            --tx-in-collateral $walletTxIn \
            --tx-out "$addr + $minimoADA lovelace + $v" \
            --tx-out "$walletTxOutArrayForChangeOfTokens" \
            --mint "$v" \
            --mint-script-file $policyFile \
            --mint-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/unit.json \
            --change-address $addr \
            --required-signer-hash $walletSig \
            --required-signer=$skeyFile  \
            --protocol-params-file $ppFile \
            --out-file $unsignedFile 

    else
        $CARDANO_NODE/cardano-cli transaction build \
            --babbage-era \
            --$NETWORK_WITH_MAGIC \
            $walletTxInArray \
            --tx-in-collateral $walletTxIn \
            --tx-out "$addr + $minimoADA lovelace + $v" \
            --mint "$v" \
            --mint-script-file $policyFile \
            --mint-redeemer-file $PLUTUS_DEVS_SCRIPTS_FILES/redeemers/unit.json \
            --change-address $addr \
            --required-signer-hash $walletSig \
            --required-signer=$skeyFile  \
            --protocol-params-file $ppFile \
            --out-file $unsignedFile 
    fi


    if [ "$?" == "0" ]; then   

        $CARDANO_NODE/cardano-cli transaction sign \
            --tx-body-file $unsignedFile \
            --signing-key-file $skeyFile \
            --$NETWORK_WITH_MAGIC \
            --out-file $signedFile

        if [ "$?" == "0" ]; then      

            $CARDANO_NODE/cardano-cli transaction submit \
                --$NETWORK_WITH_MAGIC \
                --tx-file $signedFile

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