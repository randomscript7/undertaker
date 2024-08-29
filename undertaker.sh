#!/bin/bash

#config var bank
waitTime=1

# Opens menu to introduce script
Header () {
	clear
	here=$(pwd)
	cd /usr/share/undertaker
	./header.sh
	cd $here
}

# Function that asks what script the user wants to run, and runs it
taskPicker(){

    echo "You may now excecute the number according to an undertaker module."
	echo "If you don't know which module you're looking for, you can search for one with the command < search >."
	read -p "> " task_number
	

	if [ "$0" == "search" ]; then
		grep "$1" /usr/share/undertaker/docs/moduleList.txt
	else
		Excecute "$task_number"
	fi

}

# Function that actually runs scripts
Excecute(){
	local task_number=$1
	case $task_number in

		G1)
			/usr/share/undertaker/mods/general/UpdateProcedure.sh
			exit 0
			;;

		G2)
			/usr/share/undertaker/mods/general/setVar.sh
			exit 0
			;;

		G3)
			/usr/share/undertaker/mods/general/backupProcedure.sh
			exit 0
			;;

		P1)
			/usr/share/undertaker/mods/pentest/hashcracker.sh
			exit 0
			;;

		P2)
			/usr/share/undertaker/mods/pentest/hashmaker.sh
			exit 0
			;;

		P3)
			/usr/share/undertaker/mods/pentest/netCrack.sh
			exit 0
			;;

		404)
			echo "-----------"
			echo "Due to the magnitude of undertaker, there may be several problems. These problems must be identified in order to be fixed easier."
			echo "Anywhere an error could commonly occur, an error code will be returned. These error codes are as follows:"
			echo "Error code 1 - invalid input"
			#I'll add error codes as I finish stuff
			exit 0
			;;

		search)
			echo "----------"
			read -p "Enter your search terms: " searchTerm
			echo "Searching moduleList.txt for scripts containing the term '$searchTerm'..."
			sleep 
			echo "Results found:"
			echo "----------"
			grep "$searchTerm" -i -s --colour red /usr/share/undertaker/docs/moduleList.txt
			exit 0
			;;

		setup)
			if ! test -f /usr/share/undertaker/undertaker; then
				
				Header
				echo "undertaker has already been set up, or reconfigured in a way that cannot be reverted by the undertaker setup utiliy."
				echo "If you require an automatic setup, remove the old files manually and reclone the repository."
				echo "This can be achieved through the following command: "
				echo "----------"
				echo "git clone https://github.com/randomscript7/undertaker /usr/share"
				echo "----------"
				echo "And it will be set up anew by running [undertaker.sh setup] again."
				exit 1

			else
	
				Header
				echo "Entering undertaker setup..."
				sleep 
				echo "If you're here, you just cloned the undertaker github repository."
				echo "You can CTRL-C to exit this if it was on accident."
				echo "If not, your newly cloned repository will be cleaned up for you."
				sleep 1
				echo "----------"
				echo "Relocating the main undertaker file to bin..."
				sudo mv /usr/share/undertaker/undertaker.sh /bin
				echo "Done."
				echo "----------"
				echo "Cleaning up the undertaker directory..."
				sudo mv /usr/share/undertaker/undertaker/* /usr/share/undertaker
				sudo rmdir /usr/share/undertaker/undertaker
				echo "Done."
				echo "----------"
				echo "The setup process has finished."
				exit 0
	
			fi
			;;

		config)
			# Like a mini setVar.sh but for undertaker.sh
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
	# Nothing. We just open the menu like usual :D

	Header
	echo ""
	echo "-----------"
	echo "Welcome to the undertaker networking tool."
	echo "This tool is a multipurpose virtual assistant, completley hardcoded to be fully customizable."
	echo "It has little function of its own other than connecting 'modules' (scripts) to a centralized tool."
	echo "This allows documentation and heightened ease of use of numerous tools that would usually be understood only by its creator."
	echo "-----------"
	
	#This prompts the user to pick a module, and executes it
	taskPicker
else
	# If this script was invoked with a module code, go to that module directly
	Header
	echo "Argument detected."
	echo "Fast-tracking to module marked as '$1'..."
	sleep $waitTime
	Excecute "$1"
fi


exit 0

