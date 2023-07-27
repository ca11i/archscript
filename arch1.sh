#!/usr/bin/bash
# My arch install script Part 1 before arch-chroot

# Manually create partitions before running

# Get Boot Device - Enter none if not needed
read -p "Enter boot device name or type none: " dskBoot

# Get Root Device  - Enter none if not needed
read -p "Enter root device name or type none: " dskRoot

# UK Keyboard
loadkeys uk

# Set timezone
timedatectl set-timezone Europe/London

# Format root partition if needed
if [ $dskRoot != "none" ]; then

   echo "Formatting Root device $dskRoot"

   # Format
   mkfs.ext4 $dskRoot

   # Mount Root Partition
   mount $dskRoot /mnt
   
fi

# Boot partition if needed
if [ $dskBoot != "none" ]; then

   echo "Formatting Boot device $dskBoot"
   
   # Format boot partition
   mkfs.fat -F 32 $dskBoot

   # Mount Boot Partition
   mount --mkdir $dskBoot /mnt/boot

fi

# Install Packages
pacstrap -K /mnt base linux linux-firmware nano networkmanager sudo

# Create FSTAB
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot 
arch-chroot /mnt

