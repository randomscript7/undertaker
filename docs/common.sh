#!/bin/bash
# Common functions for undertaker scripts

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

# Get the name of the user who invoked the script
# We do NOT need root's username when the user decides to use sudo
realUser=$(ls -ld /home/* 2>/dev/null | awk '{print $3}' | head -n 1)


# Function to detect shell and set config file
setup_shell_config() {
	if [[ -z "$SHELL" ]]; then
		echo "WARNING: \$SHELL is unset. Assuming bash."
		SHELL=/bin/bash
	fi
	shell_type=$(basename "$SHELL")

	if [[ "$shell_type" == "zsh" ]]; then
		config_file=/home/$realUser/.zshrc
		zoxide_init='eval "$(zoxide init zsh)"'
	else
		config_file=/home/$realUser/.bashrc
		zoxide_init='eval "$(zoxide init bash)"'
	fi
}

# Dependency list (shared between install and uninstall)
dependencyList=(
	"tlp"
	"hashcat"
	"bat"
	"zoxide"
	"fzf"
	"eza"
)