#!/bin/bash

timedatectl set-ntp true

## base install
pacstrap /mnt base linux linux-firmware intel-ucode nano git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt