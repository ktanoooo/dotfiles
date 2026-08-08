# dotfiles

## Setup

### Windows

Open PowerShell as administrator.

```powershell
wsl --install
```

Restart, then open PowerShell as administrator again.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/windows/bootstrap.ps1 -o .\bootstrap.ps1 -UseBasicParsing
.\bootstrap.ps1
```

Restart again to pick up the scancode map, then continue inside WSL.

See [windows/README.md](windows/README.md) for details.

### WSL / macOS

`bootstrap.sh` installs Homebrew, authenticates with GitHub and clones this
repository. It opens a browser for `gh auth login`, so it is the one step that
needs a human.

```sh
curl -fsSL https://raw.githubusercontent.com/ktanoooo/dotfiles/main/bootstrap.sh | bash
```

Open a new terminal to pick up the new login shell and Homebrew's `PATH`, then
run `setup.sh` **from the clone**. It resolves paths relative to itself, so it
cannot be piped from `curl`.

```sh
cd $(ghq root)/github.com/ktanoooo/dotfiles
./setup.sh
```

## setup.sh

Every target is guarded, so a full run on a machine that is already set up
costs seconds and can be repeated safely.

```sh
./setup.sh              # everything
./setup.sh setup_gpg    # only the named targets
./setup.sh --list       # show the targets
```

## Layout

```
bootstrap.sh            once per machine, interactive
setup.sh                idempotent, selectable
home/                   linked into $HOME
packages/               package lists read by setup.sh
windows/                Windows only, PowerShell
vscode/                 VSCode settings, linked by setup.sh
devcontainer/           minimal setup for dev containers
docs/                   design notes
```
