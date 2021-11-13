# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Kali Linux for WSL
# choco install wsl-kalilinux -y
# It used to be nice, but it requires privacy authentication now.
# That means not automated with scripts, so install from store.

# Set WSL2 as default
wsl --set-default-version 2

# Install Windows Terminal
choco install microsoft-windows-terminal -y

# Install Cascadia Code Font
choco install cascadiacode -y

# Copy settings json to C:\Users\kohei.murakami\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/master/bundle/.windows/windows_terminal_settings.json  -o $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json -UseBasicParsing

# Install VSCode
choco install vscode
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/master/dotfiles/.vscode/settings.json -o $env:APPDATA\Code\User\settings.json
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/master/dotfiles/.vscode/keybindings.json -o $env:APPDATA\Code\User\keybindings.json

# Install Chrome
choco install chrome

