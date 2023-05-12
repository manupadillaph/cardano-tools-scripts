#!/bin/bash

CWD=$(pwd)

opcionMenuEnv=""

while ! [[ $opcionMenuEnv = "0" ]]; do


    printf "\nOPERACIONES:\n"
    
    echo "--"

    echo "1: Editar ~/.bashrc"  

    echo "--"

    echo "21: Editar write-env-list.sh"  
    echo "22: Editar write-env-list-mainnet.sh"  
    echo "23: Editar write-env-list-testnet-pre-production.sh"  
    echo "24: Editar write-env-list-testnet-preview.sh"  

    echo "--"

    echo "31: Exportar variables ENV para TESNTET Preview"

    echo "Para set env en esta sesion ejecute en promt:"
    echo "source \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-testnet-preview.sh\""

    echo "--"

    echo "32: Exportar variables ENV para TESNTET Pre-Production"

    echo "Para set env en esta sesion ejecute en promt:"
    echo "source \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-testnet-pre-production.sh\""

    echo "--"

    echo "33: Exportar variables ENV para MAINNET"

    echo "Para set env en esta sesion ejecute en promt:"
    echo "source \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh\""

    echo "--"

    echo "34: Activate nix-shell"
    echo "35: Create-sym-link-nix-shell in folder"
    echo "36: Delete-sym-links-nix-shell in folder"
    echo "37: Activate direnv in folder"

    echo "--"

    echo "0: Regresar al Menu Principal"

    echo "--"

    echo "Opcion: "

    #read -n 1 -s opcionMenuEnv
    read opcionMenuEnv

    if [[ $opcionMenuEnv = "1" ]]; then 
        vim ~/.bashrc
    fi

    if [[ $opcionMenuEnv = "21" ]]; then 
        vim "$PLUTUS_DEVS_SCRIPTS/env/write-env-list.sh"
    fi

    if [[ $opcionMenuEnv = "22" ]]; then 
        vim "$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh"
    fi

    if [[ $opcionMenuEnv = "23" ]]; then 
        vim "$PLUTUS_DEVS_SCRIPTS/env/write-env-list-testnet-pre-production.sh"
    fi

    if [[ $opcionMenuEnv = "24" ]]; then 
        vim "$PLUTUS_DEVS_SCRIPTS/env/write-env-list-testnet-preview.sh"
    fi

    if [[ $opcionMenuEnv = "31" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/write-env-testnet-preview.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
        
    fi

    if [[ $opcionMenuEnv = "32" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/write-env-testnet-pre-production.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
        
    fi

    if [[ $opcionMenuEnv = "33" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/write-env-mainnet.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    if [[ $opcionMenuEnv = "34" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/activate-shell-nix.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    if [[ $opcionMenuEnv = "35" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/create-sym-link-nix-shell.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    if [[ $opcionMenuEnv = "36" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/delete-sym-links-nix-shell.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    if [[ $opcionMenuEnv = "37" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/env/activate-direnv.sh"
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    
done