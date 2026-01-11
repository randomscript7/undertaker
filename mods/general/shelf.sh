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

# Constants
BACKUP_BASE=~/backups
UNDERTAKER_DIR=/usr/share/undertaker
NOTES_FILE=~/Desktop/notes.txt

# Function to set up backup folders and copy files
setup_backup() {
	local date=$1
	echo "Creating backup folder..."
	mkdir -p "$BACKUP_BASE/$date/raw"
	echo "-----------------------------"
	echo "Copying files..."
	sudo cp -r "$UNDERTAKER_DIR/" "$BACKUP_BASE/$date/raw/"
	if [[ -f "$NOTES_FILE" ]]; then
		sudo cp "$NOTES_FILE" "$BACKUP_BASE/$date/raw/"
	fi
}

# Function to create archive
create_archive() {
	local date=$1
	local include_raw=$2
	cd "$BACKUP_BASE/$date"
	echo "Creating archive via tar..."
	if [[ "$include_raw" == "true" ]]; then
		tar -czf "$date.tar.gz" "$BACKUP_BASE/$date/raw"
		local suffix=".tar.gz"
	else
		tar -czf "$date.tar" "$BACKUP_BASE/$date/raw"
		rm -rf "$BACKUP_BASE/$date/raw"
		local suffix=".tar"
	fi
	cd ~
	echo "-----------------------------"
	echo "Files copied successfully."
	echo "Backup for $date has been created."
}

# This is a script that backs up/extracts the undertaker directory and notes file.
# Plan to add custom file selection and backup location in the future

Header
echo ""
echo "Running shelf..."
echo "-----------------------------"
read -p "Would you like to backup your selected files or extract a backup? (backup/extract): " operation

if [ "$operation" == "backup" ]; then

	read -p "Would you like to include uncompressed files in your backup? (y/n): " uncompressedyn

	if [ "$uncompressedyn" == "y" ] || [ "$uncompressedyn" == "n" ]; then
		date=$(date +"%Y-%m-%d")
		setup_backup "$date"
		if [ "$uncompressedyn" == "y" ]; then
			create_archive "$date" "true"
		else
			create_archive "$date" "false"
		fi
	else
		echo "That isn't an option."
		exit 1
	fi

elif [ "$operation" == "extract" ]; then

	if [[ ! -d "$BACKUP_BASE" ]]; then
		echo "No backups directory found."
		exit 1
	fi

	echo "The backups for the following dates were found."
	ls "$BACKUP_BASE"
	echo "-----------------------------"
	read -p "Select one to extract: " extractable

	if [[ ! -d "$BACKUP_BASE/$extractable" ]]; then
		echo "Backup $extractable not found."
		exit 1
	fi

	tmpdir=$(mktemp -d)
	cd "$tmpdir"
	echo "Extracting backup from $extractable..."
	echo "-----------------------------"
	tar -xzf "$BACKUP_BASE/$extractable/$extractable.tar" 2>/dev/null || tar -xzf "$BACKUP_BASE/$extractable/$extractable.tar.gz" 2>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "Failed to extract archive."
		rm -rf "$tmpdir"
		exit 1
	fi
	echo "Restoring files..."
	echo "-----------------------------"
	sudo rm -rf "$UNDERTAKER_DIR"
	sudo mv "$tmpdir/undertaker" "$UNDERTAKER_DIR"
	if [[ -f "$tmpdir/notes.txt" ]]; then
		cp -f "$tmpdir/notes.txt" "$NOTES_FILE"
	fi
	rm -rf "$tmpdir"
	echo "Files restored."

else

	echo "That isn't a valid option."
	exit 1

fi

exit 0