#!/bin/bash

# default values
INST_USER=xon
INST_PWD=password
INST_LOCALHOST=infinity
INST_LOCALDOMAIN=home
INST_KEYMAP=us
INST_TIMEZONE=Europe/Rome
INST_INSTALLATION_DEVICE=/dev/nvme0n1


ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
#sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=$INST_KEYMAP" > /etc/vconsole.conf
echo "FONT=ter-122b" >> /etc/vconsole.conf
echo "FONT_MAP=8859-2" >> /etc/vconsole.conf
echo $INST_LOCALHOST > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $INST_LOCALHOST.$INST_LOCALDOMAIN $INST_LOCALHOST" >> /etc/hosts
echo root:$INST_PWD | chpasswd

pacman -Syy --noconfirm --needed base-devel bash-completion openssh grub efibootmgr reflector terminus-font networkmanager dosfstools btrfs-progs e2fsprogs

reflector -p https -c Italy -a 4 --save /etc/pacman.d/mirrorlist

systemctl enable NetworkManager
systemctl enable sshd
systemctl enable fstrim.timer

useradd -m $INST_USER
echo $INST_USER:$INST_PWD | chpasswd

echo "$INST_USER ALL=(ALL) ALL" >> /etc/sudoers.d/$INST_USER

BOOT_UUID=$(blkid -s UUID -o value $INST_INSTALLATION_DEVICE\p1)
SWAP_UUID=$(blkid -s UUID -o value $INST_INSTALLATION_DEVICE\p2)
BOOT_UUID=$(blkid -s UUID -o value $INST_INSTALLATION_DEVICE\p3)
ROOT_UUID=$(blkid -s UUID -o value $INST_INSTALLATION_DEVICE\p4)

#enable crypt support for grub
sed -i '/^#GRUB_ENABLE_CRYPTODISK/s/.//' /etc/default/grub

#crypt parameters and resume support for grub
GRUB_LINE_CRYPT=GRUB_CMDLINE_LINUX=\""rd.luks.name=$ROOT_UUID=cryptroot rd.luks.name=$SWAP_UUID=cryptswap rd.luks.name=$BOOT_UUID=cryptboot root=/dev/mapper/cryptroot resume=/dev/mapper/cryptswap\""

#echo $GRUB_LINE_CRYPT
sed -i "/^GRUB_CMDLINE_LINUX=/c$GRUB_LINE_CRYPT" /etc/default/grub

#enable crypt support in mkinitcpio
MKINITCPIO_BINARIES="BINARIES=(btrfs nano)"
MKINITCPIO_HOOKS="HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)"
#echo $MKINITCPIO_BINARIES
#echo $MKINITCPIO_HOOKS

sed -i "/^BINARIES=/c$MKINITCPIO_BINARIES" /etc/mkinitcpio.conf
sed -i "/^HOOKS=/c$MKINITCPIO_HOOKS" /etc/mkinitcpio.conf

mkinitcpio -P

grub-install --recheck --removable --target=x86_64-efi --efi-directory=/efi --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg


/bin/echo -e "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
