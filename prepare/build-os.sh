#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

[[ "$#" != '1' ]] && echo "Usage: $0 BLOCK_DEV" && exit 1

BLOCK_DEV="$1"
echo "Press enter to continue with $BLOCK_DEV"
read

TMP_DIR="$(mktemp -d)"

OS_HOST='http://os.archlinuxarm.org/os'
OS_URL="${OS_HOST}/ArchLinuxARM-rpi-latest.tar.gz"
OS_FILE="${TMP_DIR}/os.tgz"

curl -sLo "${OS_FILE}" "${OS_URL}"
gpgv --keyring ./archlinuxarm.keyring "${OS_FILE}" || (
    echo 'Bad signature!' && exit 1
)

sfdisk "${BLOCK_DEV}" < disk_layout
mkfs.vfat "${BLOCK_DEV}1"
mkfs.ext4 "${BLOCK_DEV}2"

mkdir "${TMP_DIR}"/{boot,root}
mount "${BLOCK_DEV}1" "${TMP_DIR}"/boot
mount "${BLOCK_DEV}2" "${TMP_DIR}"/root

bsdtar -xpf "${OS_FILE}" -C "${TMP_DIR}"/root
sync
mv "${TMP_DIR}"/root/boot/* "${TMP_DIR}"/boot/



#umount "${TMP_DIR}"/root "${TMP_DIR}"/boot

