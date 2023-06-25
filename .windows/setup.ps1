## ----------------------------------------
## Important
## Please open PowerShell with administrator.
## ----------------------------------------

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Set WSL2 as default
wsl --set-default-version 2

# Windows terminal setting
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.windows/windows_terminal_settings.json -o $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

# Install Keyboard Manager
choco install powertoys -y
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.windows/keyboard_manager/powertoys_default.json -o $env:USERPROFILE\AppData\Local\Microsoft\PowerToys\'Keyboard Manager'\default.json
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.windows/keyboard_manager/move_cursor_like_ecmas.ahk -o $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\move_cursor_like_ecmas.ahk

# Install VSCode
choco install vscode -y
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/settings.json -o $env:AppData\Roaming\Code\User\settings.json
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/keybindings.json -o $env:APPDATA\Code\User\keybindings.json

# Install Browser
choco install googlechrome -y

# Install Communication Apps
choco install slack -y
choco install discord -y
choco install zoom -y

# Install Fonts
choco install cascadiacode -y
choco install nerdfont-hack -y

# Install Work tools
choco install keepassxc -y
choco install postman -y
choco install bloomrpc -y
choco install mysql.workbench -y
choco install microsoft-windows-terminal -y
choco install dropbox -y
choco install docker-desktop -y
