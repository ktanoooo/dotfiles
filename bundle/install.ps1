$chocoPkgs = curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/bundle/Chocolateyfile

$lines = $chocoPkgs.Content -split "`n"
foreach ($pkg in $lines) {
  if (![string]::IsNullOrEmpty($pkg) -and $pkg -notlike "# *") {
    Write-Host "Installing $pkg"
    choco install $line -y
  }
}
