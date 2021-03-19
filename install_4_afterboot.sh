#!/bin/bash


## add aur helper
git clone https://aur.archlinux.org/pikaur.git
cd pikaur/
sudo makepkg -si --noconfirm

## tuxedo laptop
pikaur -S --noconfirm --needed linux-headers tuxedo-keyboard tuxedo-control-center

## arch-x-icons-theme
pikaur -S --noconfirm --needed arc-x-icons-theme

mkinitcpio -P

/bin/echo -e "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
