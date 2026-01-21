# Undertaker Bash Toolkit Development Guide

## Overview
Undertaker is a Bash-based toolkit for Debian-based Linux systems that provides a modular approach to scripting. It contains a main entry script (`undertaker.sh`) that acts as a central hub connecting various functional modules.

## Codebase Structure
```
undertaker/
├── undertaker.sh              # Main entry point script
├── README.md                  # Project documentation
├── LICENSE                    # Project license
├── docs/
│   ├── manage.sh              # Installation/uninstallation script
│   └── common.sh              # Common functions used across scripts
├── mods/
│   ├── general/               # General-purpose modules
│   │   ├── latest.sh          # System update module
│   │   ├── setVar.sh          # Variable setting module
│   │   └── shelf.sh           # File backup/restore module
│   └── pentest/               # Penetration testing modules
│       ├── hashmaker.sh       # Hash creation module
│       └── hashcracker.sh     # Hash cracking module
└── docs/
    └── moduleList.txt         # Module listing for search functionality
```

## Build Commands
```bash
# Install Undertaker
git clone https://github.com/randomscript7/undertaker ~/undertaker
cd ~/undertaker
sudo chmod +x undertaker.sh
sudo ./undertaker.sh setup

# Uninstall Undertaker
sudo undertaker.sh uninstall

# Update modules
sudo undertaker.sh latest
```

## Lint Commands
```bash
# Check Bash script syntax
bash -n undertaker.sh
bash -n mods/general/latest.sh
bash -n docs/manage.sh

# Validate shellcheck
shellcheck undertaker.sh
shellcheck mods/general/latest.sh
```

## Test Commands
```bash
# Unit testing - validate individual modules
./mods/general/latest.sh
./mods/pentest/hashmaker.sh
./mods/pentest/hashcracker.sh

# Integration tests
./undertaker.sh --help
./undertaker.sh --version
```

## Code Style Guidelines

### General
- Use lowercase variable names consistently
- Follow POSIX shell standards for portability
- Use `local` keyword for function variables
- All scripts must be executable with `chmod +x`
- Include shebang `#!/bin/bash` at the top of each script

### Naming Convention
- Scripts: `lowercase_with_underscores.sh`
- Functions: `camelCase`
- Variables: `lowercase_with_underscores`
- Constants: `UPPERCASE_WITH_UNDERSCORES`

### Formatting
- Indent with 4 spaces (not tabs)
- Use spaces around operators (`=`, `==`, `!=`, etc.)
- Put opening braces on the same line as the statement
- Separate logical sections with blank lines
- Limit lines to 80 characters where possible

### Comments
- Use `#` for single-line comments
- Comment complex logic and functions
- Document function parameters and return values
- Add a header comment block to each script with description

### Error Handling
- Always check exit status of commands
- Use `exit 1` for error conditions
- Use `exit 0` for successful completion
- Implement proper handling for sudo and permissions

### Function Structure
```bash
function_name() {
    # Function body
    return 0
}
```

### File Permissions
- All scripts in `mods/` must be executable
- Main entry script must be executable: `chmod +x undertaker.sh`
- Installation scripts must be executable: `chmod +x docs/manage.sh`

### Shell Compatibility
- Ensure scripts work with dash and bash
- Avoid bash-specific features unless necessary
- Use portable alternatives where possible
- Test under different shell environments

### Documentation
- Include clear usage instructions in functions
- Document command-line arguments
- Provide examples in help text
- Keep module descriptions in `docs/moduleList.txt` up-to-date