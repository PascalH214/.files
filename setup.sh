#!/bin/bash

# Colors
YELLOW="\033[1;33m"
RESET="\033[0m"

protocols=(
    bluez
    bluez-utils
    brightnessctl
    pipewire
    pipewire-pulse
    ttf-jetbrains-mono-nerd
    wireplumber
)

cli_tools=(
    kitty
    git
    neovim
    tmux
    fastfetch
    bluetui
    ncpamixer
)

gui_applications=(
    hyprland
    waybar
    dunst
    rofi
    google-chrome
)

install_packages() {
    local group_name="$1"
    shift
    echo -e "\n\n${YELLOW}=== Installing $group_name ===${RESET}\n"
    yay -S --noconfirm "$@"
}

install_packages "protocols"        "${protocols[@]}"
install_packages "cli-tools"        "${cli_tools[@]}"
install_packages "gui-applications" "${gui_applications[@]}"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server
