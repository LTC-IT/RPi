#!/bin/sh
OS=""
system=`arch`
if [ $system = "i686" ]; then
	echo Raspbian on PC/Mac
else
	echo Raspbian on Raspberry Pi
fi

# ------------------
# UPDATE THESE VARIABLES AS REQUIRED
# List of packages for all architectures (including Raspbian for x86)
PACKAGES="pi-greeter sense-hat raspberrypi-ui-mods raspberrypi-artwork raspberrypi-bootloader pix-icons pix-plym-splash rpd-wallpaper rpi-chromium-mods python-sense-emu python3-sense-emu python-sense-emu-doc python3-pip"
PACKAGES2="lxterminal graphicsmagick fritzing gnome-screenshot mu mono-complete dia-gnome qt4-dev-tools qtcreator python3-pyqt4 qt4-designer vlc python3-pip leafpad lxterminal python-picamera scratch2 python3-thonny"
SCRIPTVERSION="1.5"
SCHOOL=LTC
# ------------------

# Script to set up the Raspberry pi for Programming
echo "Welcome!"
echo "This script updates and configures the Raspberry Pi for use in Programming Classes at $SCHOOL"
echo "Version: $SCRIPTVERSION"
echo "Written by Ryan Cather - ryan.cather@ed.act.edu.au"

# Update and clean system

echo "Installing updates and cleaning system."
echo "Do not quit - it is doing something!!"
apt-get -qq update
echo "Seriously - this may take some time....."
apt-get -qq dist-upgrade -y
apt-get -qq autoremove -y
apt-get -qq clean

echo "Installing additional packages. This may take a while...."

# Install packages

apt-get -qq install $PACKAGES -y
apt-get -qq install $PACKAGES2 -y

# Installing additonal pip packages
echo "Installing pip packages"

# ------------------
# UPDATE THESE PACKAGES AS REQUIRED
pip3 install --upgrade oauth2client
pip3 install PyOpenSSL
pip3 install gspread
# ------------------

# Configuration
echo "Setting Wifi power management to off"
iwconfig wlan0 power off

setxkbmap us

echo "All done. Thank you"
echo "Reboot now"
