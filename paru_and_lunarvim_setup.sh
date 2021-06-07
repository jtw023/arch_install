#!/usr/bin/env bash

RED='\033[0;31m' # Red color
BLUE='\033[0;36m' # Cyan color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

func_install() {

    if pacman -Qi $1 &> /dev/null; then

        echo -e "${RED}################## The package "$1" is already installed ##################${NC}"

    else

        paru -S --skipreview --noconfirm $1

    fi

}

if [[ $UID -ne 0 ]]; then

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

    makepkg -si --noconfirm

    echo " ---------------------------- "
    echo "| cd to users home directory |"
    echo " ---------------------------- "

    cd $HOME/

    echo "################### Installing paru packages ###################"

    list=(
    brave-bin
    devour
    librewolf-bin
    lua-format
    pkgfile-git
    pulseaudio-ctl
    slack-desktop
    tutanota-desktop
    # timeshift
    )

    count=0

    for name in "${list[@]}"; do
        count=$[count+1]
        echo -e "${BLUE}Installing package number "$count" of ${#list[@]}${NC}" $name;
        func_install $name
    done

    echo "################### Enabling kvm ###################"

    doas systemctl enable libvirtd
    doas systemctl start libvirtd
    doas virsh net-autostart default

    echo "################### Updating pkgfile ###################"

    doas pkgfile -u

    echo "################### Downloading and Making Neovim ###################"

    git clone https://github.com/neovim/neovim --depth 1
    cd neovim
    doas make CMAKE_BUILD_TYPE=Release install
    cd ..
    rm -rf neovim

    echo "################### Installing custom .config directory ###################"

    rm -rf $HOME/.config/
    git clone https://github.com/jtw023/.config.git

    echo "################## re-editing doas config file ##################"

    su -c "echo -e 'permit '$USER' cmd rsync\npermit '$USER' cmd make\npermit '$USER' cmd mount\npermit persist '$USER' cmd pacman\npermit nopass '$USER' cmd updatedb\npermit nopass '$USER' cmd umount' > /etc/doas.conf"
    cat /etc/doas.conf
    echo -e "${BLUE}If the above lines do not match then please come back to modify /etc/doas.conf.\n\npermit <yourusername> cmd rsync\npermit <yourusername> cmd make\npermit <yourusername> cmd mount\npermit persist <yourusername> cmd pacman\npermit nopass <yourusername> cmd updatedb\npermit nopass <yourusername> cmd umount${NC}"
    echo "${BLUE}Sleeping for 30 seconds while you read this${NC}."
    sleep 30


    echo "################### Removing Regular Vim and Sudo ###################"

    doas pacman -Rnsv --noconfirm vim sudo

    echo "################### Changing primary shell from bash to zsh ###################"

    chsh -s /bin/zsh
    su -c "chsh -s /bin/zsh root"

    echo "################### Setting neovim to git difftool ###################"

    git config --global difftool.prompt true
    git config --global diff.tool nvimdiff
    git config --global difftool.nvimdiff.cmd "\"nvim -d \"$LOCAL\" \"$REMOTE\"\""


    echo "################### Installing fuzzy finder ###################"

    git clone --depth 1 https://github.com/junegunn/fzf.git /home/$USER/.fzf
    /home/$USER/.fzf/install --all

    echo -e ${GREEN}"Finished. Be sure to sync any backed up files.\n\nYou can also change the redshift amount and other things by editing "$HOME"/.config/qtile/scripts/autostart.sh\n\nLastly, please open nvim and run ':PlugInstall'\n\nRemember: doas will not allow most commands other than 'pacman' to be run as root. Also remember that sudo is aliased to doas in "$HOME"/.config/zsh/.zshrc. For all other commands please switch to the root user using 'su'${NC}."

else

    echo -e "${RED}This script cannot be run as the root user${NC}."

fi
