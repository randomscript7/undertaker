#!/bin/bash

#config var bank
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
			echo "Due to the magnitude of undertaker, there may be several problems. These problems must be identified in order to be fixed easier."
			echo "Anywhere an error could commonly occur, an error code will be returned. These error codes are as follows:"
			echo "[Error codes have not yet been implemented]"
			#Proper error codes will be added eventually
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
			if test -f "$current_dir/docs/dependencies.sh"; then
				# Fresh repository: proceed with setup
				Header
				echo "Fresh repository detected. Proceeding with setup."
				sudo rm -rf /usr/share/undertaker
				sudo mv "$current_dir" /usr/share/undertaker

			else
				# Check for existing installation (if either path exists, treat as installed)
				if [ -f /bin/undertaker.sh ] || [ -d /usr/share/undertaker ]; then
					Header
					echo "Undertaker appears to already be installed."
					read -p "Do you want to reinstall (overwrite existing files)? (y/n): " confirm
					if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
						echo "Reinstall cancelled."
						exit 0
					fi
					
				else
					# No installation detected
					Header
					echo "No valid installation or repository detected."
					echo "Please ensure the repository is fully cloned or restore dependencies.sh."
					exit 1
				fi
			fi

			#Complete setup tasks, then delete undertaker-dependencies.sh
			Header
			echo "Entering undertaker setup..."
			sleep 0.5;
			echo "If you're here, you just cloned the undertaker github repository."
			echo "You can CTRL-C to exit this if it was on accident."
			echo "If not, your newly cloned repository will be cleaned up for you."
			sleep 1; # I never used to need these semicolons, but it seems I might now
			echo "----------"
			echo "Giving modules executable permissions..."
			sudo chmod +x /usr/share/undertaker/mods/general/*
			sudo chmod +x /usr/share/undertaker/mods/pentest/*
			sudo chmod +x /usr/share/undertaker/docs/dependencies.sh
			echo "Done."
			echo "----------"
			echo "Installing dependencies..."
			sudo mv /usr/share/undertaker/docs/dependencies.sh /bin/undertaker-dependencies.sh
			sudo undertaker-dependencies.sh
			# Setup additional tools after dependencies install
			echo "Setting up additional tools..."

			# Check and set shell
			if [[ -z "$SHELL" ]]; then
				echo "WARNING: \$SHELL is unset. Assuming bash."
				SHELL=/bin/bash
			fi
			shell_type=$(basename "$SHELL")

			# Set config and zoxide init based on shell
			if [[ "$shell_type" == "zsh" ]]; then
				config_file=$HOME/.zshrc
				zoxide_init='eval "$(zoxide init zsh)"'
			else  # Assume bash for all else
				config_file=$HOME/.bashrc
				zoxide_init='eval "$(zoxide init bash)"'
			fi

			# Eza alias
			echo "alias le='eza -l --tree --level=2 --binary --no-user --no-permissions --color-scale=size --color-scale-mode=gradient'" >> "$config_file"

			# Zoxide init
			echo "$zoxide_init" >> "$config_file"

			# Bat alias for cat
			if command -v bat >/dev/null 2>&1; then
				echo 'alias cat="bat"' >> "$config_file"
			elif command -v batcat >/dev/null 2>&1; then
				echo 'alias cat="batcat"' >> "$config_file"
			fi

			echo "Additional setups completed. Restart your terminal or run 'source $config_file' for changes to take effect."
			read -p "Would you like to source $config_file now? (y/n): " source_now
			if [[ "$source_now" == "y" || "$source_now" == "Y" ]]; then
				source "$config_file"
				echo "Sourced $config_file."
			fi
			echo "----------"
			echo "Done."
			echo "----------"
			sudo mv /usr/share/undertaker/undertaker.sh /bin/undertaker.sh
			rm -rf "$current_dir"
			sudo rm /bin/undertaker-dependencies.sh
			echo "The setup process has finished."
			exit 0
			;;

		config)
			#Integrated setVar.sh for undertaker.sh
			#Useless for now, may be expanded later on
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

		*)
			echo "----------"
			echo "That isn't a valid module. If it exists, check to make sure it's downloaded in the /undertaker directory and that it's included in the undertaker.sh file."
			echo "If you were trying to search the modules, use the command < search >."
			exit 1
			;;
	esac
}

# ----------SCRIPT STARTS HERE----------------

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
	
	#This prompts the user to pick a module, and executes it
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

