#!/usr/bin/env bash

BLUE='\033[0;36m' # Cyan color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

if [[ $UID -ne 0 ]]; then

    echo -e "${RED}Please switch users with su to run this script as root${NC}."

else

    echo "################## Editing doas config file ##################"

    touch /etc/doas.conf
    echo 'permit nopass '$USER' as root' > /etc/doas.conf
    cat /etc/doas.conf
    echo -e "${BLUE}If the above line is not 'permit nopass <yourusername> as root' then please come back to modify /etc/doas.conf${NC}"
    echo -e "${BLUE}Sleeping for 10 seconds while you read this${NC}."
    sleep 10

    echo "################## Syncing Timezones ##################"

    timedatectl set-timezone America/Los_Angeles
    systemctl enable systemd-timesyncd

    echo "################## Finding Mirrors ##################"

    reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist

    echo "################## Updating Pacman ##################"

    pacman -Syy

    echo "################## Cloning Git Repos ##################"

    echo " ------------------------- "
    echo "| cd to /usr/share/fonts/ |"
    echo " ------------------------- "

    cd /usr/share/fonts/
    git clone https://github.com/jtw023/fonts.git

    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/
    git clone https://aur.archlinux.org/paru.git

    echo " -------------------------------- "
    echo "| cd to the users home directory |"
    echo " -------------------------------- "

    cd /home/$USER

    echo " ------------------------------- "
    echo "| Pulling down librewolf config |"
    echo " ------------------------------- "

    git clone https://github.com/jtw023/.librewolf.git

    echo " --------------------------- "
    echo "| Installing zsh extensions |"
    echo " --------------------------- "

    rm -rfv .config/
    git clone https://github.com/jtw023/.config.git

    mkdir -pv /usr/share/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

    echo " ------------------------------------- "
    echo "| Installing Random-Scripts directory |"
    echo " ------------------------------------- "

    git clone https://github.com/jtw023/Random-Scripts.git
    chmod -v +x /home/$USER/Random-Scripts/*


    echo "################## Making directories and moving packages ##################"

    if [ -d "/usr/share/zsh/themes" ]; then
        cp -v /home/$USER/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    else
        mkdir -pv /usr/share/zsh/themes
        cp -v /home/$USER/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    fi

    if [ -d "/usr/share/rofi/themes" ]; then
        cp -v /home/$USER/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    else
        mkdir -pv /usr/share/rofi/themes
        cp -v /home/$USER/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    fi

    cp -v /home/$USER/.config/Xresources/.Xresources /home/$USER/.Xresources
    cp -v /home/$USER/.config/Xauthority/.Xauthority /home/$USER/.Xauthority
    cp -v /home/$USER/.config/zsh/.zshrc.root /root/.zshrc
    cp -v /home/$USER/.config/zsh/.zshenv /home/$USER/.zshenv

    echo "################## Changing ownership of the entire home directory ##################"

    chown -Rv $USER:wheel /home/$USER/

    echo -e "${GREEN} Finished. Please exit back to the normal user and run ./arch_install/paru_and_lunarvim_setup${NC}."

fi
