#!/usr/bin/env bash

func_install() {
	if pacman -Qi $1 &> /dev/null; then
		echo "################## The package "$1" is already installed ##################"
	else
		yay -S --noremovemake $1
}

if [ $(whoami) = 'jordan' ]; then

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

    cd $HOME/

    echo "################### Installing yay packages ###################"

    list=(
    # brave
    devour
    librewolf-bin
    lua-format
    neovim-git
    pulseaudio-ctl
    slack-desktop
    superproductivity
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
    echo "Finished. Be sure to sync files from SSD and make sure your version of lunarvim is installed."
    echo "################################################################"
else
    echo "This script cannot be run with as the root user."
    
fi
