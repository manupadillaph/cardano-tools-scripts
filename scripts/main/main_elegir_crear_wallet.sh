#!/bin/bash

walletLoadedInServerWallet=0

walletName=""
until [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.pkh" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey"  && -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.vkey"  ]]
do
    printf "\nNombre Wallet (01): "
    read walletName

    if [[ $walletName = "" ]]; then 
        walletName="01"
    fi

    if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.pkh" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey"  && -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.vkey"  ]]
    then
        printf "\nWallet pkh, skey, vkey files no existen\n"

        if [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.json"   ]]
        then
            printf "\nSe encontró ${walletName} JSON file, desea crearla desde allí (y/n)? \nImportante: Necesita tener NODO y WALLET SERVER configurados e iniciados \n"
            read -n 1 -s opcion
            if [[ $opcion = "y" ]]; then 

                bash $PLUTUS_DEVS_SCRIPTS/tools/wallet-create-con-cardano-wallet-desde-json.sh ${walletName}

                walletLoadedInServerWallet=1 

            fi
        fi

        if [[ $walletLoadedInServerWallet = 0 ]]; then 

            printf "\nDesea crear una nueva Wallet (y/n)? \nImportante: Necesita tener NODO y WALLET SERVER configurados e iniciados \n"
            read -n 1 -s opcion
            if [[ $opcion = "y" ]]; then 

                bash $PLUTUS_DEVS_SCRIPTS/tools/wallet-create-con-cardano-wallet.sh ${walletName} ${walletName}

                walletLoadedInServerWallet=1

            fi
        fi
    fi
done

if [[ $walletLoadedInServerWallet = 0 ]]; then

    if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.json" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.id"  ]]
    then
        printf "\nWallet ${walletName} JSON o id files no existen. No se puede cargar en la Wallet en el Wallet Server, algunas funciones estarán limitadas (como los servicios de PAB)\n"
    fi

    if [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.json"  ]]
    then
        bash $PLUTUS_DEVS_SCRIPTS/tools/wallet-load-con-cardano-wallet-desde-json.sh ${walletName}

        if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addrs" ]];
        then

            if  [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.id"  ]];
            then

                WALLET_ID=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/wallets/$walletName.id)

                DIRECCIONES=$(curl -H "content-type: application/json" \
                    -XGET localhost:$CARDANO_WALLET_PORT/v2/wallets/$WALLET_ID/addresses | jq -r '.[]' )

                echo $DIRECCIONES | jq -r '.id' >$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addrs

            fi
            
        fi
    fi

    if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr" ]]
    then
        $CARDANO_NODE/cardano-cli address build \
	        --payment-verification-key-file $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.vkey --out-file $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr --$NETWORK_WITH_MAGIC 
    fi
fi


walletAddr=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr)

echo "Wallet Address:" $walletAddr

walletSig=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.pkh)

echo "Payment Key HASH:" $walletSig

if [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.json"  ]]
then
    walletPassphrase=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.json | jq -r '.passphrase')
    echo "Passphrase:" $walletPassphrase
fi

