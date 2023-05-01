#!/usr/bin/env bash
# Usage: direnv-switch <env-name>
set -euo pipefail

# Find all files with .nix extension in the current directory
nix_files=( $(find ${WORK} -maxdepth 1 -type f -name "*.nix" -o -type l -name "*.nix") )

# Display a numbered list of the files
echo "Select a file to use to log in the nix-shell in your bash shell (folder: ${WORK}):"
for (( i=1; i<=${#nix_files[@]}; i++ )); do
    echo "$i: ${nix_files[$i-1]}"
done
echo "9: Disable direnv"
echo "0: Cancel"

# Prompt the user to select a file
read -p "Enter the number of the file to use: " selection

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection == 9 ]; then
    rm -f ${WORK}/.envrc
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
cat <<NEW_ENVRC > ${WORK}/.envrc
use nix ${nix_files[$selection-1]}
NEW_ENVRC

echo 'eval "$(direnv export bash)"' >> ~/.bashrc

# allow the execution
direnv allow ${WORK}/.envrc 

# echo "use with: eval \$NIX"
