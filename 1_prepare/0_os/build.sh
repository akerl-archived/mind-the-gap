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
OS_SIG_URL="${OS_URL}.sig"
OS_SIG_FILE="${OS_FILE}.sig"

curl -Lo "${OS_FILE}" "${OS_URL}"
curl -Lo "${OS_SIG_FILE}" "${OS_SIG_URL}"
gpgv --keyring ./archlinuxarm.keyring "${OS_SIG_FILE}" "${OS_FILE}" || (
    echo 'Bad signature!' && exit 1
)

sfdisk "${BLOCK_DEV}" < disk_layout
mkfs.vfat "${BLOCK_DEV}1"
mkfs.ext4 -F "${BLOCK_DEV}2"

mkdir "${TMP_DIR}"/{boot,root}
mount "${BLOCK_DEV}1" "${TMP_DIR}"/boot
mount "${BLOCK_DEV}2" "${TMP_DIR}"/root

bsdtar -xpf "${OS_FILE}" -C "${TMP_DIR}"/root
sync "${TMP_DIR}"/root/boot
mv "${TMP_DIR}"/root/boot/* "${TMP_DIR}"/boot/

sed -i 's/^SigLevel.*/SigLevel = Required DatabaseOptional/' "${TMP_DIR}"/root/etc/pacman.conf
echo 'Server = file:///opt/share/repo/armv6h/$repo' > "${TMP_DIR}"/root/etc/pacman.d/mirrorlist
rm "${TMP_DIR}"/root/etc/systemd/system/multi-user.target.wants/haveged.service
mkdir -p "${TMP_DIR}"/root/opt/share
cp ./archlinuxarm.keyring "${TMP_DIR}"/root/root/

umount "${TMP_DIR}"/root "${TMP_DIR}"/boot

