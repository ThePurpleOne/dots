#!/usr/bin/env bash

set -euo pipefail

### Prevent running as root ###
if [ "$(id -u)" -eq 0 ]; then
    echo "Please run this script as a regular user.\nThe script will use sudo when necessary." >&2
    exit 1
fi

### Check for sudo ###
if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
    echo "Warning: 'sudo' not found. Running commands without sudo." >&2
fi

### Prompt for Setup Type ###
echo "Choose setup type:"
OPTIONS=("CLI only" "CLI + i3 WM")
select opt in "${OPTIONS[@]}"; do
    case $opt in
        "CLI only")
            INSTALL_I3=false
            break
            ;;
        "CLI + i3 WM")
            INSTALL_I3=true
            break
            ;;
        *)
            echo "Invalid option $REPLY"
            ;;
    esac
done

### Update System ###
echo "Updating system packages..."
$SUDO pacman -Syu --noconfirm

### Install yay ###
if ! command -v yay &>/dev/null; then
    echo "Installing yay (AUR helper)..."
    $SUDO pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    pushd /tmp/yay
        makepkg -si --noconfirm
    popd
else
    echo "yay is already installed."
fi

### Define Package Lists ###
CLI_PACKAGES=(
    zsh uv helix zoxide ripgrep fd bat eza unp dust duf hyperfine stow
    fzf arm-none-eabi-gcc act cmake make docker docker-compose tldr sshs htop
)

I3_PACKAGES=(
    i3 alacritty zsh feh flameshot arandr autoxrandr picom
    network-manager-applet brightnessctl dunst visual-studio-code-bin
    thunar polybar rofi ttf-jetbrains-mono-nerd ttf-iosevka-nerd
)

PACMAN_PKGS=()
YAY_PKGS=()

for pkg in "${CLI_PACKAGES[@]}"; do
    if pacman -Qq "$pkg" &>/dev/null || yay -Qq "$pkg" &>/dev/null; then
        echo "$pkg is already installed"
    elif pacman -Si "$pkg" &>/dev/null; then
        PACMAN_PKGS+=("$pkg")
    else
        YAY_PKGS+=("$pkg")
    fi
done

if [ "$INSTALL_I3" = true ]; then
    for pkg in "${I3_PACKAGES[@]}"; do
        if pacman -Qq "$pkg" &>/dev/null || yay -Qq "$pkg" &>/dev/null; then
            echo "$pkg is already installed"
        elif pacman -Si "$pkg" &>/dev/null; then
            PACMAN_PKGS+=("$pkg")
        else
            YAY_PKGS+=("$pkg")
        fi
done
fi

### Install Packages ###
echo "Installing pacman packages..."
if [ ${#PACMAN_PKGS[@]} -gt 0 ]; then
    $SUDO pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
fi

echo "Installing AUR packages with yay..."
if [ ${#YAY_PKGS[@]} -gt 0 ]; then
    yay -S --noconfirm --needed "${YAY_PKGS[@]}"
fi

#### Dotfiles Setup with stow ###
#echo "Choose which dotfiles to set up (multi-select with Tab, Enter to confirm):"
#CHOICES=$(find . -maxdepth 1 -type d ! -name "." ! -name ".git" | sed 's|./||' | fzf -m)

#for dir in $CHOICES; do
#    echo "Stowing $dir..."
#    stow "$dir"
#done

echo "Installation complete."
