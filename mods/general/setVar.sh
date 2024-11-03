#!/bin/bash

Header () {
here=$(pwd)
cd /usr/share/undertaker/docs
./header.sh
cd $here
}

Header
echo ""
echo "Welcome to setVar."
echo "This tool is a kind of undertaker copy in fuction."
echo "Commonly changed settings that require file editing can be done so faster here."
echo "Like modules in undertaker, every option serves its own purpose."
echo "-----------"

taskPicker(){

    echo "You may now excecute the desired setting."
	echo "if you don't know which setting you're looking for, you can search for one with the command < search >."
	read -p "> " task_number
	

	if [ "$0" == "search" ]; then
		grep "$1" /usr/share/undertaker/docs/setVars.txt
	else
		Excecute "$task_number"
	fi

}

Excecute(){
	local task_number=$1
	case $task_number in

		powerLimit)

			#Value that defines whether Smart Charging is on or off
			SmartCharge=true;

			#--
			# IMPORTANT: powerLimit uses value of $Endis pre-overwrite.
			# This issue was cheaply solved by inversing the overwrite values.
			# When enabling, it will write disabled; but still output "enabled"
			# ex. Edit conf file > Set $Smartcharge true > Write $Endis "disabled" 
			#--
			#Text value that says what powerLimit was toggled to
			Endis="disabled"

			#Enable smart charging
			Efind="#STOP_CHARGE_THRESH_BAT0=65"
			Efind2="#START_CHARGE_THRESH_BAT0=60"
   			Ereplace="STOP_CHARGE_THRESH_BAT0=65"
			Ereplace2="START_CHARGE_THRESH_BAT0=60"
			
			#Disable smart charging
			Dfind="STOP_CHARGE_THRESH_BAT0=65"
			Dfind2="START_CHARGE_THRESH_BAT0=60"
   	    	Dreplace="#STOP_CHARGE_THRESH_BAT0=65"
			Dreplace2="#START_CHARGE_THRESH_BAT0=60"

			if $SmartCharge; then
				#It's on, so disable it
				
				#Comment it out
				sudo sed -e "/$Dfind/ s/^#*/#/" -i /etc/tlp.conf
				sudo sed -e "/$Dfind2/ s/^#*/#/" -i /etc/tlp.conf
				
				#Set $SmartCharge=false;
				sudo sed -i "41 s/true/false/g" /usr/share/undertaker/mods/general/setVar.sh
				
				#Set $Endis to enabled (For next script use.. read line 43)
				sudo sed -i "50 s/disabled/enabled/g" /usr/share/undertaker/mods/general/setVar.sh	
				
				#Disable tlp in systemctl
				sudo systemctl disable --now tlp

				#Uncomment to debug
				#Print what $Endis is set to
				#sudo sed -n '50p;' /usr/share/undertaker/mods/general/setVar.sh
				#Check conf file to see if the settings are commented or not
				#cat /etc/tlp.conf | grep -i "THRESH_BAT0"

			elif ! $SmartCharge; then
				#It's off, so enable it
				
				#Uncomment it
				sudo sed -i "535 s/$Efind/$Ereplace/g" /etc/tlp.conf
				sudo sed -i "533 s/$Efind2/$Ereplace2/g" /etc/tlp.conf
				
				#Set $SmartCharge=true;
				sudo sed -i "41 s/false/true/g" /usr/share/undertaker/mods/general/setVar.sh

				#Set $Endis to disabled (For next script use.. read line 43)
				sudo sed -i "50 s/enabled/disabled/g" /usr/share/undertaker/mods/general/setVar.sh

				# Enable tlp in systemctl
				sudo systemctl enable --now tlp

				# The following commands can be uncommented to help debug
				#Print what $Endis is set to
				#sudo sed -n '50p;' /usr/share/undertaker/mods/general/setVar.sh
				#Check conf file to see if the settings are commented or not
				#cat /etc/tlp.conf | grep -i "THRESH_BAT0"
			
			else

				echo "An error occured."
				echo "Checking the code is advised."

			fi

			echo "-----------"
   	    	echo "Smart Charging has been $Endis."
			echo "Exiting setVar..."
            
			exit 0
			;;

		404)
			echo "-----------"
			echo "There may be several problems. These problems must be identified in order to be fixed easier."
			echo "Anywhere an error could commonly occur, an error code will be returned. These error codes are as follows:"
			echo "Error code 1 - invalid input"
			#I'll add error codes as I finish stuff
			exit 0
			;;

		search)
			echo "----------"
			read -p "Enter your search terms: " searchTerm
			echo "Searching moduleList.txt for scripts containing the term '$searchTerm'"
			echo "----------"
			grep "$searchTerm" -i -s --colour red /usr/share/undertaker/docs/setVars.txt
			exit 0
			;;

		*)
			echo "----------"
			echo "That isn't a valid setting. If it exists, check to make sure it's included in the setVar.sh file."
			echo "If you were trying to search the modules, use the command < search >."
			exit 1
			;;
	esac
}


#this uses the Excecute function to do a certain task
taskPicker


exit 0