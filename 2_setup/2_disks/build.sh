#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

# Share and FAT drive

SHARE_PART="$(findmnt -n /opt/share -o SOURCE)"
SHARE_DEV="${SHARE_PART:0:(-1)}"
FAT_PART="${SHARE_DEV}2"
SHARE_NAME="${SHARE_DEV##*/}"

mkdir -p /opt/fat

echo "${SHARE_PART} /opt/share ext4 nosuid,nodev,rw 0 0" >> /etc/fstab
echo "${FAT_PART} /opt/fat vfat nosuid,nodev,noexec,rw 0 0" >> /etc/fstab


# Vault drive

VAULT_NAME="$(lsblk -d --include 8 -n -o NAME | grep -v "${SHARE_NAME}" | head -1)"
VAULT_DEV="/dev/${VAULT_NAME}"
VAULT_PART="${VAULT_DEV}1"

sfdisk "${VAULT_DEV}" < disk_layout

echo -n "Enter your LUKS passphrase: "
stty_orig="$(stty -g)"
stty -echo
read LUKS_PW
stty "$stty_orig"
echo -n "Enter it again: "
stty_orig="$(stty -g)"
stty -echo
read LUKS_PW2
stty "$stty_orig"

if [[ "$LUKS_PW" != "$LUKS_PW2" ]] ; then
    echo "Passphrase mismatch"
    exit 1
fi
echo -n "$LUKS_PW" | cryptsetup luksFormat --hash sha512 --key-size 512 "${VAULT_PART}" -
echo -n "$LUKS_PW" | cryptsetup luksOpen "${VAULT_PART}" vault
mkfs.ext4 /dev/mapper/vault
mkdir -p /opt/vault

echo "/dev/mapper/vault /opt/vault ext4 nosuid,nodev,noexec,noauto,rw 0 0" >> /etc/fstab

# GNUPGHOME device

mkdir -p /opt/gnupg
echo "tmpfs /opt/gnupg tmpfs rw,nosuid,noexec,nodev,size=32M,mode=0700 0 0" >> /etc/fstab

# Mount all the default drives

mount -a

