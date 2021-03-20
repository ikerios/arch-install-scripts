#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password

## Basic Desktop
sudo pacman -S --noconfirm --needed avahi reflector pipewire pipewire-alsa pipewire-pulse pipewire-jack jack2 xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils bluez bluez-utils cups hplip
sudo systemctl enable bluetooth
sudo systemctl enable avahi-daemon
sudo systemctl enable cups

## uncomment for basic GNOME
sudo pacman -S --noconfirm --needed gnome gnome-extra firefox materia-gtk-theme papirus-icon-theme
sudo systemctl enable gdm

## uncomment for basic KDE
sudo pacman -S --noconfirm --needed plasma-meta kde-applications-meta firefox materia-kde papirus-icon-theme
sudo systemctl enable sddm

## laptop
sudo pacman -S --noconfirm --needed iwd acpi acpi_call tlp acpid
sudo systemctl enable tlp
sudo systemctl enable acpid

## kvm, qemu, libvirt
sudo pacman -S --noconfirm --needed virt-manager qemu qemu-arch-extra bridge-utils vde2 ovmf
sudo usermod -aG libvirt $INST_USER
sudo systemctl enable libvirtd

## add aur helper
git clone https://aur.archlinux.org/pikaur.git
cd pikaur/
makepkg -si --noconfirm

## tuxedo laptop
pikaur -S --noconfirm --needed linux-headers tuxedo-keyboard tuxedo-control-center

## arch-x-icons-theme
pikaur -S --noconfirm --needed arc-x-icons-theme

sudo mkinitcpio -P

/bin/echo -e "\e[1;32mDone!\e[0m"
