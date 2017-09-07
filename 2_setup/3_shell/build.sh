#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

echo '[[ -f ~/.bashrc ]] && source ~/.bashrc' > ~/.profile

cp bashrc ~/.bashrc

VAULT_UUID="$(lsblk -f | awk '/crypto_LUKS/ { print $3 }')"
echo "export VAULT_UUID=$VAULT_UUID" > ~/.vault_uuid

echo "Enter the root password"
passwd
