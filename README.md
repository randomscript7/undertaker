# Undertaker

A custom-built and configurable toolkit of Bash scripts
--------------------------------------------------------------

_**Undertaker is still in early development. Many scripts are on different levels of development. If you'd like to contribute to Undertaker, open an issue with your contribution. New modules are always welcome!**_

### DEVELOPMENT ROADMAP:
Undertaker is always under development. While there is a plan to greatly increase scalability, it may take a long time to implement. Here the current plans for the project are listed, and their priorities.

- Current tasks:
    - Find and clean up rough spots
- Next steps:
    - Write wordlist mode on hashcracker.sh
- Long term goals:
    - Ability to submit locally made modules to be added to an official undertaker module repository
    - Add more modules

### DESCRIPTION:
Undertaker is a small collection of scripts (referred to as "modules"). Undertaker modules vary in function, but they all come ready to use out-of-the-box. Modules are sorted by class (ex. general, pentesting, etc). Undertaker.sh currently only supports preloaded scripts but will eventually allow users to integrate their own. 

### CUSTOMIZABILITY:
Undertaker was made to be fitted to any debian-based machine. Any existing (Bash) scripts can be centralized with undertaker.sh by running the simple setup script included. All modules are licensed to allow modification from its users; you may change, improve, and alter the modules downloaded to your local machine in any way you please. **This feature is still in progess.**

### SUBMITTING AN UNDERTAKER MODULE:
While modules only require a single script to run locally, modules submitted to the greater Undertaker project require additional documentation. This includes a help file and description. In addition, only modules submitted under the certain licenses will be added to the Undertaker repository. **This feature is still in progress.**

### EXECUTING A MODULE:
To execute a module, simply run undertaker.sh in your terminal. You will then be prompted to enter the name of your desired module. If you wish to search for a module with a certain function, you can search the modules' documentation provided.

### INSTALLATION:
Undertaker was written for Debian flavours of Linux. Use the following commands to clone the repository and set up Undertaker on your machine:

```
git clone https://github.com/randomscript7/undertaker ~/undertaker
cd ~/undertaker
sudo chmod +x undertaker.sh
sudo ./undertaker.sh setup
```
