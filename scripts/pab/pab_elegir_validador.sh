#!/bin/bash

printf "\nValidador: "

printf "\n1: LockerV1"
printf "\n2: AlwaysTrueV1"
printf "\n3: AlwaysFalseV1"
printf "\n4: BeneficiaryV1"
printf "\n5: DeadlineV1"
printf "\n6: RedeemerV1"
printf "\n7: MarketNFTV1"
printf "\n8: StakeSimpleV1"
printf "\n9: StakePlusV1"
printf "\n"

scriptNumero=
while [[ $scriptNumero = "" || $scriptNumero <1 || $scriptNumero > 9 ]]; do
    read scriptNumero
done

if [[ $scriptNumero = "1" ]]; then
    scriptName="LockerV1"
    scriptNumeroOpcionExportCBOR=3
    #scriptNumeroOpcionExportHash=4
fi
if [[ $scriptNumero = "2" ]]; then
    scriptName="AlwaysTrueV1"
    scriptNumeroOpcionExportCBOR=5
    scriptNumeroOpcionExportHash=6
fi
if [[ $scriptNumero = "3" ]]; then
    scriptName="AlwaysFalseV1"
    scriptNumeroOpcionExportCBOR=7
    #scriptNumeroOpcionExportHash=8
fi
if [[ $scriptNumero = "4" ]]; then
    scriptName="BeneficiaryV1"
    scriptNumeroOpcionExportCBOR=9
    #scriptNumeroOpcionExportHash=10
fi
if [[ $scriptNumero = "5" ]]; then
    scriptName="DeadlineV1"
    scriptNumeroOpcionExportCBOR=11
    #scriptNumeroOpcionExportHash=12
fi
if [[ $scriptNumero = "6" ]]; then
    scriptName="RedeemerV1"
    scriptNumeroOpcionExportCBOR=13
    #scriptNumeroOpcionExportHash=14
fi
if [[ $scriptNumero = "7" ]]; then
    scriptName="MarketNFTV1"
    scriptNumeroOpcionExportCBOR=123
    scriptNumeroOpcionExportHash=124
    #scriptNumeroOpcionTestWithPABSimulator=125
fi

if [[ $scriptNumero = "8" ]]; then
    scriptName="StakeSimpleV1"
    scriptNumeroOpcionExportCBOR=133
    scriptNumeroOpcionExportHash=134
    #scriptNumeroOpcionTestWithPABSimulator=135
fi

if [[ $scriptNumero = "9" ]]; then
    scriptName="StakePlusV1"
    scriptNumeroOpcionExportCBOR=143
    scriptNumeroOpcionExportHash=144
    #scriptNumeroOpcionTestWithPABSimulator=145
fi


until [[ -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.plutus" && -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.hash"   && -f "$PLUTUS_DEVS_SCRIPTS_FILES/validators/V1/${scriptName}.addr" ]]
do

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