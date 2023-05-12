#!/usr/bin/env bash
set -euo pipefail

# Find all files with .nix extension in the current directory
nix_files=( $(find ${PLUTUS_APPS_ROOT} -maxdepth 2 -mindepth 2 -type f -name "shell.nix" -o -type l -name "shell.nix") )

# Display a numbered list of the files
echo "Select a file to use to log in the nix-shell in your bash shell (folder: ${PLUTUS_APPS_ROOT}):"
for (( i=1; i<=${#nix_files[@]}; i++ )); do
    echo "$i: ${nix_files[$i-1]}"
done
echo "9: Disable direnv"
echo "0: Cancel"

# Prompt the user to select a file
read -p "Enter the number of the file to use: " selection

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection == 9 ]; then
    rm -f .envrc
    exit
fi

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection == 0 ]; then
    exit
fi

# Check that the selection is valid

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection -lt 1 ] || [ $selection -ge $((${#nix_files[@]}+1)) ]; then
    echo "Invalid selection: $selection"
    exit 1
fi

echo "Changing environment to ${nix_files[$selection-1]}"

# create a new .envrc for the user
cat <<NEW_ENVRC > .envrc
use nix ${nix_files[$selection-1]}
NEW_ENVRC

grep -q 'eval "$(direnv export bash)"' ~/.bashrc || echo 'eval "$(direnv export bash)"' >> ~/.bashrc
grep -q 'eval "$(direnv hook bash)"' ~/.bashrc || echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# allow the execution
direnv allow .envrc 

# echo "use with: eval \$NIX"
