#!/bin/bash
#-------------------------------------------------------------------
echo "Welcome to the steamrice automated arch install script"
#------------------Check for bios or uefi---------------------------
if [ -d /sys/firmware/efi ]; then
 	  boot_mode="UEFI"
 	 echo "You have an UEFI boot system"
else 
    boot_mode="BIOS"
   echo "You have a bios boot system"
fi
#------------------CHECK DISKS----------------------------------------
lsblk -l -o NAME,SIZE,MOUNTPOINTS,TYPE
echo "Do you want to format the whole disk?(y/n)"
read inp
inp=${inp,,}
if [[ "${inp,,}" == "y" ]]; then 
	echo "Enter the disk (e.g. sda or vda or nvme0n1):"
	read disk0
	disk0=/dev/$disk0
        mode="auto"
	
else
	echo "If you have predefined partitions"
	echo "Choose a root partition"
	read disk1
	disk1="/dev/$disk1"
	echo "Choose a home partition"
	read disk2
	disk2="/dev/$disk2"
	echo "Choose an "$boot_mode" partition"
	read disk3
	disk3="/dev/$disk3"
	mode="manual"
fi
#----------------------FORMATTING DISKS--------------------------------
echo "BE AWARE the disks/partitions you have chosen will be formatted all data on the disks will be wiped out"
echo "Do you want to continue installing arch? (y/n)"
	read input 
	input="${input,,}"
if [[ "${input,,}" == "y" ]]; then
   	echo "Starting disk formatting for "$boot_mode" boot mode"
else
    	exit 1
fi
if [[ "$mode" == "auto" ]]; then
if [[ "$boot_mode" == "UEFI" ]]; then
  echo "DETECTED UEFI --> using GPT with ESP partition"
	parted -s  "$disk0" mklabel gpt
	parted -s  "$disk0" mkpart ESP fat32 1MiB 513MiB
	parted -s "$disk0" set 1 esp on
	parted -s "$disk0" mkpart primary ext4 513MiB 20GiB
	parted -s "$disk0" mkpart primary ext4 20GiB 100%
       disk3="${disk0}p1" #efi_partition
	disk1="${disk0}p2" #root_partition
	disk2="${disk0}p3" #home_partition 
else 
    echo "DETECTED BIOS --> using MBR layout"
    parted -s "$disk0" mklabel msdos 
    parted -s "$disk0" mkpart primary ext4 1MiB 20GiB
    parted -s "$disk0" mkpart primary ext4 20GiB 100% 
    parted -s "$disk0" set 1 boot on
	 disk3="${disk0}p1" #efi_partition
        disk1="${disk0}p2" #root_partition
        disk2="${disk0}p3" #home_partition
fi

else 
	echo "Formatting chosen partitions....."
	if [[ "$boot_mode" == "UEFI" ]]; then
	mkfs.fat -F32 "$disk3"
fi
 mkfs.ext4 "$disk1"
 mkfs.ext4 "$disk2"
fi

echo "Formatting disks have been succesfully completed. ROOT=$disk1, HOME=$disk2, $boot_mode=$disk3"



