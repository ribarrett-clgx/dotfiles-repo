# Dotfiles Repository

This repository contains shell configuration files for PowerShell, Bash, and Zsh. It allows you to easily manage your shell profiles and set up a consistent environment across different systems.

## Overview

- **PowerShell**: Profile, aliases, and functions for Windows users.
- **Bash**: Configuration files for Unix-based systems (Linux, macOS).
- **Zsh**: Configuration files for Zsh users on Unix-based systems.

This repository can be used on Windows, macOS, and Linux systems to manage shell profiles with the following instructions.

## Installation

To install your shell profiles on different systems, follow the steps below for each platform.

### Windows

1. **Clone the repository**:
   Open PowerShell and run:
   ```powershell
   git clone https://github.com/yourusername/dotfiles-repo.git $env:USERPROFILE\dotfiles
   ```

2. **Set up PowerShell profiles**:
   Run the following command in PowerShell to create symbolic links to your PowerShell profile:
   ```powershell
   New-Item -Path $PROFILE -ItemType SymbolicLink -Force -Target "$env:USERPROFILE\dotfiles\powershell\profile.ps1"
   ```

3. **(Optional) Install Bash or Zsh**:
   If you use Windows Subsystem for Linux (WSL), you can also set up Bash or Zsh:
   ```bash
   ln -sf $HOME/dotfiles/bash/.bashrc $HOME/.bashrc
   ln -sf $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
   ```

### macOS

1. **Clone the repository**:
   Open the terminal and run:
   ```bash
   git clone https://github.com/yourusername/dotfiles-repo.git ~/.dotfiles
   ```

2. **Set up Bash or Zsh profiles**:
   If you are using the default Bash, run:
   ```bash
   ln -sf ~/.dotfiles/bash/.bashrc ~/.bashrc
   ln -sf ~/.dotfiles/bash/.bash_profile ~/.bash_profile
   ```

   If you use Zsh (default on macOS 10.15+), run:
   ```bash
   ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
   ```

3. **PowerShell on macOS**:
   If you use PowerShell on macOS, you can configure it by linking the `profile.ps1`:
   ```bash
   ln -sf ~/.dotfiles/powershell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
   ```

### Linux

1. **Clone the repository**:
   Open the terminal and run:
   ```bash
   git clone https://github.com/yourusername/dotfiles-repo.git ~/.dotfiles
   ```

2. **Set up Bash profiles**:
   If you are using the default Bash, run:
   ```bash
   ln -sf ~/.dotfiles/bash/.bashrc ~/.bashrc
   ln -sf ~/.dotfiles/bash/.bash_profile ~/.bash_profile
   ```

3. **Set up Zsh profiles**:
   If you use Zsh, run:
   ```bash
   ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
   ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
   ```

4. **PowerShell on Linux**:
   If you use PowerShell on Linux, configure it by linking the `profile.ps1`:
   ```bash
   ln -sf ~/.dotfiles/powershell/profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
   ```

## Setup Script

You can also use the `install.sh` (for Unix systems) or `install.ps1` (for Windows) script to automate the setup:

1. **Unix-based systems (macOS, Linux)**:
   Run the following command:
   ```bash
   bash ~/.dotfiles/setup/install.sh
   ```

2. **Windows (PowerShell)**:
   Run the following command:
   ```powershell
   .\dotfiles\setup\install.ps1
   ```

These scripts will automatically link the appropriate configuration files for your shell.

## Customizing the Profiles

- **Aliases**: Each shell configuration file contains useful aliases that you can modify or add to.
- **Functions**: The PowerShell profile contains some custom functions, and you can add more as needed.
- **Environment Variables**: Modify `PATH` and other environment variables in the appropriate profile files.

## Updating the Repository

To keep your dotfiles updated across all machines, follow these steps:

1. Pull the latest changes:
   ```bash
   git pull origin main
   ```

2. If you have made any local changes to your profiles, consider committing them:
   ```bash
   git add .
   git commit -m "Update profiles"
   git push origin main
   ```

3. On other machines, simply run:
   ```bash
   git pull origin main
   ```

## Troubleshooting

- **Permissions**: If you encounter permission issues, make sure your shell has the appropriate access rights to create symbolic links or modify the configuration files.
- **Profile not loading**: Ensure that the correct profile file is being loaded by your shell. For example, `~/.bashrc` is for interactive shells, while `~/.bash_profile` is for login shells on Linux and macOS.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
