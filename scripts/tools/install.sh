#!/bin/bash

echo "Instalando herramientas linux necesarias:"

echo "Actualizando apt..."
echo ""

sudo apt update

echo ""
echo "Instalando jq..."
echo ""

sudo apt-get install jq

echo ""
echo "Instalando yq..."
echo ""

#sudo add-apt-repository ppa:rmescandon/yq
#sudo apt install yq -y
sudo wget https://github.com/mikefarah/yq/releases/download/v4.27.3/yq_linux_amd64 -O /usr/bin/yq 
chmod +x /usr/bin/yq

echo ""
echo; read -rsn1 -p "Press any key to continue . . ."; echo