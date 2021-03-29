#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
#sed -i '177s/.//' /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo "FONT=ter-122b" >> /etc/vconsole.conf
echo "FONT_MAP=8859-2" >> /etc/vconsole.conf
echo "infinity" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 infinity.home infinity" >> /etc/hosts
echo root:$INST_PWD | chpasswd

pacman -Syy --noconfirm --needed base-devel bash-completion openssh grub efibootmgr reflector flatpak terminus-font networkmanager dosfstools btrfs-progs e2fsprogs

reflector -c Italy -a 1 --save /etc/pacman.d/mirrorlist

grub-install --recheck --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable sshd
systemctl enable fstrim.timer

useradd -m $INST_USER
echo $INST_USER:$INST_PWD | chpasswd

echo "$INST_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$INST_USER

echo "run_hook ()
{
    cryptsetup open /dev/nvme0n1p2 swapDevice
}" >> /etc/initcpio/hooks/openswap


/bin/echo -e "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
