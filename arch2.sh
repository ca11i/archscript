#!/usr/bin/bash

# Part 2 after arch-chroot 

# Add some more packages
pacman -S dosfstools e2fsprogs sof-firmware man-db man-pages texinfo

# TimeZone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock –systohc

# Locale
nano /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk " >> /etc/vconsole.conf

# Get hostname
read -p "Enter your hostname: " hstName
echo $hstName >> /etc/hostname

# Root Password
echo "Enter new root password"
passwd

# Do we need GRUB installed?
read -p "Do you want GRUB boot loader (yes/no): " grbInstall

# Check if we want GRUB
if [ $grbInstall = "yes" ]; then

   # Install them
   pacman -S grub efibootmgr
   grub-install --target=x86_64-efi --efi-directory=/boot –bootloader-id=GRUB
   
   # Populate boot loader
   grub-mkconfig -o /boot/grub/grub.cfg
   
fi

# Create a user
read -p "Do you want to create a user (yes/no): " usrCreate

# Create user if needed
if [ $usrCreate = "yes" ]; then

   read -p "Enter the user name: " usrName
   
   useradd -m $usrName
   
   echo "Enter password for $usrName"
   passwd $usrName
   
   # Enable sudo
   echo "$usrName ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/01_$usrName
   
fi

# Enable NetworkManager service
systemctl enable NetworkManager.service
