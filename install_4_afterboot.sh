#!/bin/bash

## Basic Desktop
# pacman -S --noconfirm --needed avahi reflector pipewire pipewire-alsa pipewire-pulse pipewire-jack jack2 xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils bluez bluez-utils cups hplip
# systemctl enable bluetooth
# systemctl enable avahi-daemon
# systemctl enable cups

## uncomment for basic GNOME
# pacman -S --noconfirm --needed gnome gnome-extra firefox materia-gtk-theme papirus-icon-theme
# systemctl enable gdm

## uncomment for basic KDE
# pacman -S --noconfirm --needed plasma-meta kde-applications-meta firefox materia-kde papirus-icon-theme
# systemctl enable sddm

## laptop
# pacman -S --noconfirm --needed iwd acpi acpi_call tlp acpid
# systemctl enable tlp
# systemctl enable acpid

## kvm, qemu, libvirt
# pacman -S --noconfirm --needed virt-manager qemu qemu-arch-extra bridge-utils vde2 ovmf
# usermod -aG libvirt $INST_USER
# systemctl enable libvirtd

## add aur helper
# git clone https://aur.archlinux.org/pikaur.git
# cd pikaur/
# sudo makepkg -si --noconfirm

## tuxedo laptop
# pikaur -S --noconfirm --needed linux-headers tuxedo-keyboard tuxedo-control-center

## arch-x-icons-theme
# pikaur -S --noconfirm --needed arc-x-icons-theme

mkinitcpio -P

/bin/echo -e "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
