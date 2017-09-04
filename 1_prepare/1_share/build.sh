#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

[[ "$#" != '1' ]] && echo "Usage: $0 BLOCK_DEV" && exit 1

BLOCK_DEV="$1"
echo "Press enter to continue with $BLOCK_DEV"
read

sfdisk "${BLOCK_DEV}" < disk_layout
mkfs.ext4 -F "${BLOCK_DEV}1"
mkfs.vfat "${BLOCK_DEV}2"

./update.sh "${BLOCK_DEV}"
