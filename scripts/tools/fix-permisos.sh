#!/bin/bash

echo "Arreglando permisos:"

echo " "
echo "Usuario: "$USER

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

echo "Arreglando permisos de caperta (subcarpetas y archivos): "$carpeta

sudo chown $USER -hR "$carpeta"
sudo find "$carpeta" -type d -exec chmod 755 {} \;
sudo find "$carpeta" -type f -exec chmod u+w  {} \;
sudo find "$carpeta" -name "*.sh" -type f -exec chmod +x {} \;

echo "Hecho!"


echo; read -rsn1 -p "Press any key to continue . . ."; echo