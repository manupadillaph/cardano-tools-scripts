#!/bin/bash

echo "Verificando la existencia de los directorios y archivos de configuracion:"

verificar_directorios_nombres=("SOURCE" "PLUTUS_DEVS" "PLUTUS_DEVS_HASKELL" "PLUTUS_DEVS_SCRIPTS" "PLUTUS_DEVS_SCRIPTS_FILES" "PLUTUS_DEVS_SCRIPTS_FILES_CONFIG" "PLUTUS_APPS")
verificar_directorios=("$SOURCE" "$PLUTUS_DEVS" "$PLUTUS_DEVS_HASKELL" "$PLUTUS_DEVS_SCRIPTS" "$PLUTUS_DEVS_SCRIPTS_FILES" "$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG" "$PLUTUS_APPS")

verificar_tools_paths_nombres=("CARDANO_NODE" "CARDANO_WALLET")
verificar_tools_paths=("$CARDANO_NODE" "$CARDANO_WALLET")

crear_sino_existen_nombres=("CARDANO_NODE_DB_PATH" "CARDANO_WALLET_DB_PATH" "CARDANO_CHAIN_INDEX_CONFIG_PATH" "CARDANO_CHAIN_INDEX_DB_PATH" "CARDANO_PAB_SERVER_CONFIG_PATH" "CARDANO_PAB_DATABASE_PATH")
crear_sino_existen=("$CARDANO_NODE_DB_PATH" "$CARDANO_WALLET_DB_PATH" "$CARDANO_CHAIN_INDEX_CONFIG_PATH" "$CARDANO_CHAIN_INDEX_DB_PATH" "$CARDANO_PAB_SERVER_CONFIG_PATH" "$CARDANO_PAB_DATABASE_PATH")

verificar_tools_files_nombres=("MAIN" "NIX_SHELL" "CARDANO_TOOLS_TOKEN_METADATA_CREATOR")
verificar_tools_files=("$MAIN" "$NIX_SHELL" "$CARDANO_TOOLS_TOKEN_METADATA_CREATOR")

verificar_config_files_nombres=("CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG" "CARDANO_PAB_SERVER_TEMPLATE_CONFIG")
verificar_config_files=("$CARDANO_CHAIN_INDEX_TEMPLATE_CONFIG" "$CARDANO_PAB_SERVER_TEMPLATE_CONFIG")

verificar_config_node_files_nombres=("CARDANO_CONFIG" "CARDANO_TOPOLOGY" "CARDANO_SHELLEY" "CARDANO_BYRON" "CARDANO_ALONZO" "CARDANO_SUBMIT_API_CONFIG" "CARDANO_DBSYNC_CONFIG")
verificar_config_node_files=("$CARDANO_CONFIG" "$CARDANO_TOPOLOGY" "$CARDANO_SHELLEY" "$CARDANO_BYRON" "$CARDANO_ALONZO" "$CARDANO_SUBMIT_API_CONFIG" "$CARDANO_DBSYNC_CONFIG")

verificar_permisos_nombres=("PLUTUS_DEVS_SCRIPTS_FILES" "PLUTUS_DEVS_SCRIPTS_FILES_CONFIG" "CARDANO_NODE_DB_PATH" "CARDANO_WALLET_DB_PATH" "CARDANO_CHAIN_INDEX_CONFIG_PATH" "CARDANO_CHAIN_INDEX_DB_PATH" "CARDANO_PAB_SERVER_CONFIG_PATH" "CARDANO_PAB_DATABASE_PATH")
verificar_permisos=("$PLUTUS_DEVS_SCRIPTS_FILES" "$PLUTUS_DEVS_SCRIPTS_FILES_CONFIG" "$CARDANO_NODE_DB_PATH" "$CARDANO_WALLET_DB_PATH" "$CARDANO_CHAIN_INDEX_CONFIG_PATH" "$CARDANO_CHAIN_INDEX_DB_PATH" "$CARDANO_PAB_SERVER_CONFIG_PATH" "$CARDANO_PAB_DATABASE_PATH")

printf "\n--------\n"
echo "Verificando directorios..."
echo "Si alguno no existe, revisar configuracion de variables env o descarga correcta de repositorios"

for i in ${!verificar_directorios[@]}; do

    if [[ -d "${verificar_directorios[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${verificar_directorios_nombres[$i]}: ${verificar_directorios[$i]}: $existe\n"
done

printf "\n\n--------\n"
echo "Verificando directorios de tools..."
echo "Si alguno no existe, revisar configuracion de variables env o descarga correcta de tools"

for i in ${!verificar_tools_paths[@]}; do

    if [[ -d "${verificar_tools_paths[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${verificar_tools_paths_nombres[$i]}: ${verificar_tools_paths[$i]}: $existe\n"
done

printf "\n\n--------\n"
echo "Verificando directorios de configuración..."
echo "Si alguno no existe, revisar configuracion de variables env o crealos"

for i in ${!crear_sino_existen[@]}; do

    if [[ -d "${crear_sino_existen[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${crear_sino_existen_nombres[$i]}: ${crear_sino_existen[$i]}: $existe\n"

    if [[ $existe = "No" ]];
    then
        printf "\n"
        echo "Desde crear carpeta (y/n)?";
        read -n 1 -s opcion
        if [[ $opcion = "y" ]]; then
            sudo mkdir "${crear_sino_existen[$i]}"
        fi
    fi

done

printf "\n\n--------\n"
echo "Verificando existencia de tools..."
echo "Si alguna no existe, revisar configuracion de variables env o descargar"

for i in ${!verificar_tools_files[@]}; do

    if [[ -f "${verificar_tools_files[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${verificar_tools_files_nombres[$i]}: ${verificar_tools_files[$i]}: $existe\n"
done

printf "\n\n--------\n"
echo "Verificando existencia de archivos de configuración..."
echo "Si alguna no existe, revisar configuracion de variables env o descargar"

for i in ${!verificar_config_files[@]}; do

    if [[ -f "${verificar_config_files[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${verificar_config_files_nombres[$i]}: ${verificar_config_files[$i]}: $existe\n"
done

printf "\n\n--------\n"
echo "Verificando existencia de archivos de configuración de nodo..."
echo "Si alguna no existe, revisar configuracion de variables env o descargar desde: https://book.world.dev.cardano.org/environments.html"

for i in ${!verificar_config_node_files[@]}; do

    if [[ -f "${verificar_config_node_files[$i]}" ]];
    then
        existe="Si"
    else
        existe="No!!!!!!!!!!!"
    fi

    printf "\n${verificar_config_node_files_nombres[$i]}: ${verificar_config_node_files[$i]}: $existe\n"
done

printf "\n\n--------\n"
echo "Corrigiendo permisos de carpetas..."

for i in ${!verificar_permisos[@]}; do

    printf "\n${verificar_permisos_nombres[$i]}: ${verificar_permisos[$i]}\n"

    sudo chown $USER -hR "${verificar_permisos[$i]}"
    sudo find "${verificar_permisos[$i]}" -type d -exec chmod 755 {} \;
done

printf "\n\n"
echo "Hecho!"


echo; read -rsn1 -p "Press any key to continue . . ."; echo