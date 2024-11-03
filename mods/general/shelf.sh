#!/bin/bash

Header () {
here=$(pwd)
cd /usr/share/undertaker/docs
./header.sh
cd $here
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
        mkdir /home/scriptmonkey/backups/$date
        mkdir /home/scriptmonkey/backups/$date/raw
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ /home/scriptmonkey/backups/$date/raw
        sudo cp /home/scriptmonkey/Desktop/notes.txt /home/scriptmonkey/backups/$date/raw
        echo "-----------------------------"
        echo Creating archive via tar...
        cd /home/scriptmonkey/backups/$date
        tar -czf $date.tar.gz /home/scriptmonkey/backups/$date/raw
        cd /home/scriptmonkey
        echo "-----------------------------"
        echo "Files copied successfully."
        echo "Backup for $date has been created."
    
    elif [ "$yesno" == "n" ]; then
        echo "Creating backup folder..."
        date=$(date +"%Y-%m-%d")
        mkdir /home/scriptmonkey/backups/$date
        mkdir /home/scriptmonkey/backups/$date/raw
        echo "-----------------------------"
        echo "Copying files..."
        sudo cp -r  /usr/share/undertaker/ /home/scriptmonkey/backups/$date/raw
        sudo cp /home/scriptmonkey/Desktop/notes.txt /home/scriptmonkey/backups/$date/raw
        echo "-----------------------------"
        echo Creating archive via tar...
        cd /home/scriptmonkey/backups/$date
        tar -czf $date.tar.gz /home/scriptmonkey/backups/$date/raw
        rmdir -rf /home/scriptmonkey/backups/$date/raw
        cd /home/scriptmonkey
        echo "-----------------------------"
        echo "Files copied successfully."
        echo "Backup for $date has been created."

    else
        echo "That isn't an option."
        exit 1
    fi

elif [ "$op" == "extract" ]; then
    
    echo "The backups for the following dates were found."
    ls /home/scriptmonkey/backups
    echo "-----------------------------"
    read -p "Select one to extract: " extractable
    cd /usr/share/undertaker/misc
    echo "Extracting backup on $extractable..."
    echo "-----------------------------"
    tar -xzf home/scriptmonkey/backups/$extractable.tar.gz
    echo "Restoring files..."
    echo "-----------------------------"
    cp -f /usr/share/undertaker/misc/undertaker /usr/share/undertaker
    cp -f /usr/share/undertaker/misc/notes.txt /home/scriptmonkey/Desktop
    rm -r /usr/share/undertaker/misc
    echo "Files restored."

else

    echo "That isn't a valid option."
    exit 1

fi
exit 0

