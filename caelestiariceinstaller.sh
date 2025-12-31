#!/bin/bash

# Ricesteam — Full Caelestia Anime Rice Installer
# One command → beautiful Arch with anime theme
# Made by 4NM07 — freedom over capitalism 🖤

set -e  # Exit on any error — safety

echo "========================================"
echo " Ricesteam: Installing Caelestia Anime Rice"
echo " Dark anime theme with Quickshell + full apps"
echo "========================================"

# Check Arch
if ! grep -q "Arch Linux" /etc/os-release; then
    echo "Error: This script is only for Arch Linux."
    exit 1
fi

# Install AUR helper if missing (yay is popular)
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
fi

# Full dependencies (deduped and corrected from your list)
echo "Installing all dependencies (official + AUR)..."
sudo pacman -Syu --noconfirm

# Official repos
sudo pacman -S --needed --noconfirm \
    hyprland quickshell kitty rofi wofi foot fuzzel \
    waybar btop fastfetch starship fish jq eza \
    networkmanager lm-sensors brightnessctl ddcutil \
    wireplumber libpipewire wl-clipboard cliphist slurp swappy \
    trash-cli inotify-tools glibc gcc-libs bash \
    qt6-base qt6-declarative xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk hyprpicker papirus-icon-theme \
    adw-gtk-theme ttf-jetbrains-mono-nerd material-symbols \
    caskaydia-cove-nerd otf-font-awesome libqalculate \
    aubio libcava app2unit

# AUR packages
yay -S --noconfirm \
    caelestia-cli-git  # or caelestia-cli for stable
    # Add more AUR if needed (e.g., some fonts/themes)

# Optional apps from your list
sudo pacman -S --needed --noconfirm firefox discord vscode spotify obsidian

# Login manager: greetd + tuigreet (lightweight TUI, no bloat)
if ! pacman -Qi greetd > /dev/null 2>&1; then
    echo "Installing greetd + tuigreet (lightweight TUI login manager)..."
    sudo pacman -S --noconfirm greetd tuigreet
    sudo systemctl enable greetd
    # Simple config for tuigreet
    sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
EOF
fi

# Clone/update Ricesteam repo
RICE_DIR="$HOME/.local/share/ricesteam"
if [ ! -d "$RICE_DIR" ]; then
    git clone https://github.com/4NM07/steamrice.git "$RICE_DIR"
else
    git -C "$RICE_DIR" pull
fi

RICE_PATH="$RICE_DIR/rices/anime-girl-calestia"  # change if folder name different

# Backup existing configs
BACKUP_DIR="$HOME/.config.bak-ricesteam-$(date +%s)"
echo "Backing up existing configs to $BACKUP_DIR..."
[ -d "$HOME/.config" ] && mv "$HOME/.config" "$BACKUP_DIR"

# Apply rice configs (copy — safe and simple)
echo "Applying Caelestia rice configs..."
mkdir -p "$HOME/.config"
cp -r "$RICE_PATH"/* "$HOME/.config/"  # copies all subfolders (shell, cli, theme, etc.)

# Set random wallpaper
WALL_DIR="$HOME/.config/wallpapers"
if [ -d "$WALL_DIR" ] && ls "$WALL_DIR"/*.jpg "$WALL_DIR"/*.png > /dev/null 2>&1; then
    RANDOM_WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
    swaybg -i "$RANDOM_WALL" -m fill &
fi

# Run rice-specific install if exists (install.fish from cli repo)
if [ -f "$HOME/.config/cli/install.fish" ]; then
    echo "Running rice-specific install.fish..."
    fish "$HOME/.config/cli/install.fish"
fi

echo "========================================"
echo " Caelestia Anime Rice fully installed!"
echo " Log out and log back in (or run 'Hyprland')"
echo " Use greetd/tuigreet for login"
echo " Backup of old configs: $BACKUP_DIR"
echo " To undo: mv $BACKUP_DIR $HOME/.config"
echo " Enjoy your beautiful rice! 🖤"
echo "========================================"
