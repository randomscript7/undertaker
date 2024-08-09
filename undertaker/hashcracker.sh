#!/bin/bash
# Print undertaker.sh header
Header () {
here=$(pwd)
cd /usr/share/undertaker
./header.sh
cd $here
}

Header
# Introduce script
echo "-----------"
echo "Welcome to the hash cracking protocol, powered by hashcat."
echo "It is managed here by undertaker, where it will ask you questions to simplify the cracking process."
echo "Only common options are available, as any advanced cracking should be done nativley."
echo "-----------"
read -p "What algorithm are your hashes (md5/sha1/wpa2/shadowfile): " Algo

# Choose algorithm

if [ "$Algo" == "md5" ]; then
	hashAlgo=0;
elif
	[ "$Algo" == "sha1" ]; then
	hashAlgo=100;
elif
	[ "$Algo" == "wpa2" ]; then
	hashAlgo=22000;
elif
	[ "$Algo" == "shadowfile" ]; then
	hashAlgo=1600;
else
	echo "That's not a supported hashmode."
	echo "If it exists in hashcat, try it there."
	exit 1
fi

#Determine source of hashes
read -p "Are you cracking an individual hash? (y/n): " hashNum
if [ "$hashNum" == "y" ]; then
	read -p "Enter your hash: " hashFile
elif [ "$hashNum" == "n" ]; then
	read -p "Enter the filepath to your hash file: " hashFile
else
	echo "That's not a vaild input."
	exit 1
fi

# Determine attack mode
read -p "Are you cracking via bruteforce or wordlists? (btfc/wlst): " attackMode
if [ "$attackMode" == "btfc" ]; then
	
	#Determine character length
	read -p "How many characters do you believe the password will be? (Input a number): " charEstimate
	
	#Determine if character length is low enough to crack with optimized mode
	if [ "$charEstimate" -lt 31 ]; then
		optimizedMode=true
	elif [ "$charEstimate" -ge 31 ]; then
		optimizedMode=false
	else
		echo "Something went wrong. Only numerical values are accepted."
		exit 1
	fi
	
	#Determine if ?d can be blanketed
	read -p "Do you believe that the characters are all numbers (y/n) : " allDigits

	if [ "$allDigits" == "y" ]; then
		allDigitsYesno=true
	elif [ "$allDigits" == "n" ]; then
		allDigitsYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

	# Determine if ?l can be blanketed
	read -p "Do you believe that the characters are all lowercase letters (y/n) : " allLower

	if [ "$allLower" == "y" ]; then
		allLowerYesno=true
	elif [ "$allLower" == "n" ]; then
		allLowerYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

	# Determine if ?u can be blanketed
	read -p "Do you believe that the characters are all uppercase letters (y/n) : " allUpper

	if [ "$allUpper" == "y" ]; then
		allUpperYesno=true
	elif [ "$allUpper" == "n" ]; then
		allUpperYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

	# Determine if ?s can be blanketed
	read -p "Do you believe that the characters are all symbols (y/n) : " allSymbols

	if [ "$allSymbols" == "y" ]; then
		allSymbolsYesno=true
	elif [ "$allSymbols" == "n" ]; then
		allSymbolsYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

	# Determine if ?h can be blanketed
	read -p "Do you believe that the characters are all lowercase letters and/or numbers (y/n) : " allLowerMixed

	if [ "$allLowerMixed" == "y" ]; then
		allLowerMixedYesno=true
	elif [ "$allLowerMixed" == "n" ]; then
		allLowerMixedYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

	# Determine if ?H can be blanketed
	read -p "Do you believe that the characters are all uppercase letters and/or numbers (y/n) : " allUpperMixed

	if [ "$allUpperMixed" == "y" ]; then
		allUpperMixedYesno=true
	elif [ "$allUpperMixed" == "n" ]; then
		allUpperMixedYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi

		# Determine if ?a can be blanketed
	read -p "Do you want to try virtually every charset when cracking (y/n) : " allTry

	if [ "$allTry" == "y" ]; then
		allTryYesno=true
	elif [ "$allTry" == "n" ]; then
		allTryYesno=false
	else
		echo "You must answer [y] or [n]."
		exit 1
	fi	

	echo "-----------"
	
	# Automatically construct the final mask string
	makeString () {
	bruteString=""
	for ((i=0; i<$charEstimate; i++));
		do
		bruteString+="$bruteforceEstimate"
	done
	}

	# Prepare the final string with its charsets  
	if $allDigitsYesno; then
		bruteforceEstimate=?d
		makeString
	elif $allLowerYesno; then
		bruteforceEstimate=?l
		makeString
	elif $allUpperYesno; then
		bruteforceEstimate=?u
		makeString
	elif $allSymbolsYesno; then
		bruteforceEstimate=?s
		makeString
	elif $allLowerMixedYesno; then
		bruteforceEstimate=?h
		makeString
	elif $allUpperMixedYesno; then
		bruteforceEstimate=?H
		makeString
	elif $allTryYesno; then
		bruteforceEstimate=?a
		makeString
	else
		# Mask couldn't be automade, so the user created it manually
		echo "Entering the manual mask editor..."
		sleep 0.5
		clear
		echo "-----------"
		echo "Welcome to the manual mask editor."
		echo "Your settings are too vauge to automatically create."
		echo "Therefore, you must create it manually."
		echo "You will now be guided to create this string yourself."
		echo "{---------}"
		echo "Masks are created of charsets. ?d represents a charset of numbers (0123...)"
		echo "Additionally, you can insert guarenteed characters instead of a charset (?dPassword?s > 1Password!)"
		echo "String example 1) ?U?l?l?l?l?s > Crazy! 2) ?d?d?d?dsecure?d?s > 1234secure7!"
		echo "{---------}"
		echo "Charset guide: ?d > 123... ?l > abc... ?u > ABC... ?s > ,?!..."
		echo "Charset guide: ?h > abc123... ?H ABC123... ?a > ?l?u?d?s (everything)"
		echo "{---------}"
		echo ""
		read -p "Enter your string here (must be $charEstimate characters long): " bruteString
		clear
	fi	

	# Function for settings applied to every attack mode (always the first half)
	generalCrackSettings () {
	echo "The neccesary arguments have been constructed to crack your requested hash(es)."
	echo "Settings"
	echo "-----------"
	echo "Hashing algorithm: $hashAlgo ($Algo)"
	echo "Target hash(es): $hashFile"
	echo "Attack type: $attackMode"
	}

	# Function specifc to bruteforce attack mode settings (second half)
	bruteforceCrackSettings () {
	echo "Number of characters: $charEstimate"
	echo "Optimized cracking: $optimizedMode"
	echo "Bruteforce mask created: $bruteString"
	}

	# Annouce the settings for bruteforce
	generalCrackSettings
	bruteforceCrackSettings

	sleep 2
	echo "You have specified that there are $charEstimate characters and as such, optimizedMode has been set to $optimizedMode."
	echo "Any cracked hashes will be outputted to /usr/share/undertaker/hashFiles/crackedHashes/WPA.txt"
	
	# Set time for point of no return (hashcat starting)
	timeToCrack () {
	for i in {0..10..1} 
	do
		echo "Cracking will start in $i"
		sleep 1
	done
	}

	timeToCrack

	# Put all the settings together and run hashcat
	echo "Starting hashcat..."
	sleep 2
	if $optimizedMode; then
		echo "Command used: sudo hashcat -a 3 -m $hashAlgo $hashFile $bruteString--outfile /usr/share/undertaker/crackedHashes/$Algo.txt -O"
		sudo hashcat -a 3 -m $hashAlgo $hashFile $bruteString--outfile /usr/share/undertaker/crackedHashes/$Algo.txt -O
	else
		echo "Command used: sudo hashcat -a 3 -m $hashAlgo $hashFile $bruteString--outfile /usr/share/undertaker/crackedHashes/$Algo.txt"
		sudo hashcat -a 3 -m $hashAlgo $hashFile $bruteString--outfile /usr/share/undertaker/crackedHashes/$Algo.txt
	fi
	exit 0

elif [ "$attackMode" == "wlst"]; then
	echo "Uncoded so far"
	exit 0
else
	echo "That isn't a valid attack mode."
	exit 1
fi