#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "Setting up pi for wireless 802.1x authentication..."

if [ "$EUID" -ne 0 ]; then
  echo "Script must be run as root. Exiting..."
  exit 1
fi

pithinksnow=$(date +%s)
minimumcertvalid=$(date -d 2017-01-01 +%s)
if ! [[ $pithinksnow -ge $minimumcertvalid ]]; then
  echo "Setting date/time so that wpa_supplicant knows the cert is valid."
  date -s @$minimumcertvalid
fi

echo -n "What is the email address for the ACTEDU account you wish to authenticate as? "
read USER

prompt="What is the password for $USER? (THIS WILL BE STORED IN PLAIN TEXT ON THE DEVICE!!!) "
while IFS= read -p "$prompt" -r -s -n 1 char
do
  if [[ $char == $'\0' ]]; then
    break
  fi
  prompt='*'
  PASS+="$char"
done

#echo
#echo "Copying CA certificate to device..."
#if [ ! -f /usr/local/share/ca-certificates/secure.ed.act.edu.au-ca-2017.cer ];
#then
#  cp $DIR/secure.ed.act.edu.au-ca-2017.cer /usr/local/share/ca-certificates/
#fi

echo "Writing new config..."
cat > /etc/wpa_supplicant/wpa_supplicant.conf << END
# 802.1x config for SchoolsNET wireless network
# v2.1 provided by NCS
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=root
network={
  ssid="ONE"
  proto=RSN
  key_mgmt=WPA-EAP
  pairwise=CCMP
  group=CCMP
  eap=PEAP
  identity="$USER"
  password="$PASS"
  altsubject_match="DNS:one.act.gov.au"
  phase1="peaplabel=0"
  phase2="auth=MSCHAPV2"
}
END


echo "Adding to rc.local (start-up)..."
awk '/exit/{print "/sbin/wpa_supplicant -s -B -P /run/wpa_supplicant.wlan0.pid -i wlan0 -D wext -c /etc/wpa_supplicant/wpa_supplicant-wlan0.conf"}1' /etc/rc.local > /etc/rc.local.tmp && mv /etc/rc.local.tmp /etc/rc.local
chmod +x /etc/rc.local 

echo "Connecting to wireless network..."
killall wpa_supplicant
sleep 3
/sbin/wpa_supplicant -s -B -P /run/wpa_supplicant.wlan0.pid -i wlan0 -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf
echo "Waiting for network..."
while [ 1 ]; do
  if [ $(ip addr show dev wlan0 | grep inet | wc -l) -ne 0 ]; then
    break;
  fi
  sleep 1
done
sleep 5
ip=$(ip addr show dev wlan0 | grep inet | head -1 | awk '{print $2}')
echo "Got IP address $ip"
bash ./setup_ntp.sh

#echo "Device setup to connect to ssid EDU on boot"
#read -n 1 -s -p "Press any key to reboot..."
#shutdown -r now
