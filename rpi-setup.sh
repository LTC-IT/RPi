#!/bin/sh

# ------------------
# UPDATE THESE VARIABLES AS REQUIRED
# List of packages for all architectures (including Raspbian for x86)
PACKAGES_ALL="ntp ntpdate python3-pip vlc gnome-screenshot rpi-chromium-mods python-sense-emu-doc lxterminal graphicsmagick fritzing sqlite3"
PACKAGES_RPI="sense-hat raspberrypi-ui-mods raspberrypi-bootloader python3-sense-emu"
SCRIPTVERSION="2022.3.12"
SCHOOL=LTC
# ------------------

# Defining colours
# from : https://unix.stackexchange.com/questions/92563/friendly-terminal-color-names-in-shell-scripts

red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
yellow='\e[1;33m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'
magenta='\e[1;35m%s\e[0m\n'
cyan='\e[1;36m%s\e[0m\n'

# Examples for printing in colour to the console.
#printf "$green"   "This is a test in green"
#printf "$red"     "This is a test in red"
#printf "$yellow"  "This is a test in yellow"
#printf "$blue"    "This is a test in blue"
#printf "$magenta" "This is a test in magenta"
#printf "$cyan"    "This is a test in cyan"

#system=`arch`
if [ $system = "i686" ] then
	printf "$magenta" "Raspbian on PC/Mac"
elif [ $system = "aarch64" ] then
	printf "$green"   "Raspbian on Raspberry Pi 64bit"
else
	printf "$green"   "Raspbian on Raspberry Pi 32bit"
fi

# Script to set up the Raspberry pi for Programming
printf "$yellow"  "Welcome! This script updates and configures the Raspberry Pi"
printf "$yellow"  "for use in Programming Classes at $SCHOOL"
echo "Version: $SCRIPTVERSION"
echo "Written by Ryan Cather - ryan.cather@ed.act.edu.au"



# Update and clean system

printf "$green"   "Configuring updates..."
printf "$red"     "Do not quit - it is doing something!!"

apt-get -qq update

printf "$magenta" "Seriously - this may take some time....."
apt-get -qq dist-upgrade -y


echo "Installing the additional packages."
printf "$green"   "This may take a while...."

# Install packages

if [ $system = "i686" ]; then
	echo "The following packages will be installed/updated:"
	echo "$PACKAGES_ALL"
	apt -qq -m install $PACKAGES_ALL -y
else
	echo "The following packages will be installed/updated:"
	echo "$PACKAGES_ALL"
	echo "$PACKAGES_RPI"
	apt -qq -m install $PACKAGES_ALL -y
	apt -qq -m install $PACKAGES_RPI -y
fi

echo "Cleaning System"
apt-get -qq autoremove -y
apt-get -qq clean

# Set up the time
echo "Configuring the time for SchoolsNET. Disable if unnecessary."

# put a # in front of the lins below if you're using this outside the school network.
service ntp stop
ntpdate 203.62.5.5
service ntp start

# Installing additonal pip packages
echo "Installing pip packages"

# ------------------
# UPDATE THESE PACKAGES AS REQUIRED
pip3 install --upgrade oauth2client
pip3 install PyOpenSSL
pip3 install gspread
pip3 install flask
# ------------------


# wlan0 & Rpi Camera Configuration

if [ $system = "i686" ]; then
	echo "No Changes needed to wlan0"
	echo "No Changes needed for Pi Camera"
else
	echo "Setting Wifi power management to off"
	iwconfig wlan0 power off
	grep "start_x=1" /boot/config.txt
	if grep "start_x=1" /boot/config.txt
	then
        	echo "No Changes needed for Pi Camera"
	else
        	sed -i "s/start_x=0/start_x=1/g" /boot/config.txt
	fi
fi

# Configure localisation settings

setxkbmap us

printf "$blue"    "All done. Thank you"
printf "$blue"    "Reboot now"


