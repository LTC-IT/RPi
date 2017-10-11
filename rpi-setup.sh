#!/bin/sh

# ------------------
# UPDATE THESE VARIABLES AS REQUIRED
# List of packages for all architectures (including Raspbian for x86)
PACKAGES_ALL="ntp ntpdate python3-thonny scratch2 lxterminal leafpad python3-pip vlc qt4-designer python3-pyqt4 libjasper1 qt4-dev-tools dia-gnome mono-complete mu gnome-screenshot pix-icons pix-plym-splash rpd-wallpaper rpi-chromium-mods python-sense-emu-doc python3-pip lxterminal graphicsmagick fritzing qtcreator"
PACKAGES_RPI="pi-greeter sense-hat raspberrypi-ui-mods raspberrypi-artwork raspberrypi-bootloader python-sense-emu python3-sense-emu python-picamera"
SCRIPTVERSION="2.0"
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

system=`arch`
if [ $system = "i686" ]; then
	printf "$magenta" "Raspbian on PC/Mac"
else
	printf "$green"   "Raspbian on Raspberry Pi"
fi

# Script to set up the Raspberry pi for Programming
printf "$yellow"  "Welcome! This script updates and configures the Raspberry Pi"
printf "$yellow"  "for use in Programming Classes at $SCHOOL"
echo "Version: $SCRIPTVERSION"
echo "Written by Ryan Cather - ryan.cather@ed.act.edu.au"

# Update and clean system

printf "$green"   "Installing updates and cleaning system."
printf "$red"     "Do not quit - it is doing something!!"

apt-get -qq update

printf "$magenta" "Seriously - this may take some time....."
apt-get -qq dist-upgrade -y
apt-get -qq autoremove -y
apt-get -qq clean

echo "Installing the additional packages."
printf "$green"   "This may take a while...."

# Install packages

if [ $system = "i686" ]; then
	echo "The following packages will be installed:"
	echo "$PACKAGES_ALL"
	apt-get -qq install $PACKAGES_ALL -y
else
	echo "The following packages will be installed:"
	echo "$PACKAGES_ALL"
	echo "$PACKAGES_RPI"
	apt-get -qq install $PACKAGES_ALL -y
	apt-get -qq install $PACKAGES_RPI -y
fi

# Set up the time
echo "Configuring the time for SchoolsNET"

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
# ------------------

# wlan0 Configuration

if [ $system = "i686" ]; then
	echo "No Changes needed to wlan0"
else
	echo "Setting Wifi power management to off"
	iwconfig wlan0 power off
fi

# Configure localisation settings

setxkbmap us

printf "$blue"    "All done. Thank you"
printf "$blue"    "Reboot now"
