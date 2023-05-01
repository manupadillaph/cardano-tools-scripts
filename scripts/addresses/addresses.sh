#!/bin/bash

if [ -z "$1" ]; then
    echo "File name:"
    read file
else
  file=$1
fi

if [ -z "$2" ]; then
    echo "Name:"
    read name
else
  name=$2
fi

if [ -z "$3" ]; then
    echo "Passphrase (10 or more characters):"
    read passphrase
else
  passphrase=$3
fi

echo "Creating Wallet with name $name passphrase $passphrase in $file.json"

phrase=$($CARDANO_WALLET/cardano-wallet recovery-phrase generate)

x=''
sep=''
for word in $phrase
do
    x=$x$sep'"'$word'"'
    sep=', '
done

cat > $file.json <<- EOM
{ "name": "$name"
, "mnemonic_sentence": [$x]
, "passphrase": "$passphrase"
}
EOM

echo "Saved restoration file to $file.json"

echo $phrase | $CARDANO_WALLET/cardano-wallet key from-recovery-phrase Shelley > $file.root.prv

cat $file.root.prv | $CARDANO_WALLET/cardano-wallet key walletid > $file.id

wallet_Id=$(cat $file.id)

echo "Wallet ID:" $wallet_Id

curl -H "content-type: application/json" -XPOST \
  -d @$file.json \
  localhost:$CARDANO_WALLET_PORT/v2/wallets

echo ""

addresses=$(curl -H "content-type: application/json" \
      -XGET localhost:$CARDANO_WALLET_PORT/v2/wallets/$wallet_Id/addresses | jq -r '.[]' )

echo $addresses| jq -r '.id' >$file.addrs

echo "Wallet Addresses:"

echo $addresses| jq -r '.id' | nl 

address=$(echo $addresses| jq -r '.id'| sed -n 1p)

echo ""

echo "Firts Address:" $address

echo $address> $file.addr

echo "UTxOs At Address:"

$CARDANO_NODE/cardano-cli query utxo --address $address --$NETWORK_WITH_MAGIC 
