# undertaker

A bundle of scripts written and networked by randomscript7
--------------------------------------------------------------

_**undertaker is still in very early development. Many features are missing for proper release, among other things. If you'd like to contribute to undertaker, open an issue with your contribution. New modules are especially welcome!**_

### DEVELOPMENT ROADMAP:
undertaker is always under development. However, it is still in its initial work stage. The modules are *not* supposed to be included within the same repo as the main undertaker.sh script. Likewise, the modules currently included are largely unfinished and not as customizable as intended. The project as a whole is also not as scalable as desired. While there is a plan to greatly increase scalability, it likely will not be implemented for several months at least. Here we will list the current plans for the project, and their priorities.

- Current tasks:
    - Implement automatic algorithm detection in hashcracker.sh
    - Stylize the undertaker header
- Next steps:
    - Write wordlist mode on hashcracker.sh
    - Add customizability to shelf.sh
- Goals required for full release:
    - Proper error messages in all code
    - Determine exact license requirements and allowances for modules
- Eventual full release:
    - Seperate repositories for modules sorted by class (ex. undertaker-general)
    - Seperate repository for main undertaker.sh script(?)
    - Integrated "add" module in undertaker.sh to conect local scripts
- Long term goals:
    - Ability to submit locally made modules to be added to an official undertaker module repository
    - Add more modules

### DESCRIPTION:
undertaker is a small collection of scripts (referred to as "modules"). Undertaker modules vary in function, but they all come ready to use out-of-the-box. Modules are sorted by class (ex. general, pentesting, etc). undertaker.sh currently only supports scripts included with install but will eventually allow users to integrate their own scripts. 

### CUSTOMIZABILITY:
undertaker.sh was made to be fitted to your machine. Any existing (bash) scripts can be centralized with undertaker.sh by running the simple setup script included. All modules are licensed to allow modification from its users; you may change, improve, and alter the modules downloaded to your local machine in any way you please. **This feature is still in progess.**

### SUBMITTING AN UNDERTAKER MODULE:
While modules only require a single script to run locally, modules submitted to the greater undertaker project require additional documentation. This includes a help file and description. In addition, ONLY modules submitted under the GNU GPL or MIT license will be added to the undertaker repository. **This feature is still in progess.**

### EXECUTING A MODULE:
To execute a module, simply run undertaker.sh in your terminal. You will then be prompted to enter the name of your desired module. If you wish to search for a module with a certain function, you can search the modules' documentation provided.

### INSTALLATION:
Undertaker was written for Debian flavours of Linux. Use the following commands to clone the repository and set up undertaker on your machine:

```
cd /usr/share
sudo git clone https://github.com/randomscript7/undertaker
cd undertaker
sudo mv undertaker.sh /bin
sudo undertaker.sh setup
```
