#!/bin/bash



minimoADA="1800000"

opcionMenuMint=""

while ! [[ $opcionMenuMint = "0" ]]; do

    printf "\nMINT TOKENS\n"
 
    echo "1: Elegir o Crear Wallet (${walletName})"  
    
    echo "2:  Mint Free"
    echo "21: Mint Free Batch"
    echo "3:  Mint NFT"
    echo "31: Mint NFT Signed"
    echo "4:  Mint Tokens"
    echo "41: Mint Tokens Signed"
    echo "5:  Mint Signed"

    echo "--"

    echo "9: Create Token Metada"

    echo "--"
    
    echo "0: Regresar al Menu Principal"

    echo "--"

    echo "Opcion: "

    #read -n 1 -s opcionMenuMint
    read  opcionMenuMint

    if [[ $opcionMenuMint = "1" ]]; then 
        source "$PLUTUS_DEVS_SCRIPTS/main/main_elegir_crear_wallet.sh"    
    fi

    if [[ $opcionMenuMint = "2" ||  $opcionMenuMint = "21" || $opcionMenuMint = "3" || $opcionMenuMint = "4" || $opcionMenuMint = "31" || $opcionMenuMint = "41" ||$opcionMenuMint = "5"  || $opcionMenuMint = "9"   ]]; 
    then 
        if [[ $walletName = ""  ]]; then
            printf "\nDebe elegir wallet primero\n"
            echo; read -rsn1 -p "Press any key to continue . . ."; echo
        else
        
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
                echo "Elija cual desea usar para collateral y como parametro de la mint: "
                read collateralIx

                walletTxIn=$(cat "$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.utxo" | sed -n ${collateralIx}p)

                echo "walletTxIn: "$walletTxIn
                echo "walletTxInArray: "$walletTxInArray

                swChangeTokens=0
                walletTxOutArrayForChangeOfTokens="$walletAddr $minimoADA lovelace"

                for i in ${!tokens[@]}; do
                    txout="${tokensTotal[$i]} ${tokens[$i]}"
                    walletTxOutArrayForChangeOfTokens="$walletTxOutArrayForChangeOfTokens + $txout "
                    swChangeTokens=1
                done

                if [[ $swChangeTokens = 1 ]]; then
                    printf "\nwalletTxOutArrayForChangeOfTokens:\n"
                    echo $walletTxOutArrayForChangeOfTokens
                fi 

                if [[ $opcionMenuMint = "2" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-free.sh" 
                fi

                if [[ $opcionMenuMint = "21" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-free-batch.sh" 
                fi

                if [[ $opcionMenuMint = "3" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-nft.sh"
                fi

                if [[ $opcionMenuMint = "31" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-nft-signed.sh"
                fi

                if [[ $opcionMenuMint = "4" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-tokens.sh"
                fi

                if [[ $opcionMenuMint = "41" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-tokens-signed.sh"
                fi

                if [[ $opcionMenuMint = "5" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/mint-signed.sh"  
                fi

                if [[ $opcionMenuMint = "9" ]]; then 
                    source "$PLUTUS_DEVS_SCRIPTS/mint/token-metadata-creator.sh"  
                fi
            fi
        
           
        fi
    fi  
  

done