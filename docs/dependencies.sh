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
#hash-identifier - unsed for automatic hash identification

#shelf.sh
#-----------
#tar - used for file archiving


#Array of dependencies to be installed
dependency-list=(
		"tlp"
		"sed"
		"hashcat"
		"hash-identifier"
		"tar"
    )

#Function to loop though dependency array and install them via apt
installDeps () {
	local dependency=0
	for str in "${dependency-list[@]}"; do
		echo "-----------"
		echo "Installing $dependency..."
        sudo apt install "$str" -y

		((dependency++))

	done
}

installDeps

exit 0