#!/usr/bin/env bash

func_install() {

	if pacman -Qi $1 &> /dev/null; then

		echo "################## The package "$1" is already installed ##################"

	else

		yay -S --noremovemake $1

}

if [[ $UID -ne 0 ]]; then

    echo "################### Enabling yay ###################"
    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/

    echo " ------------------------------------- "
    echo "| Changing ownership of yay directory |"
    echo " ------------------------------------- "

    chown -Rv $USER:users ./yay

    echo " ----------------- "
    echo "| cd to /opt/yay/ |"
    echo " ----------------- "

    cd yay

    echo " --------- "
    echo "| Makepkg |"
    echo " --------- "

    makepkg -si

    echo " ---------------------------- "
    echo "| cd to users home directory |"
    echo " ---------------------------- "

    cd $HOME/

    echo "################### Installing yay packages ###################"

    list=(
    # brave
    devour
    librewolf-bin
    lua-format
    neovim-git
    pkgfile-git
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

    echo "################### Updating pkgfile ###################"
    
    doas pkgfile -u

    echo "################### Installing LunarVim ###################"

    bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)
    
    echo "################### Installing LunarVim Plugins ###################"

    git clone https://github.com/vimwiki/vimwiki.git
    doas mv -rv vimwiki/ $HOME/.local/share/nvim/site/pack/packer/start/
    
    git clone https://github.com/preservim/tagbar.git
    doas mv -rv tagbar/ $HOME/.local/share/nvim/site/pack/packer/start/

    git clone https://github.com/norcalli/nvim-colorizer.lua.git
    doas mv -rv nvim-colorizer.lua/ $HOME/.local/share/nvim/site/pack/packer/start/

    echo "################### Removing Regular Vim ###################"

    doas pacman -Rns vim

    echo "################################################################"
    echo "Finished. Be sure to sync files from SSD and make sure the correct version of lunarvim is installed."
    echo "################################################################"

else

    echo "This script cannot be run as the root user."
    
fi
