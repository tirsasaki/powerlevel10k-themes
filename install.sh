#!/bin/sh

set -eu

REPOSITORY="tirsasaki/powerlevel10k-themes"
DEFAULT_THEME="nord-flat"
BASE_URL="${P10K_THEMES_BASE_URL:-https://raw.githubusercontent.com/${REPOSITORY}/main}"
CONFIG_FILE="${P10K_CONFIG_FILE:-$HOME/.p10k.zsh}"
ZSH_CONFIG="${P10K_ZSH_CONFIG:-$HOME/.zshrc}"

THEMES="lunar-prism
matrix-console
nord-flat"

usage() {
    cat <<EOF
Usage: install.sh [THEME]
       install.sh --list

Opens an interactive theme selector when THEME is omitted.
Use Up/Down or j/k to move, Enter to install, and q to quit.
In a non-interactive terminal, ${DEFAULT_THEME} is installed.
EOF
}

list_themes() {
    printf '%s\n' "$THEMES" | while IFS= read -r theme; do
        [ -n "$theme" ] && printf '  %s\n' "$theme"
    done
    return 0
}

is_valid_theme() {
    printf '%s\n' "$THEMES" | grep -Fxq "$1"
}

theme_at() {
    printf '%s\n' "$THEMES" | sed -n "${1}p"
}

select_theme() {
    theme_count=$(printf '%s\n' "$THEMES" | wc -l | tr -d ' ')
    selected=1
    default_index=1
    index=1

    while IFS= read -r candidate; do
        if [ "$candidate" = "$DEFAULT_THEME" ]; then
            default_index=$index
            break
        fi
        index=$((index + 1))
    done <<EOF
$THEMES
EOF
    selected=$default_index

    old_stty=$(stty -g < /dev/tty)
    trap 'stty "$old_stty" < /dev/tty; printf "\033[?25h" > /dev/tty' EXIT HUP INT TERM
    stty -echo -icanon min 1 time 0 < /dev/tty
    printf '\033[?25l' > /dev/tty

    while :; do
        printf '\033[2J\033[H' > /dev/tty
        printf '\033[1;36mPowerlevel10k Theme Installer\033[0m\n' > /dev/tty
        printf 'Choose a theme to install\n\n' > /dev/tty

        index=1
        while IFS= read -r candidate; do
            if [ "$index" -eq "$selected" ]; then
                if [ "$candidate" = "$DEFAULT_THEME" ]; then
                    printf '  \033[1;36m❯ %s\033[0m \033[2m(default)\033[0m\n' "$candidate" > /dev/tty
                else
                    printf '  \033[1;36m❯ %s\033[0m\n' "$candidate" > /dev/tty
                fi
            elif [ "$candidate" = "$DEFAULT_THEME" ]; then
                printf '    %s \033[2m(default)\033[0m\n' "$candidate" > /dev/tty
            else
                printf '    %s\n' "$candidate" > /dev/tty
            fi
            index=$((index + 1))
        done <<EOF
$THEMES
EOF

        printf '\n\033[2m↑/↓ or j/k: move   Enter: install   q: quit\033[0m\n' > /dev/tty
        key=$(dd bs=1 count=1 2>/dev/null < /dev/tty)

        case "$key" in
            '')
                theme=$(theme_at "$selected")
                break
                ;;
            j)
                selected=$((selected % theme_count + 1))
                ;;
            k)
                selected=$(((selected + theme_count - 2) % theme_count + 1))
                ;;
            q|Q)
                stty "$old_stty" < /dev/tty
                printf '\033[?25h\033[2J\033[HInstallation cancelled.\n' > /dev/tty
                trap - EXIT HUP INT TERM
                exit 0
                ;;
            "$(printf '\033')")
                key2=$(dd bs=1 count=1 2>/dev/null < /dev/tty)
                if [ "$key2" = "[" ]; then
                    key3=$(dd bs=1 count=1 2>/dev/null < /dev/tty)
                    case "$key3" in
                        A) selected=$(((selected + theme_count - 2) % theme_count + 1)) ;;
                        B) selected=$((selected % theme_count + 1)) ;;
                    esac
                fi
                ;;
        esac
    done

    stty "$old_stty" < /dev/tty
    printf '\033[?25h\033[2J\033[H' > /dev/tty
    trap - EXIT HUP INT TERM
}

download() {
    url=$1
    output=$2

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$output" "$url"
    else
        printf 'Error: curl or wget is required.\n' >&2
        exit 1
    fi
}

powerlevel10k_available() {
    [ -r "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme" ] ||
        [ -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ] ||
        [ -r /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ] ||
        [ -r /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme ]
}

enable_zsh_integration() {
    mkdir -p "$(dirname "$ZSH_CONFIG")"
    touch "$ZSH_CONFIG"

    if grep -Fq '.p10k.zsh' "$ZSH_CONFIG" || grep -Fq "$CONFIG_FILE" "$ZSH_CONFIG"; then
        printf 'Powerlevel10k configuration is already loaded by %s.\n' "$ZSH_CONFIG"
    else
        {
            printf '\n# Powerlevel10k custom theme\n'
            printf '[[ -r %s ]] && source %s\n' '"$HOME/.p10k.zsh"' '"$HOME/.p10k.zsh"'
        } >> "$ZSH_CONFIG"
        printf 'Enabled the Powerlevel10k configuration in %s.\n' "$ZSH_CONFIG"
    fi
}

case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    -l|--list)
        printf 'Available themes:\n'
        list_themes
        exit 0
        ;;
    '')
        if [ -t 1 ] && [ -r /dev/tty ] && [ -w /dev/tty ]; then
            select_theme
        else
            theme=$DEFAULT_THEME
            printf 'No interactive terminal detected; installing default theme %s.\n' "$theme"
        fi
        ;;
    *)
        theme=$1
        ;;
esac

if ! is_valid_theme "$theme"; then
    printf 'Error: unknown theme "%s".\n\nAvailable themes:\n' "$theme" >&2
    list_themes >&2
    exit 1
fi

config_dir=$(dirname "$CONFIG_FILE")
mkdir -p "$config_dir"
temporary_file=$(mktemp "$config_dir/.p10k.zsh.XXXXXX")
trap 'rm -f "$temporary_file"' EXIT HUP INT TERM

download "$BASE_URL/themes/p10k-$theme.zsh" "$temporary_file"

if command -v zsh >/dev/null 2>&1; then
    if ! zsh -n "$temporary_file"; then
        printf 'Error: downloaded theme failed Zsh syntax validation.\n' >&2
        exit 1
    fi
else
    printf 'Warning: Zsh is not installed; syntax validation was skipped.\n' >&2
fi

if [ -f "$CONFIG_FILE" ]; then
    timestamp=$(date '+%Y%m%d-%H%M%S')
    backup_file="$CONFIG_FILE.backup-$timestamp"
    cp "$CONFIG_FILE" "$backup_file"
    printf 'Backed up existing configuration to %s.\n' "$backup_file"
fi

chmod 600 "$temporary_file"
mv "$temporary_file" "$CONFIG_FILE"
trap - EXIT HUP INT TERM

enable_zsh_integration

if ! powerlevel10k_available; then
    printf 'Warning: Powerlevel10k was not found in a common installation path.\n' >&2
    printf 'Install Powerlevel10k and load it before sourcing ~/.p10k.zsh.\n' >&2
fi

printf '\nInstalled %s to %s.\n' "$theme" "$CONFIG_FILE"
printf 'Open a new terminal or run: source %s\n' "$CONFIG_FILE"

