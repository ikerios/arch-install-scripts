#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password

## Basic Desktop
sudo pacman -S --noconfirm --needed avahi reflector pipewire pipewire-alsa pipewire-pulse pipewire-jack jack2 xdg-user-dirs xdg-utils bluez bluez-utils cups hplip
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
sudo pacman -S --noconfirm --needed libvirt qemu bridge-utils vde2 ovmf virt-manager
sudo usermod -aG libvirt $INST_USER
sudo systemctl enable libvirtd

## add aur helper
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin/
makepkg -si --noconfirm

## tuxedo laptop
paru -S --noconfirm --needed linux-headers tuxedo-keyboard tuxedo-control-center

## system 76 stuff for clevo laptops
#paru -S --noconfirm --needed system76-acpi-dkms system76-dkms system76-driver system76-firmware system76-firmware-daemon system76-io-dkms system76-power

## arch-x-icons-theme
#paru -S --noconfirm --needed arc-x-icons-theme

## snapper
paru -S --noconfirm --needed snapper snap-pac-grub snapper-gui-git

## Plymouth
paru -S --noconfirm --needed plymouth gdm-plymouth tuxedo-plymouth-one

## Pop OS like gnome
#paru -S --noconfirm --needed pop-theme system76-power system76-wallpapers gnome-control-center-system76 gnome-shell-extension-dash-to-dock gnome-shell-extension-dash-to-panel gnome-shell-extension-pop-shell gnome-terminal-transparency

sudo mkinitcpio -P

/bin/echo -e "\e[1;32mDone!\e[0m"
