#!/bin/bash

echo "Agregando carperas en safe directories de Git:"

echo " "
echo "Usuario: "$USUARIO

echo " "
CWD=$(pwd)
echo "Carpeta: "$CWD
echo " "


carpeta=$CWD

echo "Desde cambiar de carpeta (y/n)?";
read -n 1 -s opcion
if [[ $opcion = "y" ]]; then
    echo "Ingrese carpeta: "
    carpeta=
    while [[ $carpeta = "" ]]; do
        read carpeta
    done

fi

echo "Arreglando permisos de caperta (solo subcarpetas primer nivel): "$carpeta

find "$carpeta" -maxdepth 1 -type d \( ! -wholename "$carpeta" \) -exec bash -c "echo 'Agregando: {}' && git config --global --add safe.directory {}" \;

#--git config --global --add safe.directory /home/manuelpadilla/source/copyRepos/Falcon-Devs/_OLD/cardano-falcon-stakepol-devs-haskell-v1/dist-newstyle/src/optparse-_-5b3aca9bcb30ab3a

echo "Hecho!"

echo; read -rsn1 -p "Press any key to continue . . ."; echo