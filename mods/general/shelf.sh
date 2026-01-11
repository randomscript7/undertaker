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

# Function to load configuration
load_config() {
	local config_file="/usr/share/undertaker/config/shelf_config.txt"
	if [[ ! -f "$config_file" ]]; then
		echo "Error: Config file $config_file not found."
		exit 1
	fi

	# What to back up
	backup_files=()
	# Where to back it up to (default)
	backup_dest=/home/$realUser/backups

	while IFS= read -r line; do
		# Skip comments and empty lines
		[[ $line =~ ^# ]] && continue
		[[ -z $line ]] && continue

		# Override default backup destination with definition in config file
		if [[ $line =~ ^BACKUP_DEST= ]]; then
			backup_dest="${line#BACKUP_DEST=}"
		elif [[ $line =~ ^OPTIONAL_PATHS_PRESENT= ]]; then
			optional_paths_present="${line#OPTIONAL_PATHS_PRESENT=}"
		elif [[ ! -e "$line" ]]; then
			# Optional_paths_present bool determines whether invalid paths
			# Are skipped with a warning or treated as errors 
			if [[ "$optional_paths_present" == "true" ]]; then
				echo "Warning: Optional path $line does not exist, skipping."
				continue
			else
				echo "Error: Path $line does not exist."
				exit 1
			fi
		else
			# Valid file, add to backup list
			backup_files+=("$line")
		fi
	done < "$config_file"

	if [[ ${#backup_files[@]} -eq 0 ]]; then
		echo "Error: No valid backup files specified in config."
		exit 1
	fi
}

# Function to set up backup folders and copy files
setup_backup() {
	local date=$1
	echo "Creating backup folder..."
	mkdir -p "$backup_dest/$date/raw"
	echo "-----------------------------"
	echo "Copying files..."
	for file in "${backup_files[@]}"; do
		if [[ -d "$file" ]]; then
			sudo cp -r "$file" "$backup_dest/$date/raw/"
		else
			sudo cp "$file" "$backup_dest/$date/raw/"
		fi
	done
}

# Function to create archive
create_archive() {
	local date=$1
	local include_raw=$2
	cd "$backup_dest/$date"
	echo "Creating archive via tar..."
	if [[ "$include_raw" == "true" ]]; then
		tar -czf "$date.tar.gz" raw/
	else
		tar -czf "$date.tar" raw/
		rm -rf raw/
	fi
	cd ~
	echo "-----------------------------"
	echo "Files copied successfully."
	echo "Backup for $date has been created in $backup_dest."
}

# This is a script that backs up/extracts files based on config.
# Edit /undertaker/config/shelf_config.txt to customize locations.

Header
echo ""
echo "Running shelf..."
echo "-----------------------------"
read -p "Would you like to backup your selected files or extract a backup? (backup/extract): " operation

load_config

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

	if [[ ! -d "$backup_dest" ]]; then
		echo "No backups directory found at $backup_dest."
		exit 1
	fi

	echo "The backups for the following dates were found."
	ls "$backup_dest"
	echo "-----------------------------"
	read -p "Select one to extract: " extractable

	if [[ ! -d "$backup_dest/$extractable" ]]; then
		echo "Backup $extractable not found."
		exit 1
	fi

	tmpdir=$(mktemp -d)
	cd "$tmpdir"
	echo "Extracting backup from $extractable..."
	echo "-----------------------------"
	tar -xzf "$backup_dest/$extractable/$extractable.tar" 2>/dev/null || tar -xzf "$backup_dest/$extractable/$extractable.tar.gz" 2>/dev/null
	if [[ $? -ne 0 ]]; then
		echo "Failed to extract archive."
		rm -rf "$tmpdir"
		exit 1
	fi
	echo "Restoring files..."
	echo "-----------------------------"
	# Restore based on original paths from config
	for file in "${backup_files[@]}"; do
		local basename_file=$(basename "$file")
		if [[ -d "$tmpdir/$basename_file" ]]; then
			sudo rm -rf "$file"
			sudo mv "$tmpdir/$basename_file" "$file"
		else
			sudo cp -f "$tmpdir/$basename_file" "$file"
		fi
	done
	rm -rf "$tmpdir"
	echo "Files restored."

else

	echo "That isn't a valid option."
	exit 1

fi

exit 0