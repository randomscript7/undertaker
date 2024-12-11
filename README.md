# undertaker

A bundle of scripts written and networked by randomscript7
--------------------------------------------------------------

_**undertaker is still in very early development. Many features are missing for proper release, among other things. If you'd like to contribute to undertaker, open an issue with your contribution. New modules are especially welcome!**_

DESCRIPTION: undertaker.sh is a simple, lightweight bash script that centralizes control to other scripts (referred to as 'modules') with their own respective purposes. undertaker comes with several modules preloaded for use, all of which are accesible through the main undertaker.sh script.

EXECUTING A MODULE: To execute a module, simply run undertaker.sh in your terminal. You will then be prompted to enter the name of your desired module.

INSTALLATION: undertaker.sh is currently only functional in Debian flavours of Linux. You will need to use the following commands to clone the repository via git and allow the program to execute:
```
git clone https://github.com/randomscript7/undertaker
sudo mv /usr/share/undertaker/undertaker.sh /bin
sudo chmod +x /bin/undertaker.sh
```
Then run the integrated setup script:
```
undertaker.sh setup
```
