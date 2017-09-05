#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

echo '[[-f ~/.bashrc ]] && source ~/.bashrc' > ~/.profile

cp bashrc ~/.bashrc

VAULT_UUID="$(lsblk -s -d -n -o UUID -I 253)"
echo "VAULT_UUID=$VAULT_UUID" > ~/.vault_uuid

