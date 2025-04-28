# Install
## pacman-dependencies
sudo pacman -S hyprland rofi waybar kitty tmux
## must-have (not needed for dot-files)
### high-priority
sudo pacman -S docker docker-compose spotify-launcher
### low-priotiy
## tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm <br>
After cloning run tmux and press ctrl+/ & shift+i to install plugins.
## oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
## oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin
