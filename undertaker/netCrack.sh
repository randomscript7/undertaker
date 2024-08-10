#!/bin/bash

Header () {
here=$(pwd)
cd /usr/share/undertaker
./header.sh
cd $here
}

Header
echo ""
echo "Welcome to netCrack."
echo "This is a program that will utilize the aircrack-ng suite of tools to excecute a full wifi attack."
echo ""

echo "Are you ready to start the instance (y/n/help)?"
read start
if [ "$start" == "y" ]; then 
    echo "Starting process - phase one."
    sleep 1
    echo "Killing processes to prepare for a monitor-mode interface..."
    echo "WARNING: This will shut down NetworkManager."
    read -p "Press enter to confirm you would like to do this: "
    echo "Confirmed. Proceeding..."
    sudo systemctl stop NetworkManager.service
    sudo systemctl stop wpa_supplicant.service
    echo "Done."
    echo "If you haven't already, plug in your monitor-mode capable wifi adapter."
    read -p "When finished, press enter to confirm: "
    echo "Putting wlan1 into monitor mode..."
    sudo airmon-ng start wlan1
    echo "Done."
    echo "---------"
    echo "Phase one completed."
    echo "---------"
    echo ""

    # Look into hcxdumptool instead of airodump

    read -p "When ready, press enter to start phase two: "
    echo "Starting process - phase two."
    sleep 1
    echo "Airodump-ng will now be used to look for nearby networks on wlan1."
    read -p "Enter any ESSIDs you wish to find: " essid
    set essid 
    echo "---------"
    date=$(date +"%Y-%m-%d")
    sudo airodump-ng --essid $essid -c 11,6,1 --output-format cap --write /usr/share/undertaker/hashFiles/WPA/$date.cap wlan1
    echo "---------"
    read -p "What BSSID would you like to focus the attack on (XX:XX:XX:XX:XX:XX): " bssid
    echo "---------"
    echo "Checking if WPS is enabled on $essid..."
    wash -i wlan1
    echo "If you saw WPS enabled on $essid, confirm it (y/n): " WPSon


elif [ "$start" == "n" ]; then
    echo "Killing process..."
    exit 0
elif [ "$start" == "help" ]; then
    echo "Opening help menu..."
    sleep 1
    clear
    cat /usr/share/undertaker/help/netCrack.txt
else
    echo "That's not a valid input."
fi

#    echo "Shutting down NetworkManager..."
#    sudo systemctl disable NetworkManager
#    echo "Done."
#    echo "Shutting down wpa_supplicant..."
#    sudo systemctl disable wpa_supplicant
#    echo "Done."
#    echo "---------"