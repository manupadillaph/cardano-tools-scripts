#!/bin/bash


printf "\nIniciando Trace Emulator:\n"

echo " "

#Para poder ejecutar el cabal exec necesito estar en la carpeta $PLUTUS_DEVS_HASKELL donde hice el cabal build
CWD=$(pwd)
cd $PLUTUS_DEVS_HASKELL

cabal exec -- trace-emulator

cd $CWD



