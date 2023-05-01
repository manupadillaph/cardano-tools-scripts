#!/bin/bash


scriptName=""
until [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.plutus" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.hash"   && -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.addr" ]]
do

    printf "\nNombre del Script: "

    scriptName=
    while [[ $scriptName = "" ]]; do
        read scriptName
    done

    if ! [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.plutus" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.hash" ]]
    then
        printf "\nValidator script file ${scriptName} no existe\n"
    else
        $CARDANO_NODE/cardano-cli address build  \
        --payment-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.plutus --out-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.addr --$NETWORK_WITH_MAGIC
    fi

    printf "\nDesea crear files .plutus, .hash del validator en haskell (y/n)\nImportante: Necesita tener NODO configurado e iniciado\n"
    read -n 1 -s opcion
    if [[ $opcion = "y" ]]; then 
        
        printf "\nElija que Validador desea exportar: "

        printf "\n1: Locker V1"
        printf "\n2: AlwaysTrue V1"
        printf "\n3: AlwaysFalse V1"
        printf "\n4: Beneficiary V1"
        printf "\n5: Deadline V1"
        printf "\n6: Redeemer V1"

        printf "\n7: Market NFT V1"

        printf "\n8: Stake Simple V1"
        printf "\n9: Stake Plus V1"

        printf "\n"

        scriptNumero=
        while [[ $scriptNumero = "" || $scriptNumero <1 || $scriptNumero > 9 ]]; do
            read scriptNumero
        done

        if [[ $scriptNumero = "1" ]]; then
            # scriptName="Locker"
            scriptNumeroOpcionExportCBOR=3
            scriptNumeroOpcionExportHash=4
        fi
        if [[ $scriptNumero = "2" ]]; then
            # scriptName="AlwaysTrue"
            scriptNumeroOpcionExportCBOR=5
            scriptNumeroOpcionExportHash=6
        fi
        if [[ $scriptNumero = "3" ]]; then
            # scriptName="AlwaysFalse"
            scriptNumeroOpcionExportCBOR=7
            scriptNumeroOpcionExportHash=8
        fi
        if [[ $scriptNumero = "4" ]]; then
            # scriptName="Beneficiary"
            scriptNumeroOpcionExportCBOR=9
            scriptNumeroOpcionExportHash=10
        fi
        if [[ $scriptNumero = "5" ]]; then
            # scriptName="Deadline"
            scriptNumeroOpcionExportCBOR=11
            scriptNumeroOpcionExportHash=12
        fi
        if [[ $scriptNumero = "6" ]]; then
            # scriptName="Redeemer"
            scriptNumeroOpcionExportCBOR=13
            scriptNumeroOpcionExportHash=14
        fi

        if [[ $scriptNumero = "7" ]]; then
            # scriptName="Market NFT"
            scriptNumeroOpcionExportCBOR=123
            scriptNumeroOpcionExportHash=124
            scriptNumeroOpcionTestWithPABSimulator=125
        fi

        if [[ $scriptNumero = "8" ]]; then
            # scriptName="Stake Simple"
            scriptNumeroOpcionExportCBOR=133
            scriptNumeroOpcionExportHash=134
            scriptNumeroOpcionTestWithPABSimulator=135
        fi

        if [[ $scriptNumero = "9" ]]; then
            # scriptName="Stake Plus"
            scriptNumeroOpcionExportCBOR=143
            scriptNumeroOpcionExportHash=144
            scriptNumeroOpcionTestWithPABSimulator=145
        fi


        # -- putStrLn "121: write Validator Market NFT V1 datum"
        # -- putStrLn "122: write Validator Market NFT V1 redeemer"
        # -- putStrLn "123: write Validator Market NFT V1 cbor"
        # -- putStrLn "124: write Validator Market NFT V1 hash"

        # -- putStrLn "131: write Validator Stake Simple V1 datum"
        # -- putStrLn "132: write Validator Stake Simple V1 redeemer"
        # -- putStrLn "133: write Validator Stake Simple V1 cbor"
        # -- putStrLn "134: write Validator Stake Simple V1 hash"

        # -- putStrLn "141: write Validator Stake Plus V1 datum"
        # -- putStrLn "142: write Validator Stake Plus V1 redeemer"
        # -- putStrLn "143: write Validator Stake Plus V1 cbor"
        # -- putStrLn "144: write Validator Stake Plus V1 hash"    


        

        #Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
        CWD=$(pwd)
        cd $PLUTUS_DEVS_HASKELL
        
        printf "%s\n%s\n%s\n" "$scriptNumeroOpcionExportCBOR" "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1" "$scriptName" | cabal exec deploy-auto 
        printf "%s\n%s\n%s\n" "$scriptNumeroOpcionExportHash" "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1" "$scriptName" | cabal exec deploy-auto 
        
        cd $CWD

        $CARDANO_NODE/cardano-cli address build  \
        --payment-script-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.plutus --out-file $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.addr --$NETWORK_WITH_MAGIC

    fi

done

scriptAddr=$(cat $PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.addr)

echo "Script Address:" $scriptAddr