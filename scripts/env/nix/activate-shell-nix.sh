#!/usr/bin/env bash
set -euo pipefail
echo ""
echo "Executing nix-shell"
echo ""
echo "Checking in plutus-apps directory: $PLUTUS_APPS_ROOT"
# Find all files with .nix extension in the current directory
nix_files=( $(find ${PLUTUS_APPS_ROOT} -maxdepth 2 -mindepth 2 -type f -name "shell.nix" -o -type l -name "shell.nix") )
# Display a numbered list of the files
echo "Select a file:"
for (( i=1; i<=${#nix_files[@]}; i++ )); do
    echo "$i: ${nix_files[$i-1]}"
done
echo "0: Cancel"
# Prompt the user to select a file
read -p "Enter the number of the file: " selection
if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection == 0 ]; then
    exit
fi
# Check that the selection is valid
if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection -lt 1 ] || [ $selection -ge $((${#nix_files[@]}+1)) ]; then
    echo "Invalid selection: $selection"
    exit 1
fi
echo "Shell-nix with ${nix_files[$selection-1]}"
nix-shell ${nix_files[$selection-1]}