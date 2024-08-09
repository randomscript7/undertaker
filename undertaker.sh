#!/bin/bash

clear
cat /usr/share/undertaker/logo.txt
echo ""
echo "-----------"
echo "Welcome to the undertaker networking tool."
echo "This tool is a multipurpose virtual assistant, completley hardcoded to be fully customizable."
echo "It has little function of its own other than connecting 'modules' (scripts) to a centralized tool."
echo "This allows documentation and heightened ease of use of numerous tools that would usually be understood only by its creator."
echo "-----------"

taskPicker(){

    echo "You may now excecute the number according to an undertaker module."
	echo "if you don't know which module you're looking for, you can search for one with the command < search >."
	read -p "> " task_number
	

	if [ "$0" == "search" ]; then
		grep "$1" /usr/share/undertaker/docs/moduleList.txt
	else
		Excecute "$task_number"
	fi

}

Excecute(){
	local task_number=$1
	case $task_number in

		T1)
			/usr/share/undertaker/hashcracker.sh
			exit 0
			;;

		T2)
			/usr/share/undertaker/UpdateProcedure.sh
			exit 0
			;;

		T3)
			/usr/share/undertaker/hashmaker.sh
			exit 0
			;;

		T4)

			/usr/share/undertaker/backupProcedure.sh
			exit 0
			;;

		T5)

			/usr/share/undertaker/setVar.sh
			exit 0
			;;

		A1)

			/usr/share/undertaker/netCrack.sh
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
			echo "Searching moduleList.txt for scripts containing the term '$searchTerm'"
			echo "----------"
			grep "$searchTerm" -i -s --colour red /usr/share/undertaker/docs/moduleList.txt
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



taskPicker
#this uses the Excecute function to do a certain task
#Excecute "$task_number"
exit 0

