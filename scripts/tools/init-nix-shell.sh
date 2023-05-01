#!/bin/bash

echo "Iniciando nix-shell en plutus-apps folder..."

user=$(whoami)

if [[ $user = "root" ]]; then

    echo "------"
    echo "Debe usar NIX SHELL desde un usuario normal. No desde: $user."
    echo "Ahora voy a cambiar la session. Ejecute luego nuevamente: "
    echo "\$NIX_SHELL"
    echo "-----"
    echo '$NIX_SHELL' | xclip
    
    sudo -su $USUARIO

else

    #sudo -su manuelpadilla 
    source  ~/.nix-profile/etc/profile.d/nix.sh #/home/manuelpadilla/.nix-profile/etc/profile.d/nix.sh

    CWD=$(pwd)

    export CWD

    echo "Puede regresar a la carpeta donde estaba ejecutando: "
    echo "source \$BACK2CWD"
    #echo "cd \$CWD"

    echo "-----"

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

    cd $PLUTUS_APPS_SELECTED
    
    nix-shell 

fi

# --extra-experimental-features flakes # ya no necesito pasarlo por parametro 
# por que lo puse directamente en el archivo /etc/nix/nix.conf:
# experimental-features = nix-command flakes
# allow-import-from-derivation = true
# substituters = https://cache.nixos.org https://hydra.iohk.io
# trusted-public-keys = iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=