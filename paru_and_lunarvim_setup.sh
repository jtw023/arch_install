#!/usr/bin/env bash

RED='\033[0;31m' # Red color
BLUE='\033[0;36m' # Cyan color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

func_install() {

	if pacman -Qi $1 &> /dev/null; then

		echo -e "${RED}################## The package "$1" is already installed ##################${NC}"

	else

		paru -S --noremovemake $1

    fi

}

if [[ $UID -ne 0 ]]; then

	echo "################## Editing doas config file ##################"

	su -c "touch /etc/doas.conf"
	su -c "echo 'permit nopass '$USER' as root' > /etc/doas.conf"
	cat /etc/doas.conf
	echo -e "${BLUE}If the above line is not 'permit <yourusername> as root' then please come back to modify /etc/doas.conf${NC}"
	echo -e "${BLUE}Sleeping for 10 seconds while you read this${NC}."
	sleep 10

	echo "################## Editing sudoers config file ##################"

    doas sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
    doas cat /etc/sudoers | grep %wheel
    echo -e "${BLUE}The above line should be '%wheel ALL=(ALL) ALL'. If it is not, please fix${NC}."
    echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
    sleep 20

	echo "################## Installing psutil ##################"

    pip3 install psutil

    echo "################## Installing yapf ##################"

    pip3 install yapf

    echo "################### Enabling paru ###################"
    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/

    echo " ------------------------------------- "
    echo "| Changing ownership of paru directory |"
    echo " ------------------------------------- "

	doas chown -Rv $USER:users ./paru

    echo " ----------------- "
    echo "| cd to /opt/paru/ |"
    echo " ----------------- "

    cd /opt/paru/

    echo " --------- "
    echo "| Makepkg |"
    echo " --------- "

    makepkg -si

    echo " ---------------------------- "
    echo "| cd to users home directory |"
    echo " ---------------------------- "

    cd $HOME/

    echo "################### Installing paru packages ###################"

    list=(
    # brave-bin
    devour
    librewolf-bin
    lua-format
    neovim-git
    pkgfile-git
    pulseaudio-ctl
    slack-desktop
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

    rm -rf $HOME/.config/
    bash <(curl -s https://raw.githubusercontent.com/ChristianChiarulli/lunarvim/master/utils/installer/install.sh)
    
    echo "################### Installing LunarVim Plugins ###################"

    git clone https://github.com/vimwiki/vimwiki.git
    doas mv -rv vimwiki/ $HOME/.local/share/nvim/site/pack/packer/start/
    
    git clone https://github.com/preservim/tagbar.git
    doas mv -rv tagbar/ $HOME/.local/share/nvim/site/pack/packer/start/

    git clone https://github.com/norcalli/nvim-colorizer.lua.git
    doas mv -rv nvim-colorizer.lua/ $HOME/.local/share/nvim/site/pack/packer/start/

    echo "################### Removing .config directory and installing a custom one ###################"

    rm -rf $HOME/.config/
    git clone https://github.com/jtw023/.config.git

    echo "################### Removing Regular Vim ###################"

    doas pacman -Rnsv vim

    echo "################### Removing Sudo ###################"

    doas pacman -Rnsv sudo

    echo "################### Changing primary shell from bash to zsh ###################"

    chsh -s /bin/zsh
    doas chsh -s /bin/zsh root

    echo "################### Setting neovim to git difftool ###################"

    git config --global difftool.prompt true
    git config --global diff.tool nvimdiff
    git config --global difftool.nvimdiff.cmd "nvim -d \"$LOCAL\" \"$REMOTE\""

    echo "################## re-editing doas config file ##################"

	su -c "echo 'permit '$USER' cmd nvim\npermit persist '$USER' cmd pacman\npermit '$USER' cmd updatedb' > /etc/doas.conf"
	cat /etc/doas.conf
	echo -e "${BLUE}If the above three lines are not 'permit <yourusername> cmd nvim', 'permit persist <yourusername> cmd pacman', and 'permit <yourusername> cmd updatedb' then please come back to modify /etc/doas.conf${NC}."
	echo "${BLUE}Sleeping for 30 seconds while you read this${NC}."
	sleep 30

    echo -e "${GREEN}Finished. Be sure to sync any backed up files and make sure the correct version of lunarvim is installed.\nYou can also change the wifi that gets logged into on boot, the redshift amount, and the xrandr command that runs by editing "$HOME"/.config/qtile/scripts/autostart.sh\n\nPlease open nvim and run ':PackerCompile', ':PackerInstall', ':LspInstall efm', and ':LspInstall python'\n\nRemember: you can only run 'nvim', 'pacman -Syu', and 'pacman -Rns' as doas. Sudo is aliased to doas in "$HOME"/.config/zsh/.zshrc. For all other commands please switch to the root user using 'su'${NC}."

else

    echo -e "${RED}This script cannot be run as the root user${NC}."
    
fi
