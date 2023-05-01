#!/bin/bash


opcionMenuTest=""

while ! [[ $opcionMenuTest = "0" ]]; do

    printf "\nTEST PLUTUS SCRIPTS\n"
 
    echo "1: Test With Trace Emulator"  
    echo "2: Test With PAB Simulator"  

    echo "--"

    echo "0: Regresar al Menu Principal"

    echo "--"

    echo "Opcion: "

    #read -n 1 -s opcionMenuTest
    read  opcionMenuTest

    if [[ $opcionMenuTest = "1" ]]; then 
        source "$PLUTUS_DEVS_SCRIPTS/test/test_trace_emulator.sh"
    fi  

    if [[ $opcionMenuTest = "2" ]]; then 
        source "$PLUTUS_DEVS_SCRIPTS/test/test_pab_simulator.sh"
    fi  

done