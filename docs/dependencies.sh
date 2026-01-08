#!/bin/bash

# This file contains the dependencies that may need to be installed on undertaker setup.
# This file will be deleted upon running [undertaker.sh setup]

# Array of dependencies to be installed
dependencyList=(
	"tlp" # Used for power management in setVar
	#"sed" # Used for text manipulation in setVar (usually pre-installed anyway, critical package)
	"hashcat" # Used for hash cracking in hashcracker
	#"tar" # For file archiving in shelf (usually pre-installed anyway, critical package)
	"bat" # For making files look nice in the terminal
	"zoxide" # For fast directory navigation (Seems to work when installed via apt)
	"fzf" # For fuzzy finding, and zoxide
	"eza" # For making ls better
)

# Function to loop though dependency array and install them via apt
installDeps () {
	local dependency=0
	for str in "${dependencyList[@]}"; do
		echo "-----------"
		echo "Installing "$str"..."
		sudo apt install "$str" -y

		((dependency++))

	done
}

installDeps

exit 0