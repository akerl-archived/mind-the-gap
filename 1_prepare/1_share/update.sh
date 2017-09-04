#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

[[ "$#" != '1' ]] && echo "Usage: $0 BLOCK_DEV" && exit 1

TMP_DIR="$(mktemp -d)"
REPO_HOST='rsync://ru.mirror.archlinuxarm.org/archlinuxarm/armv6h'

mkdir "${TMP_DIR}"/{share,fat}
mount "${BLOCK_DEV}1" "${TMP_DIR}"/share
mount "${BLOCK_DEV}2" "${TMP_DIR}"/fat

mkdir -p "${TMP_DIR}"/share/repo
rsync --progress -avx "${REPO_HOST}" "${TMP_DIR}"/share/repo/

if [[ -d "${TMP_DIR}"/share/config/.git ]] ; then
    (cd "${TMP_DIR}"/share/config && git pull)
else
    git clone git://github.com/akerl/mind-the-gap "${TMP_DIR}"/share/config
fi

umount "${TMP_DIR}"/share "${TMP_DIR}"/fat
