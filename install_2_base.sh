#!/bin/bash

timedatectl set-ntp true
pacman -Syy

## base install
pacman -S reflector
sudo reflector -c Italy -a 12 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware intel-ucode nano git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt