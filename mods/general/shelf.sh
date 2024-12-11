#!/bin/bash

# Opens menu to introduce script
Header () {
	clear
	echo -e "----------------------------------------------------"
	echo -e "                 _           _        _             "
	echo -e " _   _ _ __   __| | ___ _ __| |_ __ _| | _____ _ __ "
	echo -e "| | | | '_ \ / _\` |/ _ \ '__| __/ _\` | |/ / _ \ '__|"
	echo -e "| |_| | | | | (_| |  __/ |  | || (_| |   <  __/ |   "
	echo -e " \__,_|_| |_|\__,_|\___|_|   \__\__,_|_|\_\___|_|   "
	echo -e "----------------------------------------------------"
	echo -e "A script networking tool written by randomscript7   "
	echo -e "----------------------------------------------------"
}

#This is a script that backs up/extracts the undertaker directory and notes file.

Header
echo ""
echo "Running shelf..."
echo "-----------------------------"
read -p "Would you like to backup your selected files or extract a backup? (backup/extract): " op

if [ "$op" == "backup" ]; then 

    read -p "Would you like to include uncompressed files in your backup? (y/n): " yesno
    
    if [ "$yesno" == "y" ]; then
        echo "Creating backup folder..."
        date=$(date +"%Y-%m-%d")
        mkdir ~/backups/$date
        mkdir ~/backups/$date/raw
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ ~/backups/$date/raw
        sudo cp ~/Desktop/notes.txt ~/backups/$date/raw
        echo "-----------------------------"
        echo Creating archive via tar...
        cd ~/backups/$date
        tar -czf $date.tar.gz ~/backups/$date/raw
        cd ~
        echo "-----------------------------"
        echo "Files copied successfully."
        echo "Backup for $date has been created."
    
    elif [ "$yesno" == "n" ]; then
        echo "Creating backup folder..."
        date=$(date +"%Y-%m-%d")
        mkdir ~/backups/$date
        mkdir ~/backups/$date/raw
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ ~/backups/$date/raw
        sudo cp ~/Desktop/notes.txt ~/backups/$date/raw
        echo "-----------------------------"
        echo Creating archive via tar...
        cd ~/backups/$date
        tar -czf $date.tar.gz ~/backups/$date/raw
        rmdir -rf ~/backups/$date/raw
        cd ~
        echo "-----------------------------"
        echo "Files copied successfully."
        echo "Backup for $date has been created."

    else
        echo "That isn't an option."
        exit 1
    fi

elif [ "$op" == "extract" ]; then
    
    echo "The backups for the following dates were found."
    ls ~/backups
    echo "-----------------------------"
    read -p "Select one to extract: " extractable
    cd /usr/share/undertaker/misc
    echo "Extracting backup on $extractable..."
    echo "-----------------------------"
    tar -xzf ~/backups/$extractable.tar.gz
    echo "Restoring files..."
    echo "-----------------------------"
    cp -f /usr/share/undertaker/misc/undertaker /usr/share/undertaker
    cp -f /usr/share/undertaker/misc/notes.txt ~/Desktop
    rm -r /usr/share/undertaker/misc
    echo "Files restored."

else

    echo "That isn't a valid option."
    exit 1

fi
exit 0

