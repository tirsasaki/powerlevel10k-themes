# Powerlevel10k Themes

> [!IMPORTANT]
> **Development status:** This repository is actively under development. Themes, installer behavior, and documentation may change as the project evolves.

Custom Powerlevel10k themes for Zsh, designed for modern terminals with Nerd Fonts.

## Quick start

Open the interactive theme selector:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tirsasaki/powerlevel10k-themes/main/install.sh)"
```

Use `↑`/`↓` or `j`/`k` to move, press `Enter` to install, or press `q` to quit.
Lunar Eclipse is selected by default.

All themes support detailed Git status, active development tools, Docker context,
right-side command status, instant prompt, transient prompt, and a CachyOS/Arch fallback.

## Installation

Install a specific theme without opening the menu:

```bash
curl -fsSL https://raw.githubusercontent.com/tirsasaki/powerlevel10k-themes/main/install.sh | sh -s -- lunar-eclipse
```

List the available theme names:

```bash
curl -fsSL https://raw.githubusercontent.com/tirsasaki/powerlevel10k-themes/main/install.sh | sh -s -- --list
```

The installer validates the downloaded file with Zsh, backs up an existing
`~/.p10k.zsh`, installs the selected theme, and enables it in `~/.zshrc` without
adding duplicate initialization lines.

To install manually, copy a theme to `~/.p10k.zsh` and reload it:

```zsh
cp themes/p10k-lunar-eclipse.zsh ~/.p10k.zsh
source ~/.p10k.zsh
```
...
