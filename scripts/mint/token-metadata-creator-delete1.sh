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

$CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry --init $SUBJECT

$CARDANO_TOOLS_TOKEN_METADATA_CREATOR entry $SUBJECT --name "VOID" --description "VOID"

#-----------------------------------------------

echo "Increment the sequenceNumber fields of those properties in file:"

echo $PLUTUS_DEVS_SCRIPTS_FILES/token-metadata/$SUBJECT.json.draft

echo "Again sign and finalize the file with:"

echo "source token-metadata-creator-delete2.sh"

#-----------------------------------------------

cd $CWD
