## ----------------------------------------
## Important
## Please open PowerShell with administrator.
## ----------------------------------------

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Set WSL2 as default
wsl --install
wsl --set-default-version 2

$chocoBundle = Get-Item *.txt

# Install Windows Terminal
choco install slack -y
choco install vscode -y
choco install discord -y
choco install keepass -y
choco install postman -y
choco install powertoys -y
choco install googlechrome -y
choco install cascadiacode -y  # Code Font
choco install mysql.workbench -y
choco install microsoft-windows-terminal -y

# Copy settings json to C:\Users\ktanoooo\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.windows/windows_terminal_settings.json -o $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json

curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/settings.json -o $env:APPDATA\Code\User\settings.json

curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/keybindings.json -o $env:APPDATA\Code\User\keybindings.json
