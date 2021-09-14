#!/bin/bash

INST_INSTALLATION_DEVICE=/dev/nvme0n1

## partitioning, formatting and mounting
parted -s $INST_INSTALLATION_DEVICE mklabel gpt mkpart ESP fat12 1MiB 3MiB set 1 boot on  mkpart "swap" linux-swap 3MiB 32771MiB mkpart "boot" 32771MiB 33283MiB mkpart "root" 33283MiB 100%

# swap partition
cryptsetup luksFormat --type luks2 -y -v $INST_INSTALLATION_DEVICE\p2
cryptsetup open $INST_INSTALLATION_DEVICE\p2 cryptswap
mkswap /dev/mapper/cryptswap
swapon /dev/mapper/cryptswap

# root partition
cryptsetup luksFormat --type luks2 -y -v $INST_INSTALLATION_DEVICE\p4
cryptsetup open $INST_INSTALLATION_DEVICE\p4 cryptroot
mkfs.btrfs /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{boot,efi,home,.snapshots,var/log}
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=zstd:9,space_cache=v2,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log

# boot partition
cryptsetup luksFormat --type luks1 -y -v $INST_INSTALLATION_DEVICE\p3
cryptsetup open $INST_INSTALLATION_DEVICE\p3 cryptboot
mkfs.ext4 /dev/mapper/cryptboot
mount $INST_INSTALLATION_DEVICE\p3 /mnt/boot

# ESP partition
mkfs.fat -F12 $INST_INSTALLATION_DEVICE\p1
mount $INST_INSTALLATION_DEVICE\p1 /mnt/efi
