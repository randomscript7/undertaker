#!/bin/bash

#This file contains the dependencies that may need to be installed on undertaker setup.
#This file will be deleted upon running [undertaker.sh setup]

#setVar.sh
#-----------
#tlp - used for power management
#sed - used for text manipulation

#hashcracker.sh
#-----------
#hashcat - used for actual cracking of hashes
#hash-identifier - used for automatic hash identification

#shelf.sh
#-----------
#tar - used for file archiving

#Array of dependencies to be installed
dependencyList=(
	"tlp"
	"sed"
	"hashcat"
	"hash-identifier"
	"tar"
)

#Function to loop though dependency array and install them via apt
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