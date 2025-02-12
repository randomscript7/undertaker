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
# Plan to add custom file selection and backup location in the future

Header
echo ""
echo "Running shelf..."
echo "-----------------------------"
read -p "Would you like to backup your selected files or extract a backup? (backup/extract): " operation

if [ "$operation" == "backup" ]; then 

    read -p "Would you like to include uncompressed files in your backup? (y/n): " uncompressedyn
    
    if [ "$uncompressedyn" == "y" ]; then

        echo "Creating backup folder..."
        date=$(date +"%Y-%m-%d") # Date variable for naming the backup folder
        mkdir ~/backups/$date # Create base backup folder
        mkdir ~/backups/$date/raw # Create raw folder for uncompressed files
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ ~/backups/$date/raw #Copy undertaker content to raw folder
        sudo cp ~/Desktop/notes.txt ~/backups/$date/raw # Copy notes file to raw folder
        echo "-----------------------------"
        echo Creating archive via tar...
        cd ~/backups/$date # Go to base backup directory
        tar -czf $date.tar.gz ~/backups/$date/raw # Create a tarball of the raw folder INSIDE base backup folder
        cd ~
        echo "-----------------------------"
        echo "Files copied successfully." # Backup left compressed in ~/backups, raw files included
        echo "Backup for $date has been created."
    
    elif [ "$uncompressedyn" == "n" ]; then

        echo "Creating backup folder..."
        date=$(date +"%Y-%m-%d") # Date variable for naming the backup folder
        mkdir ~/backups/$date
        mkdir ~/backups/$date/raw
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ ~/backups/$date/raw # Copy contents to raw folder
        sudo cp ~/Desktop/notes.txt ~/backups/$date/raw # Copy notes file to raw folder
        echo "-----------------------------"
        echo Creating archive via tar...
        cd ~/backups/$date # Go to backup directory
        tar -czf $date.tar ~/backups/$date/raw # Create a tarball of the raw folder INSIDE base backup folder
        rmdir -rf ~/backups/$date/raw # Delete the raw folder
        cd ~
        echo "-----------------------------"
        echo "Files copied successfully." # Backup left compressed in ~/backups, no raw failes
        echo "Backup for $date has been created."

    else
        echo "That isn't an option."
        exit 1
    fi

elif [ "$operation" == "extract" ]; then
    
    echo "The backups for the following dates were found."
    ls ~/backups # List backups
    echo "-----------------------------"
    read -p "Select one to extract: " extractable # User gives backup name
    mkdir /tmp/ut-extract/ # Make temporary directory for extraction
    cd /tmp/ut-extract # Go to temporary directory
    echo "Extracting backup from $extractable..."
    echo "-----------------------------"
    tar -xzf ~/backups/$extractable/$extractable.tar # Extract the tarball
    echo "Restoring files..."
    echo "-----------------------------"
    rm -r /usr/share/undertaker # Remove current undertaker directory
    mv /tmp/ut-extract/undertaker/ /usr/share/undertaker # Move undertaker directory to /usr/share
    cp -f /tmp/notes.txt ~/Desktop # Copy notes file to desktop
    rm -r /tmp/ut-extract # Remove temporary directory
    echo "Files restored."

else

    echo "That isn't a valid option."
    exit 1

fi

exit 0