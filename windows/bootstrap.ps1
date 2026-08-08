## ----------------------------------------
## Important
## Please open PowerShell with administrator.
##
## This runs before WSL holds a clone of the repository, so every file it
## needs is fetched from GitHub rather than read from disk.
## ----------------------------------------

$repo = "https://raw.githubusercontent.com/ktanoooo/dotfiles/main"

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Chocolatey packages
$chocoPkgs = curl "$repo/packages/Chocolateyfile" -UseBasicParsing
foreach ($pkg in ($chocoPkgs.Content -split "`n")) {
  $pkg = $pkg.Trim()
  if ([string]::IsNullOrEmpty($pkg) -or $pkg.StartsWith("#")) { continue }
  Write-Host "Installing $pkg"
  choco install $pkg -y
}

# Set WSL2 as default
wsl --set-default-version 2

# Windows terminal setting
curl "$repo/windows/windows_terminal_settings.json" -o $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -UseBasicParsing

# Install Keyboard Manager
# The scancode map is a registry change and only takes effect after a restart.
curl "$repo/windows/keyboard_manager/scancode_map.ps1" -o .\scancode_map.ps1 -UseBasicParsing
. ".\scancode_map.ps1"
curl "$repo/windows/keyboard_manager/move_cursor_like_ecmas.ahk" -o $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\'Start Menu'\Programs\Startup\move_cursor_like_ecmas.ahk -UseBasicParsing

# Install VSCode
curl "$repo/vscode/settings.json" -o $env:APPDATA\Code\User\settings.json -UseBasicParsing
curl "$repo/vscode/keybindings.json" -o $env:APPDATA\Code\User\keybindings.json -UseBasicParsing
