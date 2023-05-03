#!/usr/bin/env bash
# Usage: direnv-switch <env-name>
set -euo pipefail

# # Get the current directory of the script
# DIR="$( cd "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" >/dev/null 2>&1 && pwd )"
# # Move up one level to the parent folder
# DIR="${DIR}/.."

# Find all files with .nix extension in the current directory
nix_files=( $(find ${WORK} -maxdepth 1 -type f -name "*.nix" -o -type l -name "*.nix") )

# Display a numbered list of the files
echo "Select a file to use for nix-shell (folder: ${WORK}):"
for (( i=1; i<=${#nix_files[@]}; i++ )); do
    echo "$i: ${nix_files[$i-1]}"
done
echo "0: Cancel"

# Prompt the user to select a file
read -p "Enter the number of the file to use: " selection

if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection == 0 ]; then
    exit
fi

# Check that the selection is valid
if ! [[ $selection =~ ^[0-9]+$ ]] || [ $selection -lt 1 ] || [ $selection -ge $((${#nix_files[@]}+1)) ]; then
    echo "Invalid selection: $selection"
    exit 1
fi

echo "shell-nix with ${nix_files[$selection-1]}"

nix-shell ${nix_files[$selection-1]}