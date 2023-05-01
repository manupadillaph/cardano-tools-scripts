#!/bin/bash


addrFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr"
skeyFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey"

#policyFile="$PLUTUS_DEVS_SCRIPTS_FILES/mintingpolicies/V1/Tokens-${scriptPolicyName}.plutus"

echo "Creando token metadata para: script-file $policyFile"

pid=$($CARDANO_NODE/cardano-cli transaction policyid --script-file $policyFile)

if  [[ $token_name = "" ]];
then
    printf "\nNombre del Token: "
    token_name=
    while [[ $token_name = "" ]]; do
        read token_name
    done
fi

echo ""
echo "Recuerde que debe estar dentro de NIX SHELL para usar basenc command..."
echo ""

tnHex=$(echo -n $token_name | basenc --base16 | awk '{print tolower($0)}')
        
echo "Asset name '$token_name' encoded as base16: '$tnHex'"

SUBJECT="$pid$tnHex"

mintMetadataFile=$PLUTUS_DEVS_SCRIPTS_FILES/token-metadata/tx-$SUBJECT.json
usarMintMetadataFile=False

echo "Subject is '$SUBJECT'"

if [[ -f "$mintMetadataFile" ]]
then
    printf "\nArhivo de Metadatos encontrado\n"

    printf "\nDesea Utilizarlo (y/n)?\n"

    read -n 1 -s opcion
    if ! [[ $opcion = "y" ]]; then 
        rm "$mintMetadataFile" 
    fi
fi


if ! [[ -f "$mintMetadataFile" ]]
then

    printf "\nArhivo de Metadatos no existe\n"

    printf "\nDesea Crear Metadatos ahora (y/n)?\n"
    read -n 1 -s opcion
    if [[ $opcion = "y" ]]; then 

        if  [[ $token_name = "" ]];
        then
            printf "\nNombre del Token: "
            token_name=
            while [[ $token_name = "" ]]; do
                read token_name
            done

            tnHex=$(echo -n $token_name | basenc --base16 | awk '{print tolower($0)}')
        
            echo "Asset name '$token_name' encoded as base16: '$tnHex'"
        fi
        

        
        

        printf "\nDescripcion: "
        token_desc=
        while [[ $token_desc = "" ]]; do
            read token_desc
        done
        

        printf "\nTiker: "
        token_tiker=
        while [[ $token_tiker = "" ]]; do
            read token_tiker
        done

        printf "\nURL (https://www.example.com): "
        token_url=
        while [[ $token_url = "" ]]; do
            read token_url
        done

        printf "\nLogo (Png File in folder: $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata): "
        token_logo=
        while [[ $token_logo = "" ]]; do
            read token_logo
        done

        printf "\nURL Logo IPFS (ipfs://<hash>): "
        token_logo_ipfs=
        while [[ $token_logo_ipfs = "" ]]; do
            read token_logo_ipfs
        done

        # printf "\nURL Logo Icon IPFS (ipfs://<hash>): "
        # token_logo_icon_ipfs=
        # while [[ $token_logo_icon_ipfs = "" ]]; do
        #     read token_logo_icon_ipfs
        # done

        printf "\nDecimals: "
        token_decimals=
        while [[ $token_decimals = "" ]]; do
            read token_decimals
        done


        # Esto no hace falta, con la otra forma arriba calcula mas rapido...
        # #Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
        # CWD=$(pwd)
        # cd $PLUTUS_DEVS_HASKELL

        # tnHex=$(cabal exec utils-token-name -- $token_name)

        # cd $CWD


        
        CWD=$(pwd)
        cd $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata

        $CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry --init $SUBJECT

        $CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT \
            --name "$token_name" \
            --description "$token_desc" \

        $CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT \
            --ticker "$token_tiker" \
            --url "$token_url" \
            --logo "$token_logo" \
            --decimals $token_decimals

        $CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT -a $skeyFile

        $CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT --finalize

        cd $CWD
    
        JSON_STRING="{  \"721\": {\"${pid}\": {\"$token_tiker\": { \"name\": \"${token_name}\", \"image\": \"${token_logo_ipfs}\",\"mediaType\": \"image/png\",\"description\": \"$token_desc\",\"files\": [{ \"name\": \"${token_name}\",\"mediaType\": \"image/png\", \"src\": \"${token_logo_ipfs}\" }]}},\"version\": 2 },  \"20\": {\"${pid}\": {\"$tnHex\": {\"ticker\": \"$token_tiker\",\"url\": \"$token_url\",\"desc\": \"$token_desc\",\"icon\": \"$token_logo_ipfs\", \"decimals\": $token_decimals, \"version\": \"1.0\"}}} }"

        echo $JSON_STRING>>$mintMetadataFile
    
        echo "JSON Files created at: "

        echo "Tx Metadata for minting: "
        echo $mintMetadataFile
        

        echo "Metadata for register in https://github.com/cardano-foundation/cardano-token-registry:"
        echo $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata/$SUBJECT.json

        usarMintMetadataFile=True

    else

        usarMintMetadataFile=False

    fi

else

    usarMintMetadataFile=True

fi