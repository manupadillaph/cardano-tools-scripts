#!/bin/bash

if  [[ $nSubject = "" ]];
then
    printf "Subject: "
    SUBJECT=
    while [[ $SUBJECT = "" ]]; do
        read SUBJECT
    done
fi

if  [[ $nSubject = "" ]];
then
    printf "WalletName: "
    walletName=
    while [[ $walletName = "" ]]; do
        read walletName
    done
fi

addrFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.addr"
skeyFile="$PLUTUS_DEVS_SCRIPTS_FILES/wallets/${walletName}.skey"

echo "Subject is '$SUBJECT'"
echo "walletName is '$walletName'"

CWD=$(pwd)
cd $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata

$CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT -a $skeyFile

$CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT --finalize

echo "Metadata for register in https://github.com/cardano-foundation/cardano-token-registry:"

echo $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata/$SUBJECT.json

cd $CWD