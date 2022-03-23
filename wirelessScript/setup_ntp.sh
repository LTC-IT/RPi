#!/bin/bash

echo "Setting up NTP for EDU environment..."

if [ "$EUID" -ne 0 ]; then
  echo "Script must be run as root. Exiting..."
  exit 1
fi

hash ntpdate 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Installing ntpdate..."
  apt-get -y install ntpdate
fi

systemctl is-active ntp.service &>/dev/null
if [ $? -eq 0 ]; then
  echo "Stopping ntp service..."
  systemctl stop ntp.service
fi

echo "Setting Australia/Canberra timezone..."
cp /usr/share/zoneinfo/Australia/Canberra /etc/localtime

echo "Syncing time to 203.62.5.5"
ntpdate 203.62.5.5

echo "Updating ntp config to use 203.62.5.5"
sed -i '/^server/d' /etc/ntp.conf
echo "server 203.62.5.5" >> /etc/ntp.conf

systemctl is-active ntp.service &>/dev/null
if [ $? -ne 0 ]; then
  echo "Starting ntp service..."
  systemctl start ntp.service
fi