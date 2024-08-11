# undertaker.sh

A multi-script networking tool written by randomscript7
--------------------------------------------------------------

_**undertaker.sh is actively under development. More changes to both the initial networking script and modules are underway. More modules are also being actively created. If you have one of your own that fits the project, you can contact us to integrate your module directly into the project files. This process will simplify over time as the project matures. Greater repository changes are certain over time.**_

DESCRIPTION: undertaker.sh is a simple, lightweight bash script that centralizes control to scripts (referred to as 'modules').
If you have a file archiving script called backup.sh and a system update script called update.sh, undertaker.sh will allow you to execute both from the same location. Modules can have any purpose; General, automation, pentesting, creative, etc. These purposes (referred to as classes) vary and are all included.

CUSTOMIZABILITY: undertaker.sh was made to be fitted to your machine. Any existing (bash) scripts can be centralized with undertaker.sh by running the simple setup script included. All modules are licensed to allow modification from its users; you may change, improve, and alter the modules downloaded to your local machine in any way you please.

SUBMITTING AN UNDERTAKER MODULE: While modules only require a single script to run locally, modules submitted to the greater undertaker.sh project require additional documentation. This includes a help file and description. In addition, ONLY modules submitted under the GNU GPL or MIT license will be added to the undertaker.sh repository.

EXECUTING A MODULE: To execute a module, simply run undertaker.sh in your terminal. You will then be prompted to enter the identifier for your desired module. Identifiers are made up of a letter representing the module's class (T represents Tools) and a number (E.G. T4). If you wish to search for a module that possesses a certain function, you can search the documentation of the modules provided.

INSTALLATION: undertaker.sh is currently only functional in Debian flavours of Linux. You will need to use the following command to clone the repository via git:
```
sudo git clone https://github.com/randomscript7/undertaker.sh
```
And use the following command to allow the modules to be executed:
```
sudo chmod +x /usr/share/undertaker/*
```
