#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password

## Basic Desktop
sudo pacman -S --noconfirm --needed avahi reflector pipewire pipewire-alsa pipewire-pulse pipewire-jack jack2 xdg-user-dirs xdg-utils bluez bluez-utils cups hplip networkmanager iwd
sudo systemctl enable bluetooth
sudo systemctl enable avahi-daemon
sudo systemctl enable cups

## uncomment for basic GNOME
sudo pacman -S --noconfirm --needed gnome gnome-extra firefox papirus-icon-theme
sudo systemctl enable gdm

## uncomment for basic KDE
#sudo pacman -S --noconfirm --needed plasma-meta kde-applications-meta firefox materia-kde kvantum-theme-materia papirus-icon-theme
#sudo systemctl enable sddm

## laptop
sudo pacman -S --noconfirm --needed tlp
sudo systemctl enable tlp

## kvm, qemu, libvirt
sudo pacman -S --noconfirm --needed libvirt qemu bridge-utils iptables-nft vde2 ovmf virt-manager
sudo usermod -aG libvirt $INST_USER
sudo systemctl enable libvirtd

## add aur helper
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin/
makepkg -si --noconfirm

## system 76 stuff for coreboot
paru -S --noconfirm --needed linux-headers system76-acpi-dkms

## snapper
paru -S --noconfirm --needed snapper snapper-gui-git

## Pop OS like gnome
paru -S --noconfirm --needed pop-theme system76-wallpapers gnome-control-center-system76 gnome-shell-extension-dash-to-dock-gnome40-git gnome-shell-extension-system76-power-git gnome-shell-extension-pop-shell-git gnome-terminal-transparency

sudo mkinitcpio -P

/bin/echo -e "\e[1;32mDone! Ready to reboot\e[0m"
