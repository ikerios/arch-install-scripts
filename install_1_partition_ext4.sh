#!/bin/bash

## partitioning, formatting and mounting

parted /dev/nvme0n1 mklabel gpt mkpart ESP fat32 1MiB 512MiB set 1 boot on mkpart primary ext4 512MiB 100%

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
