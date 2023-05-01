#!/usr/bin/env bash
# Usage: direnv-switch <env-name>

# para elegir un nix file de la carpeta y guardarlo en .envrc
# los arhivos de nix de plutus apps los pongo como symblink y funcionan
# .envrc es leido por direnv y nix-direnv

set -euo pipefail

# # Get the current directory of the script
# DIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" >/dev/null 2>&1 && pwd )"
# # Move up one level to the parent folder
# DIR="${DIR}/.."

DIR=$1

# Find all files with .nix extension in the current directory
nix_files=( $(find $DIR -maxdepth 1 -type f -name "*.nix" -o -type l -name "*.nix") )

# Display a numbered list of the files
echo "Select a file to use (folder: $DIR):"
for (( i=1; i<=${#nix_files[@]}; i++ )); do
    echo "$i: ${nix_files[$i-1]}"
done

# Prompt the user to select a file
read -p "Enter the number of the file to use: " selection

# Check that the selection is valid

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection -lt 1 ] || [ $selection -ge $((${#nix_files[@]}+1)) ]; then
    echo "Invalid selection: $selection"
    exit 1
fi

echo "You selected: ${nix_files[$selection-1]}"
# Do something with the selected file here

# take the env as the first argument

echo "Changing environment to ${nix_files[$selection-1]}"

# rm shell.nix
# ln -sn ${nix_files[$selection-1]} shell.nix

# if ! has nix_direnv_version || ! nix_direnv_version 2.3.0; then
#   source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/2.3.0/direnvrc" "sha256-Dmd+j63L84wuzgyjITIfSxSD57Tx7v51DMxVZOsiUD8="
# fi

# create a new .envrc for the user
cat <<NEW_ENVRC > $DIR/.envrc
use nix ${nix_files[$selection-1]}
NEW_ENVRC

# allow the execution

direnv allow $DIR
# direnv allow .
# direnv allow 

# eval "$(direnv export bash)"

# echo "use with: eval \$NIX"

