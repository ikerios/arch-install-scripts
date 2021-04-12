#!/bin/bash

## partitioning, formatting and mounting

parted -s /dev/nvme0n1 mklabel gpt mkpart ESP fat32 1MiB 513MiB set 1 boot on mkpart "swap" linux-swap 513MiB 33281MiB mkpart "root" 33281MiB 100%


# swap partition
cryptsetup luksFormat --type luks2 -y -v /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptswap
mkswap /dev/mapper/cryptswap
swapon /dev/mapper/cryptswap

# root partition
cryptsetup luksFormat --type luks2 -y -v /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 cryptroot
mkfs.btrfs /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log
umount /mnt
mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{efi,home,.snapshots,var/log}
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log

# ESP partition
mkfs.fat -F32 /dev/nvme0n1p1
mount /dev/nvme0n1p1 /mnt/efi
