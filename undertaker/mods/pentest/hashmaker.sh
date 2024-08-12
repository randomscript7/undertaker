#!/bin/bash

clear
cat /usr/share/undertaker/logo.txt
echo ""
echo "Welcome to hashmaker."
echo "-------------"
echo "This script will make a hash from whatever string you give it, with one of the supported algorithms."
echo "The dash (-) after it signifies the end of the hash."
echo "Options are (md5/sha1/sha256/sha512)."
read -p "Choose one to continue: " algo
read -p "Input the string you would like hashed: " string
echo "A new hash of '$string' has been created: "
if [ "$algo" == "md5" ]; then
	echo -n  $string | md5sum
elif [ "$algo" == "sha1" ]; then
	echo -n  $string | sha1sum
elif [ "$algo" == "sha256" ]; then
	echo -n $string | sha256sum
elif [ "$algo" == "sha512" ]; then
	echo -n $string | sha512sum
else
	echo "Invalid input. Killing process..."
	exit 1
fi
exit 0


# echo -n $string | sha1sum | awk '{print $string}'
# above would be used to print hashed input