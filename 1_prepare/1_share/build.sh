#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

[[ "$#" != '1' ]] && echo "Usage: $0 BLOCK_DEV" && exit 1

BLOCK_DEV="$1"
echo "Press enter to continue with $BLOCK_DEV"
read

TMP_DIR="$(mktemp -d)"

REPO_HOST='rsync://ru.mirror.archlinuxarm.org/archlinuxarm/armv6h'

sfdisk "${BLOCK_DEV}" < disk_layout
mkfs.ext4 -F "${BLOCK_DEV}1"
mkfs.vfat "${BLOCK_DEV}2"

mkdir "${TMP_DIR}"/{repo,fat}
mount "${BLOCK_DEV}1" "${TMP_DIR}"/repo
mount "${BLOCK_DEV}2" "${TMP_DIR}"/fat

rsync --progress -avx "${REPO_HOST}" "${TMP_DIR}"/repo/

git clone git://github.com/akerl/mind-the-gap "${TMP_DIR}"/config

umount "${TMP_DIR}"/repo "${TMP_DIR}"/fat
