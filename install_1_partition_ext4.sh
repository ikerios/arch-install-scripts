#!/bin/bash

## partitioning, formatting and mounting

parted -s /dev/nvme0n1 mklabel gpt mkpart ESP fat32 1MiB 513MiB set 1 boot on mkpart "root" primary 513MiB 100%

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
