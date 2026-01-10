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

# Function to detect shell and set config file
setup_shell_config() {
	if [[ -z "$SHELL" ]]; then
		echo "WARNING: \$SHELL is unset. Assuming bash."
		SHELL=/bin/bash
	fi
	shell_type=$(basename "$SHELL")
	REAL_USER="${SUDO_USER:-$USER}"
	userHome=$(getent passwd "$REAL_USER" | cut -d: -f6)
	if [[ "$shell_type" == "zsh" ]]; then
		config_file=/$userHome/.zshrc
		zoxide_init='eval "$(zoxide init zsh)"'
	else
		config_file=/$userHome/.bashrc
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