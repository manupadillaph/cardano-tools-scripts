#!/bin/bash

echo "Actualizando ENV en esta sesion ..."

source "$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh"

#antes copiaba todo el contenido de esa lista dentro de .bashrc, pero ahora solo pongo la linea de source

CWD=$(pwd)
cd ~

swPrimero=1

#aqui me encargo de buscar si existe la linea ya y comentarla
while IFS= read -r line
do

    if [[ "$line" == *"# falcon-devs-env"* ]]; then
        if ! [[ "$line" == *"##"* ]]; then

            if [ $swPrimero = 1 ]; then
                echo "## $line">.bashrc.temp
                swPrimero=0
            else
                echo "## $line">>.bashrc.temp
            fi
        else
            if [ $swPrimero = 1 ]; then
                echo $line>.bashrc.temp
                swPrimero=0
            else
                echo $line>>.bashrc.temp
            fi
        fi
    else
         if [ $swPrimero = 1 ]; then
            echo $line>.bashrc.temp
            swPrimero=0
        else
            echo $line>>.bashrc.temp
        fi
    fi

done < .bashrc

#esta es la linea que voy a agregar
lineNew="[ -f \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh\" ] && source \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh\" # falcon-devs-env"

echo $lineNew>>.bashrc.temp

#aqui me encargo de buscar un nombre para guardar la copia de bk
extension=1
base=".bashrc.old"
file="${base}${extension}"

echo "FILE1: $file"

until ! [[ -f "$file"  ]]
do
    extension=$(($extension+1))
    file=${base}${extension}

    echo "FILE2: $file"

done

#aqui reemplazo el original por el temporal creado arriba

cp .bashrc "$file"

cp .bashrc.temp .bashrc

cd $CWD


echo "Para set env en esta sesion ejecute en promt:"
echo "source \"$PLUTUS_DEVS_SCRIPTS/env/write-env-list-mainnet.sh\""
