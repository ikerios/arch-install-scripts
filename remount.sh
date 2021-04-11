#!/bin/bash

cryptsetup open /dev/nvme0n1p2 cryptroot
mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
mount /dev/nvme0n1p1 /mnt/efi


#grub-install --recheck --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch
#grub-mkconfig -o /boot/grub/grub.cfg
