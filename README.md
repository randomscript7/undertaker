# undertaker

### A multi-script networking tool written by randomscript7
--------------------------------------------------------------

_**undertaker is actively under development. More changes to both the initial networking script and modules are underway. More modules are also being actively created. If you have one of your own that fits the project, you can contact us to integrate your module directly into the project files. This process will simplify over time as the project matures. Greater repository changes are certain o occur over time.**_

### DEVEOPMENT ROADMAP:
undertaker is always under development. However, it is still in its initial work stage. The modules are *not* supposed to be included within the same repo as the main undertaker.sh script. Likewise, the modules currently included are largely unfinished and not as customizable as intended. The project as a whole is also not as scalable as desired. While there is a plan to greatly increase scalability, it likley will not be implemented for several months at least. Here we will list the current plans for the project, and their priorities.

- Current tasks:
    - Organize files to streamline repo cloning and setup
    - Add integrated module to undertaker.sh (config)
    - Rework 'undertaker' header function on modules to promote their independence
- Next steps:
    - Finish netCrack.sh
    - Write wordlist mode on hashcracker.sh
    - Add customizability to backupProcedure.sh
    - Give more creative module names
    - Repair setVar.sh
- Goals required for full release:
    - Proper error messages in all code
    - Determine exact license requirements and allowances for modules
    - Add more modules
- Eventual full release:
    - Seperate repositories for modules sorted by class (ex. undertaker-general)
    - Seperate repository for main undertaker.sh script
    - Integrated "add" module in undertaker.sh to conect local scripts
- Long term goals:
    - Ability to submit locally made modules to be added to an official undertaker module repository
    - Additional module classes

### DESCRIPTION:
undertaker.sh is a simple, lightweight bash script that centralizes control to scripts (referred to as 'modules').
If you have a file archiving script called backup.sh and a system update script called update.sh, undertaker.sh will allow you to execute both from the same location. Modules can have any purpose; General, automation, pentesting, creative, etc. These purposes (referred to as classes) vary and are all included.

### CUSTOMIZABILITY:
undertaker.sh was made to be fitted to your machine. Any existing (bash) scripts can be centralized with undertaker.sh by running the simple setup script included. All modules are licensed to allow modification from its users; you may change, improve, and alter the modules downloaded to your local machine in any way you please.

### SUBMITTING AN UNDERTAKER MODULE:
While modules only require a single script to run locally, modules submitted to the greater undertaker project require additional documentation. This includes a help file and description. In addition, ONLY modules submitted under the GNU GPL or MIT license will be added to the undertaker repository.

### EXECUTING A MODULE:
To execute a module, simply run undertaker.sh in your terminal. You will then be prompted to enter the identifier for your desired module. Identifiers are made up of a letter representing the module's class (T represents Tools) and a number (ex. T4). If you wish to search for a module that possesses a certain function, you can search the documentation of the modules provided.

### INSTALLATION:
undertaker.sh is currently only functional in Debian flavours of Linux. You will need to use the following command to clone the repository via git:

```
sudo git clone https://github.com/randomscript7/undertaker /usr/share/
```
And use the following command to allow the modules to be executed:
```
sudo chmod +x /usr/share/undertaker/*
```
Afterwards, run the integrated setup script by running
```
sudo /usr/share/undertaker/undertaker.sh setup
```
