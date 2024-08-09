#!/bin/bash
clear
cat /usr/share/undertaker/logo.txt
echo ""
echo "Running undertaker - UpdateProcedure"
echo "------------------------------------"
echo "Starting update procedure."
echo "Updating applicable packages..."
echo "----------------------"
sudo apt update
echo "----------------------"
echo "Packages updated."
echo "Upgrading applicable packages..."
echo "----------------------"
sudo apt upgrade -y
echo "----------------------"
echo "Packages upgraded."
echo "Removing unnessecary packages..."
echo "----------------------"
sudo apt autoremove -y
echo "----------------------"
echo "Old packages removed."
echo "Upgrade process complete."
echo "----------------------"
echo "The update process has finsihed successfully."
echo ""
exit 0
