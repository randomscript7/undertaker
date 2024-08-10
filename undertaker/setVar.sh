#!/bin/bash

Header () {
here=$(pwd)
cd /usr/share/undertaker
./header.sh
cd $here
}

Header
echo ""
echo "-----------"
echo "Welcome to setVar."
echo "This tool is a kind of undertaker copy in fuction."
echo "Commonly changed settings that require file editing can be done so faster here."
echo "Like modules in undertaker, every option serves its own purpose."
echo "-----------"

taskPicker(){

    echo "You may now excecute the number according to your desired setting."
	echo "if you don't know which module you're looking for, you can search for one with the command < search >."
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
		$SmartCharge=true;

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
		
		if [ $SmartCharge=true ]; then
				#Disable it
				Endis="Disabled"
				sudo sed -i 's/$Efind/$Ereplace/g' /etc/tlp.conf
				sudo sed -i 's/$Efind2/$Ereplace2/g' /etc/tlp.conf
				$SmartCharge=false;

		elif [ $SmartCharge=false ]; then
				#Enable it
				Endis="Enabled"
				sudo sed -i 's/$Dfind/$Dreplace/g' /etc/tlp.config
				sudo sed -i 's/$Dfind2/$Dreplace2/g' /etc/tlp.config
				$SmartCharge=true;

		else
			echo "An error has occured."
			echo "Inspecting the code is recommended."
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



taskPicker
#this uses the Excecute function to do a certain task
#Excecute "$task_number"
exit 0