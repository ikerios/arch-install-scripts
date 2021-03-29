#!/bin/bash

## partitioning, formatting and mounting

parted -s /dev/nvme0n1 mklabel gpt mkpart ESP fat32 1MiB 512MiB set 1 boot on mkpart "swap" linux-swap 512MiB 33GiB mkpart "root" primary 33GiB 100%

mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
