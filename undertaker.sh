#!/bin/bash

# Config var bank
waitTime=1

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

# Function that asks what script the user wants to run, and runs it
modulePicker(){

    echo "You may now excecute the number according to an undertaker module."
	echo "If you don't know which module you're looking for, you can search for one with the command < search >."
	read -p "> " module_number
	

	if [ "$0" == "search" ]; then
		grep "$1" /usr/share/undertaker/docs/moduleList.txt
	else
		Excecute "$module_number"
	fi

}

# Function that actually runs scripts, takes module name as argument and runs it
Excecute(){
	local module_number=$1
	case $module_number in

		latest)
			/usr/share/undertaker/mods/general/latest.sh
			exit 0
			;;

		setVar)
			/usr/share/undertaker/mods/general/setVar.sh
			exit 0
			;;

		shelf)
			/usr/share/undertaker/mods/general/shelf.sh
			exit 0
			;;

		hashcracker)
			/usr/share/undertaker/mods/pentest/hashcracker.sh
			exit 0
			;;

		hashmaker)
			/usr/share/undertaker/mods/pentest/hashmaker.sh
			exit 0
			;;

		404)
			echo "-----------"
			echo "Anywhere an error could commonly occur, an error code will be returned. These error codes are as follows:"
			echo "Exit code 1: General error (incorrect input, unknown error, etc)"
			echo "Exit code 5: Insufficient permissions"
			# Proper error codes will be added eventually
			exit 0
			;;

		search)
			echo "----------"
			read -p "Enter your search terms: " searchTerm
			echo "Searching moduleList.txt for scripts containing the term '$searchTerm'..."
			sleep 1
			echo "Results found:"
			echo "----------"
			grep "$searchTerm" -i -s --colour red /usr/share/undertaker/docs/moduleList.txt
			exit 0
			;;

 		setup)
 			# Check for fresh repo
 			current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 			if [[ "$current_dir" != *"/undertaker"* ]]; then
 				echo "Error: You must clone the repository to a directory named 'undertaker' as per the README. Setup aborted."
 				exit 1
 			fi

			sudo chmod +x "$current_dir/docs/manage.sh"
			if [ -f /bin/undertaker.sh ] || [ -d /usr/share/undertaker ]; then
				# Existing installation detected
				Header
				echo "Undertaker appears to already be installed."
				read -p "Do you want to reinstall (overwrite existing files)? (y/n): " confirm
				if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
					echo "Reinstall cancelled."
					exit 0
				fi

				sudo "$current_dir/docs/manage.sh" --reinstall
			else
				# No installation detected - proceed with fresh install
				sudo "$current_dir/docs/manage.sh" --install
			fi
 			exit 0
 			;;

		config)
			# Integrated setVar.sh for undertaker.sh
			# Useless for now, may be expanded later on
			Header
			echo "The following settings can be changed: "
			echo "waitTime - Time the undertaker.sh header is shown before starting a module"
			echo ""
			read -p "Enter the setting you would like to change: " setting

			if [ "$setting" = "waitTime" ]; then

				echo "waitTime is currently set to: "
				sudo sed -n '4p;' /bin/undertaker.sh
				echo "You may change it to any numerical value (No decimals)"
				#echo "waitTime is currently set to $waitTime."
				read -p "Enter your desired value to set: " newSet
				sudo sed -i "4 s/waitTime=[0-9]/waitTime=$newSet/" /bin/undertaker.sh
				sudo sed -i "147 s/waitTime=[0-9]/waitTime=$newSet/" /bin/undertaker.sh
			fi

			exit 0
			;;

		--help)
			echo "----------"
			echo "Undertaker.sh Help Menu"
			echo "This is the main script that connects all undertaker modules."
			echo "You may run this script without arguments for a wizard-based experience."
			echo "You may also run this script with a module code as an argument to fast-track to that module."
			echo "Scripts which require certain filepaths have been written to allow running both with/without sudo."
			echo "Examples:"
			echo "  > sudo undertaker.sh latest"
			echo "  > undertaker.sh hashcracker"
			echo ""
			echo "Available module codes:"
			echo "latest     - Runs the latest.sh module to update the system."
			echo "setVar     - Runs the setVar.sh module to set undertaker variables."
			echo "shelf      - Runs the shelf.sh module to backup/extract files."
			echo "hashcracker- Runs the hashcracker.sh module to brute-force hashes."
			echo "hashmaker  - Runs the hashmaker.sh module to create hashes using openssl."
			echo "404        - Displays undertaker.sh error codes."
			echo "search     - Searches moduleList.txt for modules matching your search terms."
			echo "setup      - Sets Undertaker up on your system."
			echo "config     - Configures undertaker.sh settings."
			echo "uninstall  - Uninstalls undertaker from the system."
			echo ""
			exit 0
			;;

		--version)
			echo "----------"
			echo "Undertaker.sh Version 1.0.0"
			echo "A script networking tool written by randomscript7"
			echo "----------"
			echo "Disclaimer: I very probably forgot to update this version number at some point..."
			echo "Unless the version is in the form x.y.0, Assume this is slightly outdated."
			echo -e ":)"
			echo ""
			exit 0
			;;

		#-- Comment out unfinished submodule --
		
		#add)
		#	#Runs guided process to integrate script with undertaker
		#	#In progress
		#	
		#	Header
		#	echo "Entering the undertaker.sh module integration process..."
		#	echo "----------"
		#	sleep 0.5
		#	read -p "Enter the filepath to your script: " newScript
		#	echo "undertaker requires documentation for its modules."
		#	echo "Because this script will only be added locally, that is not required, but is still reccommended."
		#	read -p "Do you want to add additional documentation for your script? (y/n): " docsYN
		#	if [ "$docsYN" == "n" ]; then
		#		
		#		exit 0
		#	fi
		#	echo "If you "
		#	echo ""
		#	exit 0
		#	;;
		#
		# -- Comment out unfinished submodule --

 		uninstall)
 			sudo /usr/share/undertaker/docs/manage.sh --uninstall
 			exit 0
 			;;

		*)
			echo "----------"
			echo "That isn't a valid module. If it exists, check to make sure it's downloaded in the /undertaker directory and that it's included in the undertaker.sh file."
			echo "If you were trying to search the modules, use the command < search >."
			exit 1
			;;
	esac
}

# ---------- Script starts here ----------------

# Detect whether the script was executed with an argument or not
if [ "$#" -eq 0 ]; then	
	# Nothing. The wizard-type menu opens like usual

	Header
	echo ""
	echo "Welcome to the undertaker networking tool."
	echo "This tool is a multipurpose virtual assistant, completley hardcoded to be fully customizable."
	echo "It has little function of its own other than connecting 'modules' (scripts) to a centralized tool."
	echo "This allows documentation and heightened ease of use of numerous tools that would usually be understood only by its creator."
	echo "-----------"

	# This prompts the user to pick a module, and executes it
	modulePicker
else
	# If this script was invoked with a module code, go to that module directly
	Header
	echo "Argument detected."
	echo "Fast-tracking to module marked as '$1'..."
	echo ""
	sleep $waitTime
	Excecute "$1"
fi


exit 0

