#!/bin/bash

#Update and upgrade packages, then remove unnecessary ones. Nice and simple.
echo ""
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
echo "Upgrading any unupgraded packages...."
echo "----------------------"
sudo apt upgrade --fix-missing
echo "----------------------"
echo "Any missed packages were upgraded."
echo "Upgrade process complete."
echo "----------------------"
echo "The update process has finsihed successfully."
echo ""
exit 0
