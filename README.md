# Powerlevel10k Themes

Custom Powerlevel10k themes for Zsh, designed for modern terminals with Nerd Fonts.

## Quick start

Open the interactive theme selector:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tirsasaki/powerlevel10k-themes/main/install.sh)"
```

Use `↑`/`↓` or `j`/`k` to move, press `Enter` to install, or press `q` to quit.
Nord Icons is selected by default.

## Themes

- `p10k-lunar-prism.zsh` — transparent ice-blue and lilac theme with rich development icons.
- `p10k-matrix-console.zsh` — three-level green/teal dashboard with system monitoring.
- `p10k-nord-flat.zsh` — icon-rich Nord theme with a modern two-line layout, always-visible `user@host`, system metrics, and explicit Arch/CachyOS logo support.

All themes support detailed Git status, active development tools, Docker context,
right-side command status, instant prompt, transient prompt, and a CachyOS/Arch fallback.

## Installation

Install a specific theme without opening the menu:

```bash
curl -fsSL https://raw.githubusercontent.com/tirsasaki/powerlevel10k-themes/main/install.sh | sh -s -- lunar-prism
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
cp themes/p10k-lunar-prism.zsh ~/.p10k.zsh
source ~/.p10k.zsh
```
