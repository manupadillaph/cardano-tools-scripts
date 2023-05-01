#!/bin/bash

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

echo "Selected: $PLUTUS_APPS_SELECTED"

cd "$PLUTUS_APPS_SELECTED"




