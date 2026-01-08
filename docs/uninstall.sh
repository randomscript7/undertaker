#!/bin/bash

# Check for root permissions
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run with sudo."
    exit 5
fi

# Check for full installation
if [[ ! -f /bin/undertaker.sh ]] || [[ ! -d /usr/share/undertaker ]]; then
    echo "Error: Undertaker does not appear to be fully installed. Please run setup first."
    exit 1
fi

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

# Initial confirmation
Header
read -p "This will uninstall undertaker and remove associated files. Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Dependency list (from dependencies.sh)
dependencyList=(
    "tlp"
    "hashcat"
    "bat"
    "zoxide"
    "fzf"
    "eza"
)

# Dependency handling
echo "Regarding installed dependencies:"
echo "a) Delete all"
echo "b) Keep all"
echo "c) Specify for each dependency"
read -p "Choose an option (a/b/c): " dep_choice

# Array of dependencies to remove
to_remove=()

# Either remove a) all, b) none, or c) ask for each
if [[ "$dep_choice" == "a" ]]; then
    to_remove=("${dependencyList[@]}")
elif [[ "$dep_choice" == "b" ]]; then
    to_remove=()
elif [[ "$dep_choice" == "c" ]]; then
    for dep in "${dependencyList[@]}"; do
        read -p "Remove $dep? (y/n): " remove_dep
        if [[ "$remove_dep" == "y" || "$remove_dep" == "Y" ]]; then
            to_remove+=("$dep")
        fi
    done
else
    echo "Invalid option."
    exit 1
fi

# Final confirmation for dependencies
if [[ ${#to_remove[@]} -gt 0 ]]; then
    echo "Dependencies to remove: ${to_remove[*]}"
    read -p "Proceed with removing these dependencies? (y/n): " final_dep_confirm
    if [[ "$final_dep_confirm" != "y" && "$final_dep_confirm" != "Y" ]]; then
        echo "Dependency removal cancelled. Continuing with other uninstall steps."
        to_remove=()
    fi
fi

# Remove dependencies
for dep in "${to_remove[@]}"; do
    echo "Removing $dep..."
    apt remove -y "$dep"
done

# Remove directories and files
echo "Removing /usr/share/undertaker..."
rm -rf /usr/share/undertaker

echo "Removing /bin/undertaker.sh..."
rm /bin/undertaker.sh

# Clean up shell config
# Detect shell
shell_type=$(basename "$SHELL")
if [[ "$shell_type" == "zsh" ]]; then
    config_file=$HOME/.zshrc
    zoxide_init='eval "$(zoxide init zsh)"'
else
    config_file=$HOME/.bashrc
    zoxide_init='eval "$(zoxide init bash)"'
fi

# Remove lines
sed -i "/^alias le='eza -l --tree --level=2 --binary --no-user --no-permissions --color-scale=size --color-scale-mode=gradient'$/d" "$config_file"
sed -i "/^$zoxide_init$/d" "$config_file"
sed -i '/^alias cat="bat"$/d' "$config_file"
sed -i '/^alias cat="batcat"$/d' "$config_file"

echo "Uninstall complete. Restart your terminal for config changes to take effect."
exit 0