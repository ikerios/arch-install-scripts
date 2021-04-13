# arch-install-scripts

0) cd arch-install-scripts
1) make all script executable # chmod u+x *
2) run install_1_partition_btrfs.sh
3) run install_2_base.sh
4) cp -r /root/arch-install-scripts /mnt/root/
5) arch-chroot /mnt
6) run install_3_main.sh 
7) reboot and login with normal user
8) EDIT and install_4_afterboot.sh
