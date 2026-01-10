#!/bin/bash

# Unified management script for undertaker install/uninstall/reinstall

source "$(dirname "$0")/common.sh"

# Function to install dependencies
installDeps () {
	local dependency=0
	for str in "${dependencyList[@]}"; do
		echo "-----------"
		echo "Installing $str..."
		sudo apt install "$str" -y
		((dependency++))
	done
}

# Function to handle installation
do_install() {
	current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
	if [[ "$current_dir" != *"/undertaker"* ]]; then
		echo "Error: You must clone the repository to a directory named 'undertaker' as per the README. Setup aborted."
		exit 1
	fi

	# Delete existing undertaker directory and replace it
	Header
	echo "Fresh repository detected. Proceeding with setup."
	sudo rm -rf /usr/share/undertaker
	sudo mv "$current_dir" /usr/share/undertaker

	# Set permissions
	sudo chmod +x /usr/share/undertaker/mods/general/*
	sudo chmod +x /usr/share/undertaker/mods/pentest/*
	sudo chmod +x /usr/share/undertaker/docs/*

	echo "Installing dependencies..."
	installDeps

	# Defines config_file and zoxide_init
	setup_shell_config

	# Add aliases
	echo "alias le='eza -l --tree --level=2 --binary --no-user --no-permissions --color-scale=size --color-scale-mode=gradient'" >> "$config_file"
	echo "$zoxide_init" >> "$config_file"
	echo 'alias cat="batcat"' >> "$config_file"

	echo "----------"
	echo "Additional setups completed."
	read -p "Would you like to source $config_file now? (y/n): " source_now
	if [[ "$source_now" == "y" || "$source_now" == "Y" ]]; then
		source "$config_file"
		echo "Sourced $config_file."
	else
		echo "Restart your terminal or run 'source $config_file' for changes to take effect."
	fi

	sudo mv /usr/share/undertaker/undertaker.sh /bin/undertaker.sh
	rm -rf "$current_dir"
	echo "The setup process has finished."
}

# Function to handle uninstall
do_uninstall() {
	# Check for root
	if [[ $EUID -ne 0 ]]; then
		echo "Error: This script must be run with sudo."
		exit 5
	fi

	# Check for installation
	if [[ ! -f /bin/undertaker.sh ]] || [[ ! -d /usr/share/undertaker ]]; then
		echo "Error: Undertaker does not appear to be fully installed."
		exit 1
	fi

	Header
	read -p "This will uninstall undertaker and remove associated files. Continue? (y/n): " confirm
	if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
		echo "Uninstall cancelled."
		exit 0
	fi

	# Dependency handling
	echo "Regarding installed dependencies:"
	echo "a) Delete all"
	echo "b) Keep all"
	echo "c) Specify for each dependency"
	read -p "Choose an option (a/b/c): " dep_choice

	to_remove=()

	if [[ "$dep_choice" == "a" ]]; then
		to_remove=("${dependencyList[@]}")
	elif [[ "$dep_choice" == "b" ]]; then
		to_remove=()
	elif [[ "$dep_choice" == "c" ]]; then
		for dep in "${dependencyList[@]}"; do
			read -p "Remove $dep? (y/n): " remove_dep
			if [[ "$remove_dep" == "y" || "$remove_dep" == "Y" ]]; then
				to_remove+=("$dep")
			fi
		done
	else
		echo "Invalid option."
		exit 1
	fi

	if [[ ${#to_remove[@]} -gt 0 ]]; then
		echo "Dependencies to remove: ${to_remove[*]}"
		read -p "Proceed with removing these dependencies? (y/n): " final_dep_confirm
		if [[ "$final_dep_confirm" != "y" && "$final_dep_confirm" != "Y" ]]; then
			to_remove=()
		fi
	fi

	# Remove dependencies
	for dep in "${to_remove[@]}"; do
		echo "Removing $dep..."
		apt remove -y "$dep"
	done

	setup_shell_config

	# Remove config changes
	zoxide_entry="$zoxide_init"
	zInitFind=$(printf '%s' "$zoxide_entry" | sed 's/[][\/.^$*]/\\&/g')
	eza_alias="alias le='eza -l --tree --level=2 --binary --no-user --no-permissions --color-scale=size --color-scale-mode=gradient'"
	ezaAliasFind=$(printf '%s' "$eza_alias" | sed 's/[][\/.^$*]/\\&/g')
	batcat_alias='alias cat="batcat"'
	batcatAliasFind=$(printf '%s' "$batcat_alias" | sed 's/[][\/.^$*]/\\&/g')

	sed -i "s|$zInitFind||g" "$config_file"
	sed -i "s|$ezaAliasFind||g" "$config_file"
	sed -i "s|$batcatAliasFind||g" "$config_file"

	# Remove files
	echo "Removing /usr/share/undertaker..."
	rm -rf /usr/share/undertaker
	echo "Removing /bin/undertaker.sh..."
	rm /bin/undertaker.sh

	echo "----------"
	echo "Uninstall complete. Restart your terminal for config changes to take effect."
}

# Main logic
case "$1" in
	--install)
		do_install
		;;
	--uninstall)
		do_uninstall
		;;
	--reinstall)
		do_uninstall
		do_install
		;;
	*)
		echo "Usage: $0 {--install|--uninstall|--reinstall}"
		exit 1
		;;
esac

exit 0