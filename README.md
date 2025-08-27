# Hexmason's rice

This repository contains scripts to install and uninstall my personal rice.
It includes a tiling window manager setup with custom themes, utilities, and tools for a minimal yet functional desktop environment.

IMPORTANT: The install/uninstall scripts do **not** require `sudo` to run.  
They operate within your user account: cloning repositories, building software from source, and creating symbolic links inside your home directory.  

**Note:** Installing system packages listed under "Required" (below) must be done separately and may require `sudo` (for example via `pacman` on Arch-based systems).

## 📦 Dependencies

### Required
Before running the install script, make sure the following packages are installed:

```sh
sudo pacman -Syu --needed base-devel freetype2 libxft libx11 libxinerama \
libxrandr libxext libxres git gcc make feh rofi xdotool sxiv dunst
```

These dependencies are essential for compiling and running the window manager, utilities, and appearance settings.

**Note:** For the `set-theme` script to work to dynamically update the system theme, you also need to install the pywalfox and pywal16 packages (available in AUR and PyPI):

```sh 
yay -S python-pywal16 python-pywalfox   # or python-pywalfox-librewolf
```
Or
```sh 
pip install pywal16 pywalfox
```

### Optional
For additional features, you may want to install:

- Web browser with pywalfox support
  - [Librewolf](https://librewolf.net/)
  - or [Firefox](https://www.mozilla.org/firefox/) with the [Pywalfox](https://github.com/Frewacom/pywalfox) extension that integrates color schemes from pywal with your browser for a consistent look.
- [Picom from pijulius](https://github.com/pijulius/picom/tree/implement-window-animations) with window animations support
- [better-swallow](https://github.com/afishhh/better-swallow) program that comes with dwm [betterswallow](https://dwm.suckless.org/patches/betterswallow/) patch

### Examples
Dry-run installation (does not do anything, just prints installation steps):
```sh
./install.sh

```
Apply changes with confirmation:
```sh
./install.sh --apply
```

Apply changes without confirmation:
```sh
./install.sh --apply --yes
```

Update submodules from their remote branches:
```sh
./install.sh --remote-submodules
```

## 🗑️ Uninstallation

If you want to remove the rice and restore your system, run:
```sh
./uninstall.sh --apply
```

## 📖 Notes

- You can see all keybindings in [dwm](https://github.com/hexmason/dwm) and [st](https://github.com/hexmason/st) repositories
- The script is meant to be cross-distribution, but has been tested on Arch and Arch-based systems only.
- Some parts of the rice may require manual tweaks depending on your hardware and preferences.

---

Enjoy your new setup! ✨

