#!/bin/bash

CWD=$(pwd)

opcionMenuTools=""

while ! [[ $opcionMenuTools = "0" ]]; do

    



    printf "\nOPERACIONES:\n"
    
    
    echo "--"

    echo "11: Iniciar Cardano Node ($CARDANO_NODE_NETWORK)"  
    echo "12: Check Cardano Node ($CARDANO_NODE_NETWORK)"  

    echo "--"

    echo "2: Iniciar Wallet Server"

    echo "--"

    printf "NIX SHELL:\n"

    echo "--"

    user=$(whoami)
    if [[ $user = "root" ]]; then

        echo "31: Cambiar a usuario normal"
        echo "    No puede Iniciar NIX desde root"
        echo " "
    
    else

        echo "32: Iniciar Nix Shell"  

    fi

    echo "--"

    echo "4: Iniciar Chain Index Server"

    echo "--"

    echo "51: Inicicar Playgroud Server"
    echo "52: Inicicar Playground Client"

    echo "--"

    echo "6: Inicicar Plutus Docs"

    echo "--"

    echo "7: Inicicar VCODE en scripts"

    echo "--"

    echo "9:  Arreglar Permisos de carpetas"
    echo "91: Agregar carpeta a safeDirectory de Git"

    echo " "

    echo "--"

    echo "100: Instalar linux tools necesarias"
    echo "    (jq, yq, etc.)"
    echo " "

    echo "--"

    echo "101: Verificar directorios y tools"

    echo "--"

    echo "0: Regresar al Menu Principal"

    echo "--"

    echo "Opcion: "

    #read -n 1 -s opcionMenuTools
    read opcionMenuTools

    if [[ $opcionMenuTools = "11" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-cardano-node.sh"    
    fi

    if [[ $opcionMenuTools = "12" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/cardano-node-check.sh" 
        
        echo; read -rsn1 -p "Press any key to continue . . ."; echo
    fi

    if [[ $opcionMenuTools = "2" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-cardano-wallet-server.sh"
    fi

    if [[ $opcionMenuTools = "31" ]]; then 
        sudo -su $USER
    fi

    if [[ $opcionMenuTools = "32" ]]; then 
        bash "$NIX_SHELL"
    fi

    if [[ $opcionMenuTools = "4" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-chain-index-server.sh"
    fi

    if [[ $opcionMenuTools = "51" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-playground-server.sh"
    fi

    if [[ $opcionMenuTools = "52" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-playground-client.sh"
    fi

    if [[ $opcionMenuTools = "6" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/init-plutus-docs.sh"
    fi

    if [[ $opcionMenuTools = "7" ]]; then 
        code "$PLUTUS_DEVS/cardano-devs-scripts"
    fi

    if [[ $opcionMenuTools = "9" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/fix-permisos.sh"
    fi

    if [[ $opcionMenuTools = "91" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/fix-git-permisos.sh"
    fi

    if [[ $opcionMenuTools = "100" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/install.sh"
    fi

    if [[ $opcionMenuTools = "101" ]]; then 
        bash "$PLUTUS_DEVS_SCRIPTS/tools/check-directories.sh"
    fi
done