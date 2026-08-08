# Windows setup

First of all, Open PowerShell with administrator.

```
wsl --install
```

Then, restart the PC, open PowerShell with administrator and start setup.

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/windows/bootstrap.ps1 -o .\bootstrap.ps1 -UseBasicParsing
.\bootstrap.ps1
```
