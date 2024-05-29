#!/bin/bash

# Install yay package manager
sudo pacman -Sy --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install packages
yay -S \
	jdk21-openjdk nodejs-lts-iron npm elixir udisks2 unclutter \
	alacritty firefox iwd tmux vim neovim btop xclip \
	git gimp lazygit eza fzf ripgrep bat ffmpeg thefuck \
	picom docker docker-compose lazydocker zsh zsh-completions ttf-cascadia-code-nerd \
	google-chrome feh man xorg-xrandr gnome-themes-extra lxappearance flameshot \
	postgresql

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&
	unzip awscliv2.zip &&
	sudo ./aws/install &&
	rm -rf aws awscliv2.zip

##################################################################
# Laptop stuff
read -p "Do you want to run laptop specific configuration? Enter Y or N" response
if [[ "$response" =~ ^[Yy]$ ]]; then
	echo "Xft.dpi: 192" >>~/.Xresources
	xrdb -merge ~/.Xresources
	yay -S acpilight
	echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp wheel $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' | sudo tee /etc/udev/rules.d/backlight.rules
fi
##################################################################

# Shell/terminal configuration
sudo pacman -R xterm # Sets default terminal to Alacritty as it is the only one installed once xterm is removed.
chsh -s /usr/bin/zsh
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Configure Docker
read -p "Enter your username: " user_name
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker "$user_name"

# Tmux configuration
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#################################################################################
# Setup SSH keys and clone GitHub repositories
#################################################################################
# Prompt the user for their email or comment
read -p "Enter your email or comment for the SSH key: " user_input

systemctl --user enable ssh-agent.service --now
ssh-keygen -t ed25519 -f ~/.ssh/id_github -C "$user_input"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_github

# Need to wait until SSH key is added to GitHub
echo "Add SSH key to GitHub and then press ENTER to continue..."
more ~/.ssh/id_github.pub
while true; do
	read -rsn1 input
	if [[ $input == "" ]]; then
		break
	fi
done
echo "Continuing with the script..."

git clone --recurse-submodules git@github.com:dmkenney/dotfiles.git ~/dotfiles
#################################################################################
#################################################################################

# Install dotfiles
~/dotfiles/install.sh

xmodmap ~/.Xmodmap

echo "Setup complete, close everything and logout. When you log back in everything will be configured properly."
