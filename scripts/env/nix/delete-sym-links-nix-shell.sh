#!/usr/bin/env bash
set -euo pipefail

CWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo ""
echo "Do you want to do delete Symbolic links for nix-shell in ${CWD}? (y/n)"
read answer

if [[ $answer == [yY] ]]; then
  echo "Deleting Symbolic links for nix-shell"

    find . -name "shell-*.nix" -type l -delete

    echo "Nix symbolic link files deleted!" 
fi

