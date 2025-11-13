#!/bin/bash

# === Colors ===
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# === Package groups ===
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
	tree
  entr
    kitty
    git
    neovim
    tmux
    fastfetch
    bluetui
    ncpamixer
    stow
    sdkman
    unzip
    starship
    less
    man-db
    man-pages
		rclone
		maven
		terraform
)

gui_applications=(
    hyprland
    hyprlock
    waybar
    dunst
    rofi
    google-chrome
    timeshift
    feishin-bin
    postman
		visual-studio-code-bin
    intellij-idea-community-edition
		wpaperd
		naps2
)

other_tools=(
    docker
    docker-compose
    grub-btrfs
    inotify-tools
    timeshift-autosnap
    autofs
		hyprshot
)

# === Functions ===
install_packages() {
    local group_name="$1"
    shift
    echo -e "\n\n${YELLOW}=== Installing $group_name ===${RESET}\n"
    yay -S --noconfirm "$@"
}

install_all_packages() {
    install_packages "protocols"        "${protocols[@]}"
    install_packages "cli tools"        "${cli_tools[@]}"
    install_packages "gui applications" "${gui_applications[@]}"
    install_packages "other tools"      "${other_tools[@]}"

    echo -e "\n\n${YELLOW}=== Installing tools without package manager ===${RESET}\n"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    export sdkman_auto_answer=true
    curl -s "https://get.sdkman.io" | bash
}

configure_system() {
    echo -e "\n\n${YELLOW}=== Configure grub-btrfsd & timeshift-autosnap ===${RESET}\n"
    sudo /etc/grub.d/41_snapshots-btrfs

    UNIT_PATH=$(systemctl show -p FragmentPath grub-btrfsd | cut -d= -f2)
    sudo sed -i 's|^ExecStart=.*|ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto|' "$UNIT_PATH"
    sudo systemctl daemon-reload
    sudo systemctl enable --now grub-btrfsd

    echo -e "\n\n${YELLOW}=== Enable bluetooth.service ===${RESET}\n"
		sudo systemctl enable --now bluetooth

    echo -e "\n\n${YELLOW}=== Install tmux-tpm plugins ===${RESET}\n"
    tmux start-server
    tmux new-session -d
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    tmux kill-server

		echo -e "\n\n${YELLOW}=== Configure Docker ===${RESET}\n"

		# Check if group 'docker' exists
		if ! getent group docker >/dev/null; then
				sudo groupadd docker
				echo "Created docker group."
		else
				echo "Docker group already exists."
		fi

		# Check if user is already in the group
		if id -nG "$USER" | grep -qw docker; then
				echo "User $USER already in docker group."
		else
				sudo usermod -aG docker "$USER"
				echo "Added $USER to docker group."
		fi

    echo -e "\n\n${YELLOW}=== Configure autofs ===${RESET}\n"
    line="/cifs /etc/autofs/auto.smb --timeout=300"
    file="/etc/autofs/auto.master"
    if ! grep -qxF "$line" "$file"; then
        echo "$line" | sudo tee -a "$file" > /dev/null
    fi

    sudo systemctl restart autofs
    sudo systemctl enable --now autofs

    bookmarks="$HOME/.config/gtk-3.0/bookmarks"
    mkdir -p "$(dirname "$bookmarks")"
    line="file:///cifs/192.168.178.101 TrueNAS"
    if ! grep -qxF "$line" "$bookmarks" 2>/dev/null; then
        echo "$line" >> "$bookmarks"
    fi

		echo -e "${RED}Manual steps required:"
		echo "	1. Create a file under '/etc/creds/<host-ip>'"
		echo "	2. Content has to be like:"
		echo ""
		echo "			username=<username>"
		echo "			password=<password>"
		echo ""
		echo "	3. Save the file and set permissions to 600"
		echo -e "	4. Restart autofs via 'sudo systemctl restart autofs'${RESET}"
}

run_all() {
    install_all_packages
    configure_system
}

# === Menu ===
echo -e "${YELLOW}Select what to do:${RESET}"
echo "1) Run ALL (install + configure)"
echo "2) Only install packages"
echo "3) Only run configurations"
echo "4) Exit"
read -rp "Choice [1-4]: " choice

case $choice in
    1) run_all ;;
    2) install_all_packages ;;
    3) configure_system ;;
    4) echo "Exit."; exit 0 ;;
    *) echo "Invalid choice."; exit 1 ;;
esac

