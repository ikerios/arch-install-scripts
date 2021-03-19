#!/bin/bash

# default values
INST_USER=xon

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
#sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
sed -i '177s/.//' /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "infinity" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 infinity.home infinity" >> /etc/hosts
echo root:password | chpasswd

pacman -Syy
pacman -S --noconfirm --needed base-devel bash-completion openssh grub efibootmgr reflector flatpak terminus-font firewalld dosfstools btrfs-progs e2fsprogs

reflector -c Italy -a 12 --sort rate --save /etc/pacman.d/mirrorlist

grub-install --recheck--target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable sshd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld

firewall-cmd --add-port=1025-65535/tcp --permanent
firewall-cmd --add-port=1025-65535/udp --permanent
firewall-cmd --reload

useradd -m $INST_USER
echo $INST_USER:password | chpasswd

echo "$INST_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$INST_USER

## Network manager
systemctl disable systemd-networkd.service
systemctl disable systemd-resolved.service
pacman -S --noconfirm --needed networkmanager network-manager-applet
systemctl enable NetworkManager

## Basic Desktop
# pacman -S --noconfirm --needed avahi reflector pipewire pipewire-alsa pipewire-pulse pipewire-jack xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils bluez bluez-utils cups hplip
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
pacman -S --noconfirm --needed iwd acpi acpi_call tlp acpid
systemctl enable tlp
systemctl enable acpid

## kvm, qemu, libvirt
pacman -S --noconfirm --needed virt-manager qemu qemu-arch-extra bridge-utils vde2 ovmf
usermod -aG libvirt $INST_USER
systemctl enable libvirtd

mkinitcpio -P

/bin/echo -e "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
