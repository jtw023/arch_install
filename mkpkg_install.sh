#!/usr/bin/env bash

func_install() {
	if pacman -Qi $1 &> /dev/null; then
		echo "################## The package "$1" is already installed ##################"
	else
		yay -S --noremovemake $1
}

echo "################### Enabling yay ###################"
echo "----------------------------------------------------------------"
echo "cd to /opt/"
echo "----------------------------------------------------------------"

cd /opt/

echo "----------------------------------------------------------------"
echo "Changing ownership"
echo "----------------------------------------------------------------"

chown -Rv jordan:users ./yay

echo "----------------------------------------------------------------"
echo "cd to /opt/yay/"
echo "----------------------------------------------------------------"

cd yay

echo "----------------------------------------------------------------"
echo "Makepkg"
echo "----------------------------------------------------------------"

makepkg -si

echo "----------------------------------------------------------------"
echo "cd to home"
echo "----------------------------------------------------------------"

cd /home/jordan/

echo "################### Installing yay packages ###################"

list=(
# brave
devour
# librewolf
neovim-git
# pulseaudio-ctl
slack-desktop
super-productivity
tutanota-desktop
timeshift
)

count=0

for name in "${list[@]}"; do
	count=$[count+1]
	echo "Installing package number "$count " " $name;
	func_install $name
done

echo "################### Installing LunarVim ###################"

bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)

echo "################### Removing Vim ###################"

doas pacman -Rns vim

echo "################################################################"
echo "Finished. Be sure to rsync files from SSD and make sure your version of lunarvim is installed."
echo "################################################################"
