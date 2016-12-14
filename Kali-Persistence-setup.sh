#!/bin/bash
# This file is a personal bash post install script for a USB flash drive with Kali linux.

# a useful guide - http://null-byte.wonderhowto.com/how-to/install-kali-live-usb-drive-with-persistence-optional-0162253/

#how to Install Kali to a USB with persistence - WINDOWS
#use MiniTool Partition Wizard Free to delete the USB partition and creat 2 new ones

#MiniTool Partition Wizard Free - https://www.partitionwizard.com/download.html

#delete everything on the USB
#Create a partition with over 10g of space as FAT23 and PRIMARY (Still room for other distros)
#Create another partition with the remainder of the space as a EXT4 and PRIMARY named: persistence
#the persistence partition is where everything will be saved so this partition should be around or larger than 10g

#Have Kali Linux ISO downloaded - https://www.kali.org/downloads/	(Use a Torrent for faster DL)
#Have YUMI multi boot installer - https://www.pendrivelinux.com/yumi-multiboot-usb-creator/

#use YUMI to install Kali to the USB


# Check if the script was run in root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#Edit the Kali boot loader for quicker startups
KALIBOOTFILE="/lib/live/mount/persistence/sdb1/multiboot/kali-linux-2016.2-amd64/isolinux/live.cfg"
KALIBOOTCK=$(sed -n '3p' $KALIBOOTFILE |grep -c default)

echo "Checking Kali Bootscreen File" ;

if [[ $KALIBOOTCK -ne 0 ]] ; then
	#Delete menu default
	sed -i '3d' $KALIBOOTFILE ;
	sleep 1 ;
	#Add default to persistence
	sed -i '/Live USB Persistence/a \
    menu default ' $KALIBOOTFILE ;  #this needs to be on a new line
fi ;

#Edit the YUMI boot loader for quicker startups
YUMIBOOTFILE="/lib/live/mount/persistence/sdb1/multiboot/syslinux.cfg"
echo "Checking YUMI Bootscreen File" ;
sleep 1
if [[ -r $YUMIBOOTFILE ]] ; then

	#Delete everything below line 19 to 50
	sed -i '19,50d' $YUMIBOOTFILE
	sleep 1
	#Put the edited info in the file

cat <<EOT >> $YUMIBOOTFILE


LABEL Boot from first Hard Drive
MENU LABEL Continue to Boot from ^First HD
KERNEL chain.c32
APPEND hd1

#start kali-linux-2016.2-amd64
LABEL kali-linux-2016.2-amd64
MENU LABEL kali-linux-2016.2-amd64
CONFIG /multiboot/kali-linux-2016.2-amd64/isolinux/isolinux.cfg
APPEND /multiboot/kali-linux-2016.2-amd64/isolinux
#end kali-linux-2016.2-amd64
MENU DEFAULT
EOT

	sleep 1

else
	echo $YUMIBOOTFILE " - NOT FOUND! try mounting it again"
	sleep 1
	tree /mnt/MYUSB/

fi



#Checking Persistence
mkdir -p /mnt/MYUSB/
mount /dev/sdb2 /mnt/MYUSB
sleep 1

#Persistence VARS
PERSISTENCECK="/mnt/MYUSB/persistence.conf"
PERSISTENCECKINFO=$( awk '/union/ { print $2 } ' $PERSISTENCECK )
PERSISTENCEINFO="union"

#IF the file exist and has info in it && file has the correct union info inside then move on else install persistence
echo "Checking Persistence"
if [[ -r $PERSISTENCECK ]] && [[ $PERSISTENCECKINFO -eq $PERSISTENCEINFO ]] ;
then

	cat /mnt/MYUSB/persistence.conf

	echo "File exists and has the correct info..." ;
	echo "Persistence files are good."
	umount /dev/sdb2 ;
else
	echo "Fresh Kali install - Setting up Persistence" ;

	echo "Adding persistence.conf file" ;
	echo "/ union" > /mnt/MYUSB/persistence.conf ;
	sleep 1 ;
	echo "Cat out persistence.conf to confirm we have the correct info" ;

	cat /mnt/MYUSB/persistence.conf ;
	sleep 1 ;

	echo "Un-mounting drive" ;
	umount /dev/sdb2 ;
	echo "The Persistence drive for Kali is setup and you are ready for reboot" ;
	echo "press ENTER to reboot or CLT-c to exit without reboot" ;

	read ;
	systemctl reboot ;
fi



#EDIT the repositories for faster downloads
REPOFILE="/etc/apt/sources.list"
REPOCK=$(grep repo $REPOFILE | wc -l )

echo "Checking REPOs List"

if [[ $REPOCK -eq 2 ]] ; then
	echo "Repos have the correct info" ;
else
	echo "Editing the Repo file" ;
	#change the HTTP to REPO in the address for faster repo downloads ;
	echo "deb http://repo.kali.org/kali kali-rolling main contrib non-free" > $REPOFILE ;
	echo "deb-src http://repo.kali.org/kali kali-rolling main contrib non-free" >> $REPOFILE ;
fi ;

# Add eth0 and wlan0 to interfaces for autostart
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet dhcp
iface default inet dhcp
EOF

# Network Manager needs to manage the networks now that you added them to the interfaces file
# Set Network Manager management to true
sed -i ' s/managed=false/managed=true/ ' /etc/NetworkManager/NetworkManager.conf
service network-manager restart

# Enable the auto Macchanger
sed -i ' s/ENABLE_ON_POST_UP_DOWN=false/ENABLE_ON_POST_UP_DOWN=true/ ' /etc/default/macchanger

echo "Change the root password"
passwd


echo "Add these usefull extensions (Loading Firefox... *Accept page shell on load)"
start firefox --new-tab https://extensions.gnome.org/extension/1031/topicons/
firefox --new-tab https://extensions.gnome.org/extension/72/recent-items/
firefox --new-tab https://extensions.gnome.org/extension/779/clipboard-indicator/


#install programs
echo "Ready to install apt-get update and install programs?" ;
echo "This may take a long time and/or need your input. Hit ENTER to continue" ;
read

apt-get clean && apt-get -y update && apt-get -y dist-upgrade
sleep 1
apt-get clean && apt -y autoremove
apt-get -y install tree bettercap
gem install bettercap
gem update bettercap
#Install rmagick for bettercap modules
apt-get install libmagickwand-dev build-essential ruby-dev libpcap-dev
gem install rmagick
cd /root/Desktop
#https://github.com/evilsocket/bettercap-proxy-modules
git clone https://github.com/evilsocket/bettercap-proxy-modules.git



