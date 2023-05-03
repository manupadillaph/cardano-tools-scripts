#!/bin/bash

$CARDANO_NODE/cardano-cli \
	query tip --$NETWORK_WITH_MAGIC
